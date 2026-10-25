import 'dart:async';
import 'dart:convert';

import '../../l10n/voice.dart';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

Map<String, dynamic> _object(
  BuildContext context,
  String source,
  String label,
) {
  final value = jsonDecode(source);
  if (value is! Map<String, dynamic>) {
    throw FormatException(
      trArgs(context, 'admin.filtereditors.labelMustBeAJSONObject', {
        'label': (label).toString(),
      }),
    );
  }
  return value;
}

int _domainId(BuildContext context, String source) {
  final value = int.tryParse(source.trim());
  if (value == null || value <= 0) {
    throw FormatException(
      tr(context, 'admin.filtereditors.enterAPositiveDomainID'),
    );
  }
  return value;
}

/// Shared form shell keeps local JSON errors and server field errors visible.
/// Values remain on screen after a refusal so they can be corrected.
class _EditorFrame extends StatelessWidget {
  const _EditorFrame({
    required this.title,
    required this.children,
    required this.busy,
    required this.save,
    this.error,
    this.action = 'common.save',
  });
  final String title;
  final List<Widget> children;
  final bool busy;
  final VoidCallback save;
  final String? error;
  final String action;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          RmTopBar(title: title, onBack: () => Navigator.pop(context)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ...children,
                if (error case final message?)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      message,
                      style: rmText(14, color: context.rm.danger),
                    ),
                  ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: busy ? null : save,
                  child: Text(
                    busy
                        ? tr(context, 'admin.filtereditors.working')
                        : tr(context, action),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _field(
  TextEditingController controller,
  String label, {
  bool multiline = false,
  bool number = false,
}) => Padding(
  padding: const EdgeInsets.only(bottom: 16),
  child: TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    minLines: multiline ? 5 : 1,
    maxLines: multiline ? 16 : 1,
    keyboardType: number
        ? TextInputType.number
        : multiline
        ? TextInputType.multiline
        : TextInputType.text,
    autocorrect: false,
    enableSuggestions: false,
  ),
);

Widget _choice(
  String label,
  String value,
  List<String> choices,
  ValueChanged<String> changed,
) => Padding(
  padding: const EdgeInsets.only(bottom: 16),
  child: DropdownButtonFormField<String>(
    initialValue: value,
    decoration: InputDecoration(labelText: label),
    items: [
      for (final option in choices)
        DropdownMenuItem(value: option, child: Text(option)),
    ],
    onChanged: (value) {
      if (value != null) changed(value);
    },
  ),
);

/// A numeric field also works for pipeline operators without domains:read.
/// Operators with that permission can pick a domain from every page.
class _DomainField extends StatefulWidget {
  const _DomainField(this.account, this.controller);
  final RestAccount account;
  final TextEditingController controller;
  @override
  State<_DomainField> createState() => _DomainFieldState();
}

class _DomainFieldState extends State<_DomainField> {
  var _busy = false;
  String? _error;

