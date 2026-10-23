import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_scope.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../widgets/common.dart';

/// What a 403 from the admin API says, and all it says. The server decides
/// what a session may do; the app never assumes it was allowed.
const noPermission = "You don't have permission for this";

/// What to tell an admin about a failed request.
String describeAdminError(Object error, {String? host}) {
  if (error is ApiException) {
    if (error.statusCode == 403) return noPermission;
    if (error.fields.entries.firstOrNull case final field?) {
      final name = field.key.replaceAll('_', ' ');
      return '${name[0].toUpperCase()}${name.substring(1)} ${field.value}.';
    }
  }
  return describeError(error, host: host);
}

/// Bytes for a size typed in MB, or null when nothing was typed.
int? megabytes(String value) =>
    value.isEmpty ? null : int.parse(value) * 1024 * 1024;

/// What [account] may see and do in Administration, rebuilding the caller
/// when its capabilities change at a refresh.
AdminAccess adminAccessOf(
  BuildContext context,
  RestAccount account, {
  String? scope,
  bool collection = false,
}) {
  AppScope.of(context);
  return AdminAccess(
    account.capabilities,
    scope: scope,
    collection: collection,
  );
}

/// The names of the server's domains by id, for lists that give only the id;
/// none when the session may not read them.
Future<Map<int, String>> domainNames(RestAccount account) async {
  if (!AdminAccess(account.capabilities).canRead(AdminSection.domains)) {
    return const {};
  }
  try {
    final domains = await account.client.domains(limit: 200);
    return {for (final d in domains.items) d.id: d.name};
  } on ApiException {
    return const {};
  }
}

/// [value] as indented JSON, for a filter's config or a report's details.
String prettyJson(Object? value) =>
    const JsonEncoder.withIndent('  ').convert(value);

void pushScreen(BuildContext context, Widget screen) => unawaited(
  Navigator.push(context, MaterialPageRoute<void>(builder: (_) => screen)),
);

/// An inner admin screen: the top bar, and [body] when the session may see
/// [section]. One whose capability went at a refresh shows why instead.
class AdminPage extends StatelessWidget {
  const AdminPage({
    super.key,
    required this.account,
    required this.section,
    required this.title,
    required this.body,
    this.scope,
    this.collection = false,
    this.actions = const [],
  });

  final RestAccount account;
  final AdminSection section;
  final String title;
  final Widget Function(AdminAccess access) body;
  final String? scope;
  final bool collection;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final access = adminAccessOf(
      context,
      account,
      scope: scope,
      collection: collection,
    );
    final allowed = access.canRead(section);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: title,
              onBack: () => Navigator.pop(context),
              actions: allowed ? actions : const [],
            ),
            Expanded(
              child: allowed ? body(access) : const AdminMessage(noPermission),
            ),
          ],
        ),
      ),
    );
  }
}

