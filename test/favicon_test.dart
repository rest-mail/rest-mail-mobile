import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:image/image.dart' as image;
import 'package:restmail/state/favicons.dart';

void main() {
  late Directory directory;
  late int requests;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('favicons');
    requests = 0;
  });

  tearDown(() async {
    if (await directory.exists()) await directory.delete(recursive: true);
  });

  FaviconCache cache(
    MockClient client, {
    Set<String> denied = const {},
    String version = 'test',
  }) => FaviconCache(
    clientFactory: () => client,
    directory: () async => directory,
    cacheVersion: version,
    deniedHosts: denied,
  );

  test('prefers a PNG link, fetches each host once and keeps the PNG', () async {
    final png = image.encodePng(image.Image(width: 2, height: 2));
    final ico = image.encodeIco(image.Image(width: 2, height: 2));
    final client = MockClient((request) async {
      requests++;
      switch (request.url.path) {
        case '/':
          return http.Response(
            '<html><head>'
            '<link rel="icon" href="/favicon.ico">'
            '<link rel="icon" type="image/png" sizes="64x64" href="/icon.png">'
            '</head></html>',
            200,
          );
        case '/icon.png':
          return http.Response.bytes(png, 200);
        case '/favicon.ico':
          return http.Response.bytes(ico, 200);
        default:
          return http.Response('', 404);
      }
    });
    final icons = cache(client);

    final first = await icons.iconForHost('example.com');
    expect(first, isNotNull);
    expect(first!.path, endsWith('.png'));
    expect(image.decodePng(await first.readAsBytes()), isNotNull);
    expect(requests, 2); // the page and the chosen PNG

    final second = await icons.iconForHost('example.com');
    expect(second, first);
    expect(requests, 2);
  });

  test('converts an ICO-only favicon to PNG', () async {
    final ico = image.encodeIco(image.Image(width: 2, height: 2));
    final client = MockClient((request) async {
      requests++;
      if (request.url.path == '/') return http.Response('<html></html>', 200);
      if (request.url.path == '/favicon.ico') {
        return http.Response.bytes(ico, 200);
      }
      return http.Response('', 404);
    });
    final icons = cache(client);

    final file = await icons.iconForHost('example.com');
    expect(file, isNotNull);
    final bytes = await file!.readAsBytes();
    expect(image.decodePng(bytes), isNotNull);
    expect(image.decodeIco(bytes), isNull);
  });

  test('a denied host is never fetched or served', () async {
    final client = MockClient((request) async {
      requests++;
      return http.Response.bytes(
        image.encodePng(image.Image(width: 2, height: 2)),
        200,
      );
    });
    final icons = cache(client, denied: {'example.com'});

    expect(await icons.iconForHost('example.com'), isNull);
    expect(requests, 0);
  });

  test('tries the next host when the first has no icon', () async {
    final png = image.encodePng(image.Image(width: 2, height: 2));
    final client = MockClient((request) async {
      requests++;
      if (request.url.host == 'first.test') return http.Response('', 404);
      if (request.url.path == '/') return http.Response('<html></html>', 200);
      if (request.url.path == '/favicon.ico') {
        return http.Response.bytes(png, 200);
      }
      return http.Response('', 404);
    });

    final file = await cache(client).iconFor(['first.test', 'second.test']);
    expect(file, isNotNull);
    expect(requests, greaterThan(1));
  });

  test('a cache version change starts again', () async {
    final png = image.encodePng(image.Image(width: 2, height: 2));
    final client = MockClient((request) async {
      requests++;
      if (request.url.path == '/') {
        return http.Response(
          '<link rel="icon" type="image/png" href="/icon.png">',
          200,
        );
      }
      return http.Response.bytes(png, 200);
    });

    expect(await cache(client).iconForHost('example.com'), isNotNull);
    final afterFirst = requests;
    expect(
      await cache(client, version: 'next').iconForHost('example.com'),
      isNotNull,
    );
    expect(requests, greaterThan(afterFirst));
  });
}