  Future<void> _pick() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final domains = <AdminDomain>[];
      var offset = 0;
      while (true) {
        final page = await widget.account.client.domains(
          offset: offset,
          limit: 200,
        );
        domains.addAll(page.items);
        if (!page.hasMore || page.items.isEmpty) break;
        offset += page.items.length;
      }
      if (!mounted) return;
      final id = await showModalBottomSheet<int>(
        context: context,
        builder: (context) => SafeArea(
          child: ListView(
            children: [
              if (domains.isEmpty)
                ListTile(
                  title: Text(
                    tr(context, 'admin.filtereditors.noDomainsAvailable'),
                  ),
                ),
              for (final domain in domains)
                ListTile(
                  title: Text(domain.name),
                  subtitle: Text(
                    trArgs(context, 'admin.filtereditors.domainId', {
                      'id': (domain.id).toString(),
                    }),
                  ),
                  onTap: () => Navigator.pop(context, domain.id),
                ),
            ],
          ),
        ),
      );
      if (id != null && mounted) widget.controller.text = '$id';
    } on ApiException catch (error) {
      if (mounted) {
        setState(
          () => _error = describeAdminError(
            context,
            error,
            host: widget.account.server.host,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _field(
        widget.controller,
        tr(context, 'admin.filtereditors.domainID'),
        number: true,
      ),
      if (AdminAccess(widget.account.capabilities)
          .canRead(AdminSection.domains))
        TextButton(
          onPressed: _busy ? null : () => unawaited(_pick()),
          child: Text(
            _busy
                ? tr(context, 'admin.filtereditors.loadingDomains')
                : tr(context, 'admin.filtereditors.chooseADomain'),
          ),
        ),
      if (_error case final error?) Text(error),
    ],
  );
}

class PipelineEditorScreen extends StatefulWidget {
  const PipelineEditorScreen({super.key, required this.account, this.pipeline});
  final RestAccount account;
  final Pipeline? pipeline;
  @override
  State<PipelineEditorScreen> createState() => _PipelineEditorScreenState();
}

class _PipelineEditorScreenState extends State<PipelineEditorScreen> {
  late final _domain = TextEditingController(
    text: widget.pipeline?.domainId.toString() ?? '',
  );
  late var _direction = widget.pipeline?.direction ?? 'inbound';
  late var _active = widget.pipeline?.active ?? false;
  late final _filters = [...?widget.pipeline?.filters];
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    _domain.dispose();
    super.dispose();
  }

  Future<void> _edit([int? index]) async {
    final filter = await Navigator.push<PipelineFilter>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            _StepEditorScreen(filter: index == null ? null : _filters[index]),
      ),
    );
    if (filter != null && mounted) {
      setState(() {
        if (index == null) {
          _filters.add(filter);
        } else {
          _filters[index] = filter;
        }
      });
    }
  }

  Future<void> _save() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final existing = widget.pipeline;
      final saved = existing == null
          ? await widget.account.client.createPipeline(
              domainId: _domainId(context, _domain.text),
              direction: _direction,
              filters: _filters,
              active: _active,
            )
          : await widget.account.client.updatePipeline(
              existing.id,
              filters: _filters,
              active: _active,
            );
      if (mounted) Navigator.pop(context, saved);
    } on FormatException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = _errorFor(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _errorFor(ApiException error) =>
      describeAdminError(context, error, host: widget.account.server.host);

  @override
  Widget build(BuildContext context) => _EditorFrame(
    title: widget.pipeline == null
        ? tr(context, 'admin.filtereditors.addAPipeline')
        : tr(context, 'admin.filtereditors.editPipeline'),
    busy: _busy,
    error: _error,
    save: () => unawaited(_save()),
    children: [
      if (widget.pipeline == null) ...[
        _DomainField(widget.account, _domain),
        _choice(
          tr(context, 'admin.filtereditors.direction'),
          _direction,
          const ['inbound', 'outbound'],
          (value) => setState(() => _direction = value),
        ),
      ] else
        Text(
          trArgs(context, 'admin.filtereditors.domainValueDirection', {
            'value': (widget.pipeline!.domainId).toString(),
            'direction': (_direction).toString(),
          }),
        ),
      SwitchListTile(
        title: Text(tr(context, 'admin.filtereditors.pipelineOn')),
        value: _active,
        onChanged: _busy ? null : (value) => setState(() => _active = value),
      ),
      Text(tr(context, 'admin.filtereditors.filtersRunInTheOrderShownTap')),
      for (var i = 0; i < _filters.length; i++)
        Card(
          child: Column(
            children: [
              ListTile(
                title: Text(_filters[i].name),
                subtitle: Text(
                  '${_filters[i].type} · ${_filters[i].enabled ? tr(context, 'ui.on') : tr(context, 'ui.off')}',
                ),
                onTap: _busy ? null : () => unawaited(_edit(i)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: tr(context, 'admin.filtereditors.moveStepUp'),
                    icon: const Icon(Icons.arrow_upward),
                    onPressed: _busy || i == 0
                        ? null
                        : () => setState(() {
                            final step = _filters.removeAt(i);
                            _filters.insert(i - 1, step);
                          }),
                  ),
                  IconButton(
                    tooltip: tr(context, 'admin.filtereditors.moveStepDown'),
                    icon: const Icon(Icons.arrow_downward),
                    onPressed: _busy || i == _filters.length - 1
                        ? null
                        : () => setState(() {
                            final step = _filters.removeAt(i);
                            _filters.insert(i + 1, step);
                          }),
                  ),
                  IconButton(
                    tooltip: tr(context, 'admin.filtereditors.removeStep'),
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: _busy
                        ? null
                        : () => setState(() => _filters.removeAt(i)),
                  ),
                ],
              ),
            ],
          ),
        ),
      TextButton(
        onPressed: _busy ? null : () => unawaited(_edit()),
        child: Text(tr(context, 'admin.filtereditors.addAFilterStep')),
      ),
    ],
  );
}

