// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'string.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PString _$PStringFromJson(Map<String, dynamic> json) => PString(
      defaultValue: json['defaultValue'] as String?,
      validations: (json['validations'] as List<dynamic>?)
              ?.map((e) => VString.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
    );

Map<String, dynamic> _$PStringToJson(PString instance) {
  final val = <String, dynamic>{
    'validations': instance.validations.map((e) => e.toJson()).toList(),
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

_$_$StringGreaterThan _$$_$StringGreaterThanFromJson(
        Map<String, dynamic> json) =>
    _$_$StringGreaterThan(
      json['threshold'] as int,
    );

Map<String, dynamic> _$$_$StringGreaterThanToJson(
        _$_$StringGreaterThan instance) =>
    <String, dynamic>{
      'threshold': instance.threshold,
    };

_$_$StringLessThan _$$_$StringLessThanFromJson(Map<String, dynamic> json) =>
    _$_$StringLessThan(
      json['threshold'] as int,
    );

Map<String, dynamic> _$$_$StringLessThanToJson(_$_$StringLessThan instance) =>
    <String, dynamic>{
      'threshold': instance.threshold,
    };
