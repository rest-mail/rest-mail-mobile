import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail/state/whats_new.dart';

Map<String, Object?> _release(int version) => {
  'tag_name': 'v0.3.$version',
  'name': 'Release $version',
  'body': 'Changes for $version.\n\n* Inbox fix #$version',
};

Map<String, Object> _document(int latest) => releaseHistoryDocument([
  for (var n = latest - 11; n <= latest; n++) _release(n),
]);

http.Response _json(Object value) => http.Response.bytes(
  utf8.encode(jsonEncode(value)),
  200,
  headers: {'content-type': 'application/json'},
);

void main() {
  late Directory directory;
  setUp(
    () async =>
        directory = await Directory.systemTemp.createTemp('whats-new-test-'),
  );
  tearDown(() async => directory.delete(recursive: true));

  WhatsNewService service(
    Future<http.Response> Function(http.Request) handler,
  ) {
    final client = MockClient(handler);
    addTearDown(client.close);
    return WhatsNewService(
      httpClient: client,
      cacheDirectory: () async => directory,
      fetchInDevelopment: true,
    );
  }

  Future<void> save(int latest) =>
      File('${directory.path}/whats-new.json')
          .writeAsString(jsonEncode(_document(latest)))
          .then((_) {});

  test('one history asset supplies ten versions and one cache file', () async {
    final requests = <Uri>[];
    final notes = await service((request) async {
      requests.add(request.url);
      return _json(_document(101));
    }).load();

    expect(requests, [WhatsNewService.historyUrl]);
    expect(notes!.releases.map((r) => r.version), [
      for (var n = 101; n >= 92; n--) '0.3.$n',
    ]);
    expect(notes.releases.first.items.single.number, 101);
    expect(directory.listSync().map((f) => f.path.split('/').last), [
      'whats-new.json',
    ]);
    final cached = jsonDecode(
      await File('${directory.path}/whats-new.json').readAsString(),
    ) as Map<String, dynamic>;
    expect(WhatsNewHistory.fromJson(cached).releases, hasLength(10));
  });

  test('cached history can be read without a network request', () async {
    await save(101);
    final notes = await service(
      (_) async => throw StateError('No request expected'),
    ).load();
    expect(notes!.releases.first.version, '0.3.101');
  });

  test('offline refresh preserves the complete cached history', () async {
    await save(101);
    final notes = await service(
      (_) async => throw http.ClientException('Offline'),
    ).load(refresh: true);
    expect(notes!.releases, hasLength(10));
    expect(notes.releases.first.version, '0.3.101');
    expect(directory.listSync(), hasLength(1));
  });

  test(
    'an old release without an asset bootstraps the same document once',
    () async {
      final requests = <Uri>[];
      final source = service((request) async {
        requests.add(request.url);
        if (request.url == WhatsNewService.historyUrl) {
          return http.Response('', 404);
        }
        return _json([for (var n = 90; n <= 101; n++) _release(n)]);
      });
      final notes = await source.load();
      expect(requests, hasLength(2));
      expect(requests.last.path, '/repos/rest-mail/rest-mail-mobile/releases');
      expect(requests.last.queryParameters, {'per_page': '100'});
      expect(notes!.releases.first.version, '0.3.101');
      expect(notes.releases, hasLength(10));
      await source.load();
      expect(requests, hasLength(2));
      expect(directory.listSync(), hasLength(1));
    },
  );

  test('malformed downloaded history cannot overwrite a good cache', () async {
    await save(101);
    final notes = await service(
      (_) async => _json({'schema': 1, 'releases': <Object?>[]}),
    ).load(refresh: true);
    expect(notes!.releases.first.version, '0.3.101');
    final raw = jsonDecode(
      await File('${directory.path}/whats-new.json').readAsString(),
    ) as Map<String, dynamic>;
    expect(WhatsNewHistory.fromJson(raw).releases.first.version, '0.3.101');
  });

  test(
    'a GitHub refusal without a cache gives a retryable empty result',
    () async {
      final notes = await service(
        (request) async => http.Response(
          '',
          request.url == WhatsNewService.historyUrl ? 404 : 403,
        ),
      ).load(refresh: true);
      expect(notes, isNull);
      expect(directory.listSync(), isEmpty);
    },
  );

  test('a newly published version replaces the one cache document', () async {
    await save(101);
    final notes = await service((_) async => _json(_document(102)))
        .load(refresh: true);
    expect(notes!.releases.first.version, '0.3.102');
    expect(notes.releases.last.version, '0.3.93');
    expect(directory.listSync(), hasLength(1));
    final raw = jsonDecode(
      await File('${directory.path}/whats-new.json').readAsString(),
    ) as Map<String, dynamic>;
    expect(WhatsNewHistory.fromJson(raw).releases.first.version, '0.3.102');
  });

  test(
    'an unreadable old cache is replaced by valid downloaded notes',
    () async {
      await File('${directory.path}/whats-new.json').writeAsString('broken');
      final source = service((_) async => _json(_document(101)));
      expect((await source.load())!.releases.first.version, '0.3.101');
      expect((await source.readCache())!.releases, hasLength(10));
    },
  );

  test('notes still load if the cache directory cannot be written', () async {
    final blocked = File('${directory.path}/not-a-directory');
    await blocked.writeAsString('occupied');
    final client = MockClient((_) async => _json(_document(101)));
    addTearDown(client.close);
    final source = WhatsNewService(
      httpClient: client,
      cacheDirectory: () async => Directory(blocked.path),
      fetchInDevelopment: true,
    );
    expect((await source.load())!.releases, hasLength(10));
  });
}
