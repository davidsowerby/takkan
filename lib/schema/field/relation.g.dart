// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PRelation _$PRelationFromJson(Map<String, dynamic> json) {
  return PRelation(
    defaultValue: json['defaultValue'] == null
        ? null
        : Relation.fromJson(json['defaultValue'] as Map<String, dynamic>),
    targetClass: json['targetClass'] as String,
    validations: (json['validations'] as List<dynamic>)
        .map((e) => RelationValidation.fromJson(e as Map<String, dynamic>))
        .toList(),
    required: json['required'] as bool,
  );
}

Map<String, dynamic> _$PRelationToJson(PRelation instance) {
  final val = <String, dynamic>{
    'validations': instance.validations.map((e) => e.toJson()).toList(),
    'required': instance.required,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('defaultValue', instance.defaultValue?.toJson());
  val['targetClass'] = instance.targetClass;
  return val;
}

RelationValidation _$RelationValidationFromJson(Map<String, dynamic> json) {
  return RelationValidation(
    method: _$enumDecode(_$ValidateRelationEnumMap, json['method']),
    param: json['param'] == null
        ? null
        : Relation.fromJson(json['param'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RelationValidationToJson(RelationValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateRelationEnumMap[instance.method],
      'param': instance.param?.toJson(),
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

const _$ValidateRelationEnumMap = {
  ValidateRelation.isValid: 'isValid',
};
