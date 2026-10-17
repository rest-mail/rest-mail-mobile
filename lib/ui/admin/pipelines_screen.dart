import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

String _directionLabel(String direction) => switch (direction) {
  'inbound' => 'Coming in',
  'outbound' => 'Going out',
  'both' => 'Both ways',
  _ => direction,
};

String _typeLabel(String type) => switch (type) {
  'action' => 'Can stop a message',
  'transform' => 'Changes a message',
  _ => type,
};

String _domainOf(Map<int, String> names, int id) => names[id] ?? 'Domain $id';

/// What a phone does with filters: looks, turns them on and off, and
/// deletes. Their filters and configs are edited in the admin webmail.
const _editElsewhere = 'Filters are edited in the admin webmail.';

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
  late final _list = AdminList<Pipeline>(
    (offset) => widget.account.client.pipelines(offset: offset),
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

  Future<void> _open(Pipeline pipeline) async {
    final done = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => PipelineScreen(
          account: widget.account,
          pipeline: pipeline,
          domain: _domainOf(_domains, pipeline.domainId),
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
    title: 'Pipelines',
    body: (_) => AdminListView(
      list: _list,
      host: widget.account.server.host,
      empty: 'No domain has a pipeline.',
      onRefresh: _reload,
      row: (pipeline) => RmRow(
        label: _domainOf(_domains, pipeline.domainId),
        subtitle: [
          _directionLabel(pipeline.direction),
          pipeline.filters.length == 1
              ? '1 filter'
              : '${pipeline.filters.length} filters',
          if (!pipeline.active) 'Off',
        ].join(' · '),
        onTap: () => unawaited(_open(pipeline)),
      ),
    ),
  );
}

/// One pipeline: on or off, its filters in the order they run, and with
/// `pipelines:delete`, a way to delete it. Pops with what was done.
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

  Future<void> _delete() async {
    setState(() => _busy = true);
    final ok = await runAdminChange(
      context,
      host: _host,
      change: () => widget.account.client.deletePipeline(_pipeline.id),
      confirm: (
        title: 'Delete this pipeline?',
        message:
            'Mail ${_pipeline.direction == 'inbound' ? 'to' : 'from'} '
            '${widget.domain} no longer goes through its filters.',
        action: 'Delete',
      ),
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, 'Deleted the pipeline');
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
                label:
                    'Mail ${_directionLabel(pipeline.direction).toLowerCase()}',
                value: access.canWrite(AdminSection.pipelines)
                    ? null
                    : (pipeline.active ? 'On' : 'Off'),
                trailing: access.canWrite(AdminSection.pipelines)
                    ? RmSwitch(
                        value: pipeline.active,
                        label: 'Pipeline on',
                        onChanged: (value) {
                          if (!_busy) unawaited(_setActive(value));
                        },
                      )
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 22),
          const SectionLabel('Filters, in order'),
          const SizedBox(height: 9),
          if (pipeline.filters.isEmpty)
            Text(
              'None: mail passes straight through.',
              style: rmText(14, color: c.ink2),
            )
          else
            RmGroup(
              children: [
                for (final filter in pipeline.filters)
                  RmRow(
                    label: filter.name,
                    subtitle: [
                      _typeLabel(filter.type),
                      if (filter.unskippable) 'always runs',
                    ].join(', '),
                    value: filter.enabled ? 'On' : 'Off',
                  ),
              ],
            ),
          const SizedBox(height: 10),
          Text(_editElsewhere, style: rmText(13, color: c.ink3)),
          if (access.canDelete(AdminSection.pipelines)) ...[
            const SizedBox(height: 22),
            RmGroup(
              children: [
                RmRow(
                  label: 'Delete pipeline',
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
  late final _list = AdminList<CustomFilter>(
    (offset) => widget.account.client.customFilters(offset: offset),
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

  Future<void> _open(CustomFilter filter) async {
    final done = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => CustomFilterScreen(
          account: widget.account,
          filter: filter,
          domain: _domainOf(_domains, filter.domainId),
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
    title: 'Custom filters',
    body: (_) => AdminListView(
      list: _list,
      host: widget.account.server.host,
      empty: 'No filters have been written for this server.',
      onRefresh: _reload,
      row: (filter) => RmRow(
        label: filter.name,
        subtitle: [
          _domainOf(_domains, filter.domainId),
          _directionLabel(filter.direction),
          if (!filter.enabled) 'Off',
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

  Future<void> _delete() async {
    setState(() => _busy = true);
    final name = _filter.name;
    final ok = await runAdminChange(
      context,
      host: _host,
      change: () => widget.account.client.deleteCustomFilter(_filter.id),
      confirm: (
        title: 'Delete $name?',
        message: 'Pipelines that use it stop running it.',
        action: 'Delete',
      ),
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, 'Deleted $name');
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
                label: 'Running',
                value: access.canWrite(AdminSection.customFilters)
                    ? null
                    : (filter.enabled ? 'On' : 'Off'),
                trailing: access.canWrite(AdminSection.customFilters)
                    ? RmSwitch(
                        value: filter.enabled,
                        label: 'Running',
                        onChanged: (value) {
                          if (!_busy) unawaited(_setEnabled(value));
                        },
                      )
                    : null,
              ),
              RmRow(label: 'Domain', value: widget.domain),
              RmRow(label: 'Mail', value: _directionLabel(filter.direction)),
              RmRow(label: 'Kind', value: _typeLabel(filter.filterType)),
            ],
          ),
          if (filter.config != null) ...[
            const SizedBox(height: 22),
            const SectionLabel('What it does'),
            const SizedBox(height: 9),
            SelectableText(
              prettyJson(filter.config),
              style: rmText(13, color: c.ink2, height: 1.45),
            ),
            const SizedBox(height: 10),
            Text(_editElsewhere, style: rmText(13, color: c.ink3)),
          ],
          if (access.canDelete(AdminSection.customFilters)) ...[
            const SizedBox(height: 22),
            RmGroup(
              children: [
                RmRow(
                  label: 'Delete filter',
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
