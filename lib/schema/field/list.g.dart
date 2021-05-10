// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PList _$PListFromJson(Map<String, dynamic> json) {
  return PList(
    validations: (json['validations'] as List)
        ?.map((e) => e == null
            ? null
            : ListValidation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PListToJson(PList instance) => <String, dynamic>{
      'validations': instance.validations?.map((e) => e?.toJson())?.toList(),
    };

ListValidation _$ListValidationFromJson(Map<String, dynamic> json) {
  return ListValidation(
    method: _$enumDecodeNullable(_$ValidateListEnumMap, json['method']),
    param: json['param'] as int,
  );
}

Map<String, dynamic> _$ListValidationToJson(ListValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateListEnumMap[instance.method],
      'param': instance.param,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ValidateListEnumMap = {
  ValidateList.containsLessThan: 'containsLessThan',
  ValidateList.containsMoreThan: 'containsMoreThan',
};
