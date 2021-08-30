// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PList _$PListFromJson(Map<String, dynamic> json) {
  return PList(
    validations: (json['validations'] as List<dynamic>)
        .map((e) => ListValidation.fromJson(e as Map<String, dynamic>))
        .toList(),
    permissions:
        PPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
    required: json['required'] as bool,
    defaultValue: json['defaultValue'] as List<dynamic>?,
  );
}

Map<String, dynamic> _$PListToJson(PList instance) {
  final val = <String, dynamic>{
    'validations': instance.validations.map((e) => e.toJson()).toList(),
    'permissions': instance.permissions?.toJson(),
    'required': instance.required,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('defaultValue', instance.defaultValue);
  return val;
}

ListValidation _$ListValidationFromJson(Map<String, dynamic> json) {
  return ListValidation(
    method: _$enumDecode(_$ValidateListEnumMap, json['method']),
    param: json['param'] as int,
  );
}

Map<String, dynamic> _$ListValidationToJson(ListValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateListEnumMap[instance.method],
      'param': instance.param,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$ValidateListEnumMap = {
  ValidateList.containsLessThan: 'containsLessThan',
  ValidateList.containsMoreThan: 'containsMoreThan',
};
