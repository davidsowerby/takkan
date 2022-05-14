// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FInteger _$FIntegerFromJson(Map<String, dynamic> json) => FInteger(
      defaultValue: json['defaultValue'] as int?,
      validations: (json['validations'] as List<dynamic>?)
              ?.map((e) => VInteger.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
    );

Map<String, dynamic> _$FIntegerToJson(FInteger instance) {
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

_$_$IntegerGreaterThan _$$_$IntegerGreaterThanFromJson(
        Map<String, dynamic> json) =>
    _$_$IntegerGreaterThan(
      json['threshold'] as int,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$_$IntegerGreaterThanToJson(
        _$_$IntegerGreaterThan instance) =>
    <String, dynamic>{
      'threshold': instance.threshold,
      'runtimeType': instance.$type,
    };

_$_$IntegerLessThan _$$_$IntegerLessThanFromJson(Map<String, dynamic> json) =>
    _$_$IntegerLessThan(
      json['threshold'] as int,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$_$IntegerLessThanToJson(_$_$IntegerLessThan instance) =>
    <String, dynamic>{
      'threshold': instance.threshold,
      'runtimeType': instance.$type,
    };
