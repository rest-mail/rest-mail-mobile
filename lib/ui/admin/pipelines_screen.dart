import 'dart:async';

import '../../l10n/voice.dart';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';
import 'filter_editors.dart';

String _directionLabel(BuildContext context, String direction) =>
    switch (direction) {
      'inbound' => tr(context, 'admin.pipelinelog.comingIn'),
      'outbound' => tr(context, 'admin.pipelinelog.goingOut'),
      'both' => tr(context, 'admin.pipelines.bothWays'),
      _ => direction,
    };

String _typeLabel(BuildContext context, String type) => switch (type) {
  'action' => tr(context, 'admin.pipelines.canStopAMessage'),
  'transform' => tr(context, 'admin.pipelines.changesAMessage'),
  _ => type,
};

String _domainOf(BuildContext context, Map<int, String> names, int id) =>
    names[id] ??
    trArgs(context, 'admin.filtereditors.domainId', {'id': (id).toString()});

Future<int?> _chooseDomainFilter(BuildContext context, int? current) async {
  final controller = TextEditingController(text: current?.toString() ?? '');
  final result = await showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(tr(context, 'admin.pipelines.filterByDomain')),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: tr(context, 'admin.filtereditors.domainID'),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(tr(context, 'common.cancel')),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 0),
          child: Text(tr(context, 'admin.pipelines.allDomains')),
        ),
        TextButton(
          onPressed: () {
            final id = int.tryParse(controller.text.trim());
            if (id != null && id > 0) {
              Navigator.pop(context, id);
            }
          },
          child: Text(tr(context, 'admin.pipelines.apply')),
        ),
      ],
    ),
  );
  await Future<void>.delayed(const Duration(milliseconds: 300));
  controller.dispose();
  return result;
}

/// Each domain's pipelines, one for mail coming in and one for mail going
/// out, with the filters each runs in order.
class PipelinesScreen extends StatefulWidget {
  const PipelinesScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<PipelinesScreen> createState() => _PipelinesScreenState();
}

class _PipelinesScreenState extends State<PipelinesScreen> {
  var _domains = const <int, String>{};
  int? _domainId;
  late final _list = AdminList<Pipeline>(
    (offset) =>
        widget.account.client.pipelines(offset: offset, domainId: _domainId),
  );

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities)
        .canRead(AdminSection.pipelines)) {
      unawaited(_reload());
    }
  }

  @override
  void dispose() {
    _list.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final names = domainNames(widget.account);
    await _list.reload();
    final domains = await names;
    if (mounted) setState(() => _domains = domains);
  }

  Future<void> _add() async {
    final saved = await Navigator.push<Pipeline>(
      context,
      MaterialPageRoute(
        builder: (_) => PipelineEditorScreen(account: widget.account),
      ),
    );
    if (!mounted || saved == null) return;
    await _list.reload();
    if (mounted) await _open(saved);
  }

  Future<void> _filterDomain() async {
    final result = await _chooseDomainFilter(context, _domainId);
    if (!mounted || result == null) return;
    setState(() => _domainId = result == 0 ? null : result);
    await _list.reload();
  }

  Future<void> _open(Pipeline pipeline) async {
    final done = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => PipelineScreen(
          account: widget.account,
          pipeline: pipeline,
          domain: _domainOf(context, _domains, pipeline.domainId),
        ),
      ),
    );
    if (!mounted) return;
    if (done != null) showToast(context, done);
    unawaited(_list.reload());
  }

  @override
  Widget build(BuildContext context) => AdminPage(
    account: widget.account,
    section: AdminSection.pipelines,
    title: tr(context, 'admin.section.pipelines.title'),
    body: (access) => AdminListView(
      list: _list,
      header: [
        if (access.canWrite(AdminSection.pipelines))
          AdminAddButton(
            label: tr(context, 'admin.filtereditors.addAPipeline'),
            onTap: () => unawaited(_add()),
          ),
        TextButton(
          onPressed: () => unawaited(_filterDomain()),
          child: Text(
            _domainId == null
                ? tr(context, 'admin.pipelines.filterByDomain')
                : trArgs(
                    context,
                    'admin.pipelines.domainDomainIdChangeFilter',
                    {'domainId': (_domainId).toString()},
                  ),
          ),
        ),
      ],
      host: widget.account.server.host,
      empty: tr(context, 'admin.pipelines.noDomainHasAPipeline'),
      onRefresh: _reload,
      row: (pipeline) => RmRow(
        label: _domainOf(context, _domains, pipeline.domainId),
        subtitle: [
          _directionLabel(context, pipeline.direction),
          pipeline.filters.length == 1
              ? tr(context, 'ui.1Filter')
              : trArgs(context, 'ui.lengthFilters', {
                  'length': (pipeline.filters.length).toString(),
                }),
          if (!pipeline.active) tr(context, 'twoFactor.off'),
        ].join(' · '),
        onTap: () => unawaited(_open(pipeline)),
      ),
    ),
  );
}

