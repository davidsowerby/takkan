// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PFile _$PFileFromJson(Map<String, dynamic> json) {
  return PFile(
    defaultValue: json['defaultValue'] as String?,
    validations: (json['validations'] as List<dynamic>)
        .map((e) => FileValidation.fromJson(e as Map<String, dynamic>))
        .toList(),
    permissions: json['permissions'] == null
        ? null
        : PPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
    required: json['required'] as bool,
  );
}

Map<String, dynamic> _$PFileToJson(PFile instance) {
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

FileValidation _$FileValidationFromJson(Map<String, dynamic> json) {
  return FileValidation(
    method: _$enumDecode(_$ValidateFileEnumMap, json['method']),
    param: json['param'] as bool?,
  );
}

Map<String, dynamic> _$FileValidationToJson(FileValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateFileEnumMap[instance.method],
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

const _$ValidateFileEnumMap = {
  ValidateFile.exists: 'exists',
};
