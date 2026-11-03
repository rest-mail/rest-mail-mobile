// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/dmarc_received_auth_results.dart'
    as _i4;
import 'package:restmail_generated/src/model/dmarc_received_identifiers.dart'
    as _i5;
import 'package:restmail_generated/src/model/dmarc_received_row.dart' as _i6;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DmarcReceivedRecord extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DmarcReceivedRecord({
    required this.authResults,
    required this.identifiers,
    required this.row,
  });

  factory DmarcReceivedRecord.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for DmarcReceivedRecord: contains complex types',
    );
  }

  factory DmarcReceivedRecord.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DmarcReceivedRecord');
    return DmarcReceivedRecord(
      authResults: _i4.DmarcReceivedAuthResults.fromJson(
        _$map[r'auth_results'],
      ),
      identifiers: _i5.DmarcReceivedIdentifiers.fromJson(_$map[r'identifiers']),
      row: _i6.DmarcReceivedRow.fromJson(_$map[r'row']),
    );
  }

  factory DmarcReceivedRecord.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for DmarcReceivedRecord: contains complex types',
    );
  }

  final _i4.DmarcReceivedAuthResults authResults;

  final _i5.DmarcReceivedIdentifiers identifiers;

  final _i6.DmarcReceivedRow row;

  @_i3.override
  _i3.Object? toJson() => {
    r'auth_results': authResults.toJson(),
    r'identifiers': identifiers.toJson(),
    r'row': row.toJson(),
  };

  $$DmarcReceivedRecordCopyWith<DmarcReceivedRecord> get copyWith =>
      _DmarcReceivedRecordCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DmarcReceivedRecord &&
        other.authResults == this.authResults &&
        other.identifiers == this.identifiers &&
        other.row == this.row;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([authResults, identifiers, row]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for DmarcReceivedRecord: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode DmarcReceivedRecord: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DmarcReceivedRecordCopyWith<$Res> {
  factory $$DmarcReceivedRecordCopyWith(DmarcReceivedRecord value) =
      _DmarcReceivedRecordCopyWith<$Res>;

  $Res call({
    _i4.DmarcReceivedAuthResults? authResults,
    _i5.DmarcReceivedIdentifiers? identifiers,
    _i6.DmarcReceivedRow? row,
  });
  _i4.DmarcReceivedAuthResults get authResults;
  _i5.DmarcReceivedIdentifiers get identifiers;
  _i6.DmarcReceivedRow get row;
}

class _DmarcReceivedRecordCopyWith<$Res>
    implements $$DmarcReceivedRecordCopyWith<$Res> {
  _DmarcReceivedRecordCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DmarcReceivedRecord _value;

  @_i3.override
  _i4.DmarcReceivedAuthResults get authResults => _value.authResults;

  @_i3.override
  _i5.DmarcReceivedIdentifiers get identifiers => _value.identifiers;

  @_i3.override
  _i6.DmarcReceivedRow get row => _value.row;

  @_i3.override
  $Res call({
    _i3.Object? authResults = _sentinel,
    _i3.Object? identifiers = _sentinel,
    _i3.Object? row = _sentinel,
  }) {
    return (DmarcReceivedRecord(
      authResults: _i3.identical(authResults, _sentinel)
          ? this.authResults
          : (authResults as _i4.DmarcReceivedAuthResults),
      identifiers: _i3.identical(identifiers, _sentinel)
          ? this.identifiers
          : (identifiers as _i5.DmarcReceivedIdentifiers),
      row: _i3.identical(row, _sentinel)
          ? this.row
          : (row as _i6.DmarcReceivedRow),
    ) as $Res);
  }
}