class _StepEditorScreen extends StatefulWidget {
  const _StepEditorScreen({this.filter});
  final PipelineFilter? filter;
  @override
  State<_StepEditorScreen> createState() => _StepEditorScreenState();
}

class _StepEditorScreenState extends State<_StepEditorScreen> {
  late final _name = TextEditingController(text: widget.filter?.name ?? '');
  late final _config = TextEditingController(
    text: prettyJson(widget.filter?.config ?? <String, dynamic>{}),
  );
  late var _type = widget.filter?.type == 'transform' ? 'transform' : 'action';
  late var _enabled = widget.filter?.enabled ?? true;
  late var _unskippable = widget.filter?.unskippable ?? false;
  String? _error;
  @override
  void dispose() {
    _name.dispose();
    _config.dispose();
    super.dispose();
  }

  void _save() {
    try {
      if (_name.text.trim().isEmpty) {
        throw FormatException(
          tr(context, 'admin.filtereditors.enterAFilterName'),
        );
      }
      final config = _object(
        context,
        _config.text,
        tr(context, 'admin.filtereditors.configuration'),
      );
      Navigator.pop(
        context,
        PipelineFilter(
          name: _name.text.trim(),
          type: _type,
          enabled: _enabled,
          unskippable: _unskippable,
          config: config,
        ),
      );
    } on FormatException catch (error) {
      setState(() => _error = error.message);
    }
  }

  @override
  Widget build(BuildContext context) => _EditorFrame(
    title: tr(context, 'admin.filtereditors.filterStep'),
    busy: false,
    error: _error,
    save: _save,
    action: tr(context, 'admin.filtereditors.useStep'),
    children: [
      _field(_name, tr(context, 'admin.filtereditors.filterName')),
      _choice(tr(context, 'admin.filtereditors.kind'), _type, const [
        'action',
        'transform',
      ], (value) => setState(() => _type = value)),
      SwitchListTile(
        title: Text(tr(context, 'admin.filtereditors.enabled')),
        value: _enabled,
        onChanged: (value) => setState(() => _enabled = value),
      ),
      SwitchListTile(
        title: Text(tr(context, 'admin.filtereditors.alwaysRun')),
        subtitle: Text(
          tr(
            context,
            'admin.filtereditors.ignoreRequestsFromEarlierFiltersToSkip',
          ),
        ),
        value: _unskippable,
        onChanged: (value) => setState(() => _unskippable = value),
      ),
      _field(
        _config,
        tr(context, 'admin.filtereditors.configurationJSONObject'),
        multiline: true,
      ),
    ],
  );
}

class CustomFilterEditorScreen extends StatefulWidget {
  const CustomFilterEditorScreen({
    super.key,
    required this.account,
    this.filter,
  });
  final RestAccount account;
  final CustomFilter? filter;
  @override
  State<CustomFilterEditorScreen> createState() =>
      _CustomFilterEditorScreenState();
}