/// A line of text in the middle of an admin screen, in place of a list.
class AdminMessage extends StatelessWidget {
  const AdminMessage(this.text, {super.key, this.onRetry});

  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final onRetry = this.onRetry;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: rmText(14, color: c.ink2, height: 1.45),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: onRetry,
                child: Text(
                  'Try again',
                  style: rmText(14, color: c.accent, weight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A detail is usable only after a successful resource GET. A refusal or a
/// missing resource replaces the old rows, including their change actions.
class AdminDetailBody extends StatelessWidget {
  const AdminDetailBody({
    super.key,
    required this.ready,
    required this.error,
    required this.host,
    required this.onRefresh,
    required this.child,
  });

  final bool ready;
  final Object? error;
  final String host;
  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (error case final failure?) {
      return AdminMessage(
        describeAdminError(failure, host: host),
        onRetry: () => unawaited(onRefresh()),
      );
    }
    if (!ready) return const Center(child: CircularProgressIndicator());
    return RefreshIndicator(onRefresh: onRefresh, child: child);
  }
}

/// An admin list, loaded a page at a time.
class AdminList<T> extends ChangeNotifier {
  /// One the server pages by offset, as most admin lists are.
  AdminList(Future<OffsetPage<T>> Function(int offset) load)
    : _load = ((next) async {
        final page = await load(int.parse(next ?? '0'));
        return (page.items, page.hasMore ? '${page.next}' : null);
      });

  /// One the server pages by cursor, as the audit log is.
  AdminList.cursor(Future<Paged<T>> Function(String? cursor) load)
    : _load = ((next) async {
        final page = await load(next);
        return (page.items, page.hasMore ? page.cursor : null);
      });

  /// The page that starts at `next`, or the first; and where the one after
  /// it starts, if there is one.
  final Future<(List<T>, String?)> Function(String? next) _load;

  List<T> items = const [];
  String? _next;
  bool loading = true;
  bool loadingMore = false;

  /// Why the list could not be loaded, shown in its place.
  ApiException? error;

  bool _disposed = false;
  int _generation = 0;

  bool get hasMore => _next != null;

  /// From the top, as after a change.
  Future<void> reload() async {
    final generation = ++_generation;
    loading = true;
    error = null;
    _notify();
    try {
      final (page, next) = await _load(null);
      if (generation != _generation) return;
      items = page;
      _next = next;
    } on ApiException catch (e) {
      if (generation != _generation) return;
      error = e;
    } finally {
      if (generation == _generation) {
        loading = false;
        _notify();
      }
    }
  }

  Future<void> loadMore() async {
    if (!hasMore || loading || loadingMore) return;
    final generation = _generation;
    loadingMore = true;
    _notify();
    try {
      final (page, next) = await _load(_next);
      if (generation != _generation) return;
      items = [...items, ...page];
      _next = next;
    } on ApiException {
      // Load more again retries.
    } finally {
      loadingMore = false;
      _notify();
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// [list] as rows in a card, with pull to refresh, "Load more" at the end,
/// and [header] above it.
class AdminListView<T> extends StatelessWidget {
  const AdminListView({
    super.key,
    required this.list,
    required this.row,
    required this.empty,
    required this.host,
    this.header = const [],
    this.onRefresh,
  });

  final AdminList<T> list;
  final Widget Function(T item) row;
  final String empty;
  final String host;
  final List<Widget> header;

  /// What pulling down does; reloading the list unless told otherwise.
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return ListenableBuilder(
      listenable: list,
      builder: (context, _) {
        final error = list.error;
        final Widget content;
        if (list.loading && list.items.isEmpty) {
          content = const Padding(
            padding: EdgeInsets.all(40),
            child: Center(
              child: SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        } else if (error != null) {
          content = AdminMessage(
            describeAdminError(error, host: host),
            onRetry: () => unawaited(list.reload()),
          );
        } else if (list.items.isEmpty) {
          content = AdminMessage(empty);
        } else {
          content = RmGroup(
            children: [for (final item in list.items) row(item)],
          );
        }
        return RefreshIndicator(
          color: c.accent,
          onRefresh: onRefresh ?? list.reload,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
            children: [
              ...header,
              content,
              if (list.hasMore && error == null) ...[
                const SizedBox(height: 12),
                Center(
                  child: list.loadingMore
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : TextButton(
                          onPressed: () => unawaited(list.loadMore()),
                          child: Text(
                            'Load more',
                            style: rmText(
                              14,
                              color: c.accent,
                              weight: FontWeight.w700,
                            ),
                          ),
                        ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// A row that adds something, at the top of a list.
class AdminAddButton extends StatelessWidget {
  const AdminAddButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: RmOutlineButton(label: label, onPressed: onTap),
  );
}

/// A field on an [AdminFormScreen]: text, or one of [choices].
class AdminField {
  const AdminField(
    this.label, {
    this.hint,
    this.initial = '',
    this.obscure = false,
    this.email = false,
    this.optional = false,
    this.number = false,
    this.choices,
  });

  final String label;
  final String? hint;
  final String initial;
  final bool obscure;

  /// An address: no autocorrect, the email keyboard.
  final bool email;

  /// May be left empty.
  final bool optional;

  /// A whole number: digits only, the number keyboard.
  final bool number;

  /// When given, the field is one of these (value, label) pairs, chosen with
  /// a tap; its value is the choice's value, starting at [initial].
  final List<(String, String)>? choices;
}

/// A few fields and a button that sends them. Pops with true once the
/// server has accepted them, and shows what it objected to if not.
class AdminFormScreen extends StatefulWidget {
  const AdminFormScreen({
    super.key,
    required this.title,
    required this.fields,
    required this.action,
    required this.submit,
    required this.host,
    this.intro,
  });

  final String title;
  final String? intro;
  final List<AdminField> fields;
  final String action;
  final String host;

  /// Sends the values, in the order of [fields], trimmed except passwords.
  final Future<void> Function(List<String> values) submit;

  /// Opens the form; true when it was sent.
  static Future<bool> open(BuildContext context, AdminFormScreen form) async =>
      await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => form),
      ) ??
      false;

  @override
  State<AdminFormScreen> createState() => _AdminFormScreenState();
}

class _AdminFormScreenState extends State<AdminFormScreen> {
  late final _controllers = [
    for (final field in widget.fields)
      TextEditingController(text: field.initial),
  ];
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  List<String> get _values => [
    for (var i = 0; i < widget.fields.length; i++)
      widget.fields[i].obscure
          ? _controllers[i].text
          : _controllers[i].text.trim(),
  ];

  bool get _ready {
    if (_busy) return false;
    final values = _values;
    for (var i = 0; i < widget.fields.length; i++) {
      final field = widget.fields[i];
      final choices = field.choices;
      if (choices != null) {
        // An empty value can be a real choice, such as sending policy None.
        if (!choices.any((choice) => choice.$1 == values[i])) return false;
      } else if (!field.optional && values[i].isEmpty) {
        return false;
      }
    }
    return true;
  }

  Future<void> _send() async {
    if (!_ready) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.submit(_values);
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = describeAdminError(e, host: widget.host);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final intro = widget.intro, error = _error;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(title: widget.title, onBack: () => Navigator.pop(context)),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                children: [
                  if (intro != null) ...[
                    Text(intro, style: rmText(15, color: c.ink2, height: 1.45)),
                    const SizedBox(height: 4),
                  ],
                  for (var i = 0; i < widget.fields.length; i++) ...[
                    const SizedBox(height: 18),
                    SectionLabel(widget.fields[i].label),
                    const SizedBox(height: 8),
                    if (widget.fields[i].choices case final choices?)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final (value, label) in choices)
                            ChoiceChip(
                              label: Text(label),
                              selected: _controllers[i].text == value,
                              onSelected: (_) => setState(() {
                                _controllers[i].text = value;
                                _error = null;
                              }),
                            ),
                        ],
                      )
                    else
                      TextField(
                        controller: _controllers[i],
                        obscureText: widget.fields[i].obscure,
                        autocorrect:
                            !widget.fields[i].obscure &&
                            !widget.fields[i].email,
                        enableSuggestions:
                            !widget.fields[i].obscure &&
                            !widget.fields[i].email,
                        keyboardType: widget.fields[i].number
                            ? TextInputType.number
                            : widget.fields[i].email
                            ? TextInputType.emailAddress
                            : null,
                        inputFormatters: widget.fields[i].number
                            ? [FilteringTextInputFormatter.digitsOnly]
                            : null,
                        textInputAction: i == widget.fields.length - 1
                            ? TextInputAction.done
                            : TextInputAction.next,
                        onChanged: (_) => setState(() => _error = null),
                        onSubmitted: i == widget.fields.length - 1
                            ? (_) => unawaited(_send())
                            : null,
                        style: rmText(16, color: c.ink),
                        decoration: InputDecoration(
                          hintText: widget.fields[i].hint,
                        ),
                      ),
                  ],
                  if (error != null) ...[
                    const SizedBox(height: 16),
                    ErrorText(error),
                  ],
                  const SizedBox(height: 26),
                  RmPrimaryButton(
                    label: widget.action,
                    busy: _busy,
                    onPressed: _ready ? () => unawaited(_send()) : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Runs an admin change from a detail screen: asks first when [confirm] is
/// given, shows the server's refusal as a toast, and says whether it went
/// through.
Future<bool> runAdminChange(
  BuildContext context, {
  required String host,
  required Future<void> Function() change,
  ({String title, String message, String action})? confirm,
}) async {
  if (confirm != null) {
    final sure = await confirmAction(
      context,
      title: confirm.title,
      message: confirm.message,
      action: confirm.action,
    );
    if (!sure || !context.mounted) return false;
  }
  try {
    await change();
    return true;
  } on ApiException catch (e) {
    if (context.mounted) {
      showToast(context, describeAdminError(e, host: host));
    }
    return false;
  }
}
