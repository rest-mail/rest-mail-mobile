// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/api_root_links.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ApiRoot extends _i1.ObjectParameterEncodable implements _i1.UriEncodable {
  const ApiRoot({
    required this.buildDate,
    required this.commit,
    required this.links,
    required this.name,
    required this.version,
  });

  factory ApiRoot.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ApiRoot: contains complex types',
    );
  }

  factory ApiRoot.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ApiRoot');
    return ApiRoot(
      buildDate: _$map[r'build_date'].decodeJsonString(
        context: r'ApiRoot.build_date',
      ),
      commit: _$map[r'commit'].decodeJsonString(context: r'ApiRoot.commit'),
      links: _i4.ApiRootLinks.fromJson(_$map[r'links']),
      name: _$map[r'name'].decodeJsonString(context: r'ApiRoot.name'),
      version: _$map[r'version'].decodeJsonString(context: r'ApiRoot.version'),
    );
  }

  factory ApiRoot.fromForm(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ApiRoot: contains complex types',
    );
  }

  final _i3.String buildDate;

  final _i3.String commit;

  final _i4.ApiRootLinks links;

  final _i3.String name;

  final _i3.String version;

  @_i3.override
  _i3.Object? toJson() => {
    r'build_date': buildDate,
    r'commit': commit,
    r'links': links.toJson(),
    r'name': name,
    r'version': version,
  };

  $$ApiRootCopyWith<ApiRoot> get copyWith => _ApiRootCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ApiRoot &&
        other.buildDate == this.buildDate &&
        other.commit == this.commit &&
        other.links == this.links &&
        other.name == this.name &&
        other.version == this.version;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([buildDate, commit, links, name, version]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ApiRoot: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ApiRoot: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ApiRootCopyWith<$Res> {
  factory $$ApiRootCopyWith(ApiRoot value) = _ApiRootCopyWith<$Res>;

  $Res call({
    _i3.String? buildDate,
    _i3.String? commit,
    _i4.ApiRootLinks? links,
    _i3.String? name,
    _i3.String? version,
  });
  _i3.String get buildDate;
  _i3.String get commit;
  _i4.ApiRootLinks get links;
  _i3.String get name;
  _i3.String get version;
}

class _ApiRootCopyWith<$Res> implements $$ApiRootCopyWith<$Res> {
  _ApiRootCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ApiRoot _value;

  @_i3.override
  _i3.String get buildDate => _value.buildDate;

  @_i3.override
  _i3.String get commit => _value.commit;

  @_i3.override
  _i4.ApiRootLinks get links => _value.links;

  @_i3.override
  _i3.String get name => _value.name;

  @_i3.override
  _i3.String get version => _value.version;

  @_i3.override
  $Res call({
    _i3.Object? buildDate = _sentinel,
    _i3.Object? commit = _sentinel,
    _i3.Object? links = _sentinel,
    _i3.Object? name = _sentinel,
    _i3.Object? version = _sentinel,
  }) {
    return (ApiRoot(
      buildDate: _i3.identical(buildDate, _sentinel)
          ? this.buildDate
          : (buildDate as _i3.String),
      commit: _i3.identical(commit, _sentinel)
          ? this.commit
          : (commit as _i3.String),
      links: _i3.identical(links, _sentinel)
          ? this.links
          : (links as _i4.ApiRootLinks),
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String),
      version: _i3.identical(version, _sentinel)
          ? this.version
          : (version as _i3.String),
    ) as $Res);
  }
}