class _CustomFilterEditorScreenState extends State<CustomFilterEditorScreen> {
  late final _domain = TextEditingController(
    text: widget.filter?.domainId.toString() ?? '',
  );
  late final _name = TextEditingController(text: widget.filter?.name ?? '');
  late final _description = TextEditingController(
    text: widget.filter?.description ?? '',
  );
  late final _config = TextEditingController(
    text: prettyJson(
      widget.filter?.config ??
          <String, dynamic>{
            'script': 'function filter(email) { return {type: "action", action: "continue"}; }',
          },
    ),
  );
  late var _direction = widget.filter?.direction ?? 'both';
  late var _type = widget.filter?.filterType ?? 'action';
  late var _enabled = widget.filter?.enabled ?? false;
  var _busy = false;
  String? _error;
  @override
  void dispose() {
    _domain.dispose();
    _name.dispose();
    _description.dispose();
    _config.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      if (_name.text.trim().isEmpty) {
        throw FormatException(
          tr(context, 'admin.filtereditors.enterAFilterName'),
        );
      }
      final config = _object(
        context,
        _config.text,
        tr(context, 'admin.filtereditors.configuration'),
      );
      final existing = widget.filter;
      final saved = existing == null
          ? await widget.account.client.createCustomFilter(
              domainId: _domainId(context, _domain.text),
              name: _name.text.trim(),
              description: _description.text,
              filterType: _type,
              direction: _direction,
              config: config,
              enabled: _enabled,
            )
          : await widget.account.client.updateCustomFilter(
              existing.id,
              name: _name.text.trim(),
              description: _description.text,
              filterType: _type,
              direction: _direction,
              config: config,
              enabled: _enabled,
            );
      if (mounted) Navigator.pop(context, saved);
    } on FormatException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = _errorFor(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _errorFor(ApiException error) =>
      describeAdminError(context, error, host: widget.account.server.host);

  Future<void> _validate() async {
    try {
      final config = _object(
        context,
        _config.text,
        tr(context, 'admin.filtereditors.configuration'),
      );
      final script = config['script'];
      if (script is! String || script.isEmpty) {
        throw FormatException(
          tr(
            context,
            'admin.filtereditors.configurationNeedsANonemptyScriptToValidate',
          ),
        );
      }
      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (_) =>
              FilterPreviewScreen(account: widget.account, script: script),
        ),
      );
    } on FormatException catch (error) {
      if (mounted) setState(() => _error = error.message);
    }
  }

  @override
  Widget build(BuildContext context) => _EditorFrame(
    title: widget.filter == null
        ? tr(context, 'admin.filtereditors.addACustomFilter')
        : tr(context, 'admin.filtereditors.editCustomFilter'),
    busy: _busy,
    error: _error,
    save: () => unawaited(_save()),
    children: [
      if (widget.filter == null) _DomainField(widget.account, _domain),
      _field(_name, tr(context, 'folders.name')),
      _field(_description, tr(context, 'admin.filtereditors.description')),
      _choice(tr(context, 'admin.filtereditors.kind'), _type, const [
        'action',
        'transform',
      ], (value) => setState(() => _type = value)),
      _choice(tr(context, 'admin.filtereditors.direction'), _direction, const [
        'inbound',
        'outbound',
        'both',
      ], (value) => setState(() => _direction = value)),
      SwitchListTile(
        title: Text(tr(context, 'admin.filtereditors.running')),
        value: _enabled,
        onChanged: _busy ? null : (value) => setState(() => _enabled = value),
      ),
      _field(
        _config,
        tr(context, 'admin.filtereditors.configurationJSONObject'),
        multiline: true,
      ),
      TextButton(
        onPressed: _busy ? null : () => unawaited(_validate()),
        child: Text(tr(context, 'admin.filtereditors.validateJavaScript')),
      ),
    ],
  );
}

Map<String, dynamic> _sampleEmail(BuildContext context) => {
  'envelope': {
    'mail_from': 'sender@example.com',
    'rcpt_to': ['recipient@example.com'],
    'direction': 'inbound',
    'tls': false,
  },
  'headers': {
    'from': [
      {'address': 'sender@example.com'},
    ],
    'to': [
      {'address': 'recipient@example.com'},
    ],
    'subject': tr(context, 'ui.preview'),
    'date': '',
    'message-id': '<preview@example.com>',
  },
  'body': {
    'content_type': 'text/plain',
    'content': tr(context, 'ui.aSampleMessage'),
  },
};

/// JSON email input keeps every server-supported envelope/MIME field usable.
class FilterPreviewScreen extends StatefulWidget {
  const FilterPreviewScreen({
    super.key,
    required this.account,
    this.pipeline,
    this.filter,
    this.step,
    this.script,
  });
  final RestAccount account;
  final Pipeline? pipeline;
  final CustomFilter? filter;
  final PipelineFilter? step;
  final String? script;
  @override
  State<FilterPreviewScreen> createState() => _FilterPreviewScreenState();
}