/// One pipeline, including its full configuration and preview tools.
class PipelineScreen extends StatefulWidget {
  const PipelineScreen({
    super.key,
    required this.account,
    required this.pipeline,
    required this.domain,
  });

  final RestAccount account;
  final Pipeline pipeline;
  final String domain;

  @override
  State<PipelineScreen> createState() => _PipelineScreenState();
}

class _PipelineScreenState extends State<PipelineScreen> {
  late var _pipeline = widget.pipeline;
  var _busy = false;

  String get _host => widget.account.server.host;

  Future<void> _setActive(bool active) async {
    setState(() => _busy = true);
    await runAdminChange(
      context,
      host: _host,
      change: () async => _pipeline = await widget.account.client
          .updatePipeline(_pipeline.id, active: active),
    );
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _edit() async {
    final saved = await Navigator.push<Pipeline>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PipelineEditorScreen(account: widget.account, pipeline: _pipeline),
      ),
    );
    if (saved != null && mounted) setState(() => _pipeline = saved);
  }

  Future<void> _delete() async {
    setState(() => _busy = true);
    final ok = await runAdminChange(
      context,
      host: _host,
      change: () => widget.account.client.deletePipeline(_pipeline.id),
      confirm: (
        title: tr(context, 'admin.pipelines.deleteThisPipeline'),
        message: trArgs(
          context,
          'admin.pipelines.mailValueDomainNoLongerGoesThrough',
          {
            'value':
                (_pipeline.direction == 'inbound'
                        ? tr(context, 'ui.to')
                        : tr(context, 'ui.from'))
                    .toString(),
            'domain': (widget.domain).toString(),
          },
        ),
        action: tr(context, 'message.delete'),
      ),
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, tr(context, 'admin.pipelines.deletedThePipeline'));
    } else {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final pipeline = _pipeline;
    return AdminPage(
      account: widget.account,
      section: AdminSection.pipelines,
      title: widget.domain,
      body: (access) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
        children: [
          RmGroup(
            children: [
              RmRow(
                label: trArgs(context, 'admin.pipelines.mailValue', {
                  'value': (_directionLabel(
                    context,
                    pipeline.direction,
                  ).toLowerCase()).toString(),
                }),
                value: access.canWrite(AdminSection.pipelines)
                    ? null
                    : (pipeline.active
                          ? tr(context, 'twoFactor.on')
                          : tr(context, 'twoFactor.off')),
                trailing: access.canWrite(AdminSection.pipelines)
                    ? RmSwitch(
                        value: pipeline.active,
                        label: tr(context, 'admin.filtereditors.pipelineOn'),
                        onChanged: (value) {
                          if (!_busy) unawaited(_setActive(value));
                        },
                      )
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 22),
          SectionLabel(tr(context, 'admin.pipelines.filtersInOrder')),
          const SizedBox(height: 9),
          if (pipeline.filters.isEmpty)
            Text(
              tr(context, 'admin.pipelines.noneMailPassesStraightThrough'),
              style: rmText(14, color: c.ink2),
            )
          else
            RmGroup(
              children: [
                for (final filter in pipeline.filters)
                  RmRow(
                    label: filter.name,
                    subtitle: [
                      _typeLabel(context, filter.type),
                      if (filter.unskippable)
                        tr(context, 'admin.pipelines.alwaysRuns'),
                    ].join(', '),
                    value: filter.enabled
                        ? tr(context, 'twoFactor.on')
                        : tr(context, 'twoFactor.off'),
                    onTap: access.canWrite(AdminSection.pipelines)
                        ? () => pushScreen(
                            context,
                            FilterPreviewScreen(
                              account: widget.account,
                              step: filter,
                            ),
                          )
                        : null,
                  ),
              ],
            ),
          const SizedBox(height: 10),
          if (access.canWrite(AdminSection.pipelines))
            RmGroup(
              children: [
                RmRow(
                  label: tr(context, 'admin.filtereditors.editPipeline'),
                  onTap: _busy ? null : () => unawaited(_edit()),
                ),
                RmRow(
                  label: tr(context, 'admin.pipelines.previewSavedPipeline'),
                  onTap: _busy
                      ? null
                      : () => pushScreen(
                          context,
                          FilterPreviewScreen(
                            account: widget.account,
                            pipeline: _pipeline,
                          ),
                        ),
                ),
              ],
            ),
          const SizedBox(height: 12),
          SelectableText(
            prettyJson([
              for (final filter in pipeline.filters) filter.toJson(),
            ]),
            style: rmText(13, color: c.ink2, height: 1.45),
          ),
          if (pipeline.createdAt case final created?)
            RmRow(
              label: tr(context, 'admin.pipelines.created'),
              value: created.toLocal().toString(),
            ),
          if (pipeline.updatedAt case final updated?)
            RmRow(
              label: tr(context, 'admin.pipelines.updated'),
              value: updated.toLocal().toString(),
            ),
          if (access.canDelete(AdminSection.pipelines)) ...[
            const SizedBox(height: 22),
            RmGroup(
              children: [
                RmRow(
                  label: tr(context, 'admin.pipelines.deletePipeline'),
                  danger: true,
                  onTap: _busy ? null : () => unawaited(_delete()),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// The filters written for this server, which pipelines run like the
/// built-in ones.
class CustomFiltersScreen extends StatefulWidget {
  const CustomFiltersScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<CustomFiltersScreen> createState() => _CustomFiltersScreenState();
}

class _CustomFiltersScreenState extends State<CustomFiltersScreen> {
  var _domains = const <int, String>{};
  int? _domainId;
  late final _list = AdminList<CustomFilter>(
    (offset) => widget.account.client.customFilters(
      offset: offset,
      domainId: _domainId,
    ),
  );

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities)
        .canRead(AdminSection.customFilters)) {
      unawaited(_reload());
    }
  }

  @override
  void dispose() {
    _list.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final names = domainNames(widget.account);
    await _list.reload();
    final domains = await names;
    if (mounted) setState(() => _domains = domains);
  }

  Future<void> _add() async {
    final saved = await Navigator.push<CustomFilter>(
      context,
      MaterialPageRoute(
        builder: (_) => CustomFilterEditorScreen(account: widget.account),
      ),
    );
    if (!mounted || saved == null) return;
    await _list.reload();
    if (mounted) await _open(saved);
  }

  Future<void> _filterDomain() async {
    final result = await _chooseDomainFilter(context, _domainId);
    if (!mounted || result == null) return;
    setState(() => _domainId = result == 0 ? null : result);
    await _list.reload();
  }

  Future<void> _open(CustomFilter filter) async {
    try {
      filter = await widget.account.client.customFilter(filter.id);
    } on ApiException catch (error) {
      if (mounted) {
        showToast(
          context,
          describeAdminError(context, error, host: widget.account.server.host),
        );
      }
      return;
    }
    if (!mounted) return;
    final done = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => CustomFilterScreen(
          account: widget.account,
          filter: filter,
          domain: _domainOf(context, _domains, filter.domainId),
        ),
      ),
    );
    if (!mounted) return;
    if (done != null) showToast(context, done);
    unawaited(_list.reload());
  }

  @override
  Widget build(BuildContext context) => AdminPage(
    account: widget.account,
    section: AdminSection.customFilters,
    title: tr(context, 'admin.section.customFilters.title'),
    body: (access) => AdminListView(
      list: _list,
      header: [
        if (access.canWrite(AdminSection.customFilters))
          AdminAddButton(
            label: tr(context, 'admin.filtereditors.addACustomFilter'),
            onTap: () => unawaited(_add()),
          ),
        TextButton(
          onPressed: () => unawaited(_filterDomain()),
          child: Text(
            _domainId == null
                ? tr(context, 'admin.pipelines.filterByDomain')
                : trArgs(
                    context,
                    'admin.pipelines.domainDomainIdChangeFilter',
                    {'domainId': (_domainId).toString()},
                  ),
          ),
        ),
      ],
      host: widget.account.server.host,
      empty: tr(context, 'admin.pipelines.noFiltersHaveBeenWrittenForThis'),
      onRefresh: _reload,
      row: (filter) => RmRow(
        label: filter.name,
        subtitle: [
          _domainOf(context, _domains, filter.domainId),
          _directionLabel(context, filter.direction),
          if (!filter.enabled) tr(context, 'twoFactor.off'),
        ].join(' · '),
        onTap: () => unawaited(_open(filter)),
      ),
    ),
  );
}

/// One custom filter: what it is for, on or off, and what it does, as JSON.
class CustomFilterScreen extends StatefulWidget {
  const CustomFilterScreen({
    super.key,
    required this.account,
    required this.filter,
    required this.domain,
  });

  final RestAccount account;
  final CustomFilter filter;
  final String domain;

  @override
  State<CustomFilterScreen> createState() => _CustomFilterScreenState();
}

class _CustomFilterScreenState extends State<CustomFilterScreen> {
  late var _filter = widget.filter;
  var _busy = false;

  String get _host => widget.account.server.host;

  Future<void> _setEnabled(bool enabled) async {
    setState(() => _busy = true);
    await runAdminChange(
      context,
      host: _host,
      change: () async => _filter = await widget.account.client
          .updateCustomFilter(_filter.id, enabled: enabled),
    );
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _edit() async {
    final saved = await Navigator.push<CustomFilter>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CustomFilterEditorScreen(account: widget.account, filter: _filter),
      ),
    );
    if (saved != null && mounted) setState(() => _filter = saved);
  }

  Future<void> _delete() async {
    setState(() => _busy = true);
    final name = _filter.name;
    final ok = await runAdminChange(
      context,
      host: _host,
      change: () => widget.account.client.deleteCustomFilter(_filter.id),
      confirm: (
        title: trArgs(context, 'folders.deleteTitle', {
          'name': (name).toString(),
        }),
        message: tr(context, 'admin.pipelines.pipelinesThatUseItStopRunningIt'),
        action: tr(context, 'message.delete'),
      ),
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pop(
        context,
        trArgs(context, 'admin.domains.deletedName', {
          'name': (name).toString(),
        }),
      );
    } else {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final filter = _filter;
    return AdminPage(
      account: widget.account,
      section: AdminSection.customFilters,
      title: filter.name,
      body: (access) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
        children: [
          if (filter.description.isNotEmpty) ...[
            Text(
              filter.description,
              style: rmText(15, color: c.ink2, height: 1.45),
            ),
            const SizedBox(height: 18),
          ],
          RmGroup(
            children: [
              RmRow(
                label: tr(context, 'admin.filtereditors.running'),
                value: access.canWrite(AdminSection.customFilters)
                    ? null
                    : (filter.enabled
                          ? tr(context, 'twoFactor.on')
                          : tr(context, 'twoFactor.off')),
                trailing: access.canWrite(AdminSection.customFilters)
                    ? RmSwitch(
                        value: filter.enabled,
                        label: tr(context, 'admin.filtereditors.running'),
                        onChanged: (value) {
                          if (!_busy) unawaited(_setEnabled(value));
                        },
                      )
                    : null,
              ),
              RmRow(
                label: tr(context, 'admin.aliases.domain'),
                value: widget.domain,
              ),
              RmRow(
                label: tr(context, 'admin.pipelines.mail'),
                value: _directionLabel(context, filter.direction),
              ),
              RmRow(
                label: tr(context, 'admin.filtereditors.kind'),
                value: _typeLabel(context, filter.filterType),
              ),
            ],
          ),
          if (filter.config != null) ...[
            const SizedBox(height: 22),
            SectionLabel(tr(context, 'admin.pipelines.whatItDoes')),
            const SizedBox(height: 9),
            SelectableText(
              prettyJson(filter.config),
              style: rmText(13, color: c.ink2, height: 1.45),
            ),
            const SizedBox(height: 10),
            if (access.canWrite(AdminSection.customFilters))
              RmGroup(
                children: [
                  RmRow(
                    label: tr(context, 'admin.filtereditors.editCustomFilter'),
                    onTap: _busy ? null : () => unawaited(_edit()),
                  ),
                  RmRow(
                    label: tr(context, 'admin.pipelines.testSavedCustomFilter'),
                    onTap: _busy
                        ? null
                        : () => pushScreen(
                            context,
                            FilterPreviewScreen(
                              account: widget.account,
                              filter: _filter,
                            ),
                          ),
                  ),
                  if (filter.config case {'script': final String script})
                    RmRow(
                      label: tr(
                        context,
                        'admin.filtereditors.validateJavaScript',
                      ),
                      onTap: _busy
                          ? null
                          : () => pushScreen(
                              context,
                              FilterPreviewScreen(
                                account: widget.account,
                                script: script,
                              ),
                            ),
                    ),
                ],
              ),
          ],
          if (filter.createdAt case final created?)
            RmRow(
              label: tr(context, 'admin.pipelines.created'),
              value: created.toLocal().toString(),
            ),
          if (filter.updatedAt case final updated?)
            RmRow(
              label: tr(context, 'admin.pipelines.updated'),
              value: updated.toLocal().toString(),
            ),
          if (access.canDelete(AdminSection.customFilters)) ...[
            const SizedBox(height: 22),
            RmGroup(
              children: [
                RmRow(
                  label: tr(context, 'admin.pipelines.deleteFilter'),
                  danger: true,
                  onTap: _busy ? null : () => unawaited(_delete()),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
