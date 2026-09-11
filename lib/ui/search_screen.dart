import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../state/mailbox_state.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import '../util/search_parser.dart';
import 'message_screen.dart';
import 'widgets/common.dart';
import 'widgets/message_row.dart';

/// Server-side search of the current account, with the filters the chips
/// suggest (`from:`, `in:`, `has:attachment`).
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.mailbox});

  final MailboxState mailbox;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  /// Kept while the app runs; never written to disk.
  static final _recent = <String>[];
  static const _suggestions = ['has:attachment', 'in:sent', 'from:'];

  final _query = TextEditingController();
  Timer? _debounce;
  int _runs = 0;
  bool _searching = false;
  Paged<Message>? _results;
  int _elapsedMs = 0;
  ApiException? _error;

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  void _changed(String text) {
    _debounce?.cancel();
    if (text.trim().isEmpty) {
      _runs++;
      setState(() {
        _results = null;
        _error = null;
        _searching = false;
      });
      return;
    }
    setState(() {});
    _debounce = Timer(
      const Duration(milliseconds: 400),
      () => unawaited(_run(text)),
    );
  }

  Future<void> _run(String text) async {
    final account = widget.mailbox.account;
    final query = text.trim();
    if (account == null || query.isEmpty) return;
    _debounce?.cancel();
    final run = ++_runs;
    setState(() {
      _searching = true;
      _error = null;
    });
    final watch = Stopwatch()..start();
    try {
      final page = await widget.mailbox.client.search(
        account.id,
        parseSearch(query),
      );
      if (!mounted || run != _runs) return;
      setState(() {
        _results = page;
        _elapsedMs = watch.elapsedMilliseconds;
        _searching = false;
      });
      _recent
        ..remove(query)
        ..insert(0, query);
      if (_recent.length > 6) _recent.removeLast();
    } on ApiException catch (e) {
      if (!mounted || run != _runs) return;
      setState(() {
        _error = e;
        _searching = false;
      });
    }
  }

  void _pick(String chip) {
    // A bare `from:` waits for the name; anything else searches at once.
    final waits = chip.endsWith(':');
    _query.text = chip;
    _query.selection = TextSelection.collapsed(offset: _query.text.length);
    if (waits) {
      setState(() {});
    } else {
      unawaited(_run(chip));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final query = _query.text.trim();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: c.line)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: c.surface,
                        border: Border.all(color: c.accentLine, width: 1.5),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search_rounded, size: 18, color: c.ink3),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _query,
                              autofocus: true,
                              autocorrect: false,
                              textInputAction: TextInputAction.search,
                              onChanged: _changed,
                              onSubmitted: (text) => unawaited(_run(text)),
                              style: rmText(15.5, color: c.ink),
                              decoration: bareInput(
                                context,
                                'Search mail',
                                size: 15.5,
                              ),
                            ),
                          ),
                          if (_searching)
                            SizedBox.square(
                              dimension: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.6,
                                color: c.ink3,
                              ),
                            )
                          else if (query.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _query.clear();
                                _changed('');
                              },
                              child: Icon(
                                Icons.close_rounded,
                                size: 17,
                                color: c.ink3,
                                semanticLabel: 'Clear',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Done',
                      style: rmText(
                        15,
                        color: c.accent,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (query.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionLabel(_recent.isEmpty ? 'Try' : 'Recent'),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final chip
                            in _recent.isEmpty ? _suggestions : _recent)
                          _Chip(label: chip, onTap: () => _pick(chip)),
                      ],
                    ),
                  ],
                ),
              )
            else
              Expanded(child: _resultList(context, query)),
          ],
        ),
      ),
    );
  }

  Widget _resultList(BuildContext context, String query) {
    final c = context.rm;
    final error = _error, results = _results;
    return ListView(
      padding: const EdgeInsets.only(bottom: 40),
      children: [
        if (error != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: ErrorText(
              describeError(error, host: widget.mailbox.client.server.host),
            ),
          )
        else if (results != null && results.items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Text(
              'No messages match “$query”.',
              textAlign: TextAlign.center,
              style: rmText(14, color: c.ink3, height: 1.5),
            ),
          )
        else if (results != null) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Text(
              '${countLabel(results.items.length)}${results.hasMore ? '+' : ''} '
              '${results.items.length == 1 ? 'result' : 'results'} · $_elapsedMs ms',
              style: rmText(12, color: c.ink3, weight: FontWeight.w600),
            ),
          ),
          for (final message in results.items)
            MessageRow(
              message: message,
              dense: true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) =>
                      MessageScreen(mailbox: widget.mailbox, message: message),
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final shape = StadiumBorder(side: BorderSide(color: c.line));
    return Material(
      color: c.surface,
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          child: Text(
            label,
            style: rmText(13.5, color: c.ink, weight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