class _FilterPreviewScreenState extends State<FilterPreviewScreen> {
  late final _email = TextEditingController(
    text: prettyJson(_sampleEmail(context)),
  );
  late final _script = TextEditingController(text: widget.script ?? '');
  var _busy = false;
  String? _error;
  String? _summary;
  Map<String, dynamic>? _result;
  @override
  void dispose() {
    _email.dispose();
    _script.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    setState(() {
      _busy = true;
      _error = null;
      _result = null;
      _summary = null;
    });
    try {
      final email = _email.text.trim().isEmpty
          ? null
          : _object(
              context,
              _email.text,
              tr(context, 'admin.filtereditors.sampleEmail'),
            );
      final client = widget.account.client;
      Map<String, dynamic> result;
      String summary;
      if (widget.script != null) {
        final validation = await client.validateCustomFilter(
          _script.text,
          email: email,
        );
        if (!mounted) return;
        result = validation.json;
        summary = !validation.valid
            ? trArgs(context, 'admin.filtereditors.syntaxFailedValue', {
                'value': (validation.error ?? tr(context, 'ui.invalidScript'))
                    .toString(),
              })
            : validation.dryRun?.error != null
            ? trArgs(
                context,
                'admin.filtereditors.syntaxValidDryRunFailedValue',
                {'value': (validation.dryRun!.error).toString()},
              )
            : validation.dryRun == null
            ? tr(context, 'admin.filtereditors.syntaxValid')
            : tr(context, 'admin.filtereditors.syntaxValidDryRunCompleted');
      } else if (widget.filter case final filter?) {
        final preview = await client.testCustomFilter(filter.id, email: email);
        if (!mounted) return;
        result = preview.json;
        summary = tr(context, 'admin.filtereditors.scriptCompleted');
      } else if (widget.pipeline case final pipeline?) {
        if (email == null) {
          throw FormatException(
            tr(context, 'admin.filtereditors.sampleEmailIsRequired'),
          );
        }
        final preview = await client.testPipeline(pipeline.id, email: email);
        if (!mounted) return;
        result = preview.json;
        summary = trArgs(context, 'admin.filtereditors.decisionFinalAction', {
          'finalAction': (preview.finalAction).toString(),
        });
      } else if (widget.step case final step?) {
        if (email == null) {
          throw FormatException(
            tr(context, 'admin.filtereditors.sampleEmailIsRequired'),
          );
        }
        final preview = await client.testFilter(
          filterName: step.name,
          config: step.config ?? {},
          email: email,
        );
        if (!mounted) return;
        result = preview.json;
        summary = trArgs(context, 'admin.filtereditors.decisionAction', {
          'action': (preview.action).toString(),
        });
      } else {
        throw FormatException(
          tr(context, 'admin.filtereditors.chooseAFilterToPreview'),
        );
      }
      if (mounted) {
        setState(() {
          _result = result;
          _summary = summary;
        });
      }
    } on FormatException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } on ApiException catch (error) {
      if (mounted) {
        setState(
          () => _error = describeAdminError(
            context,
            error,
            host: widget.account.server.host,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => _EditorFrame(
    title: widget.script != null
        ? tr(context, 'admin.filtereditors.validateJavaScript')
        : tr(context, 'admin.filtereditors.previewFilterExecution'),
    busy: _busy,
    error: _error,
    action: widget.script != null
        ? tr(context, 'admin.filtereditors.validate')
        : tr(context, 'admin.filtereditors.runPreview'),
    save: () => unawaited(_run()),
    children: [
      if (widget.script != null)
        _field(
          _script,
          tr(context, 'admin.filtereditors.javascript'),
          multiline: true,
        ),
      Text(
        tr(
          context,
          'admin.filtereditors.editTheCompleteSampleEmailBelowPreview',
        ),
      ),
      if (widget.filter != null || widget.script != null)
        Text(tr(context, 'admin.filtereditors.leaveTheEmailEmptyToUseThe')),
      _field(
        _email,
        tr(context, 'admin.filtereditors.sampleEmailJSONObject'),
        multiline: true,
      ),
      if (_summary case final summary?)
        Text(summary, style: const TextStyle(fontWeight: FontWeight.bold)),
      if (_result case final result?) SelectableText(prettyJson(result)),
    ],
  );
}
