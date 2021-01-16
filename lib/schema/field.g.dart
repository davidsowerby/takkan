// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBoolean _$PBooleanFromJson(Map<String, dynamic> json) {
  return PBoolean(
    defaultValue: json['defaultValue'] as bool,
  );
}

Map<String, dynamic> _$PBooleanToJson(PBoolean instance) => <String, dynamic>{
      'defaultValue': instance.defaultValue,
    };

PInteger _$PIntegerFromJson(Map<String, dynamic> json) {
  return PInteger(
    defaultValue: json['defaultValue'] as int,
  );
}

Map<String, dynamic> _$PIntegerToJson(PInteger instance) => <String, dynamic>{
      'defaultValue': instance.defaultValue,
    };

PString _$PStringFromJson(Map<String, dynamic> json) {
  return PString(
    defaultValue: json['defaultValue'] as String,
  );
}

Map<String, dynamic> _$PStringToJson(PString instance) => <String, dynamic>{
      'defaultValue': instance.defaultValue,
    };

PDate _$PDateFromJson(Map<String, dynamic> json) {
  return PDate(
    defaultValue:
        json['defaultValue'] == null ? null : DateTime.parse(json['defaultValue'] as String),
  );
}

Map<String, dynamic> _$PDateToJson(PDate instance) => <String, dynamic>{
      'defaultValue': instance.defaultValue?.toIso8601String(),
    };

PPointer _$PPointerFromJson(Map<String, dynamic> json) {
  return PPointer();
}

Map<String, dynamic> _$PPointerToJson(PPointer instance) => <String, dynamic>{};

PDouble _$PDoubleFromJson(Map<String, dynamic> json) {
  return PDouble(
    defaultValue: (json['defaultValue'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PDoubleToJson(PDouble instance) => <String, dynamic>{
      'defaultValue': instance.defaultValue,
    };

PGeoPosition _$PGeoPositionFromJson(Map<String, dynamic> json) {
  return PGeoPosition(
    defaultValue: json['defaultValue'] == null
        ? null
        : GeoPosition.fromJson(json['defaultValue'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PGeoPositionToJson(PGeoPosition instance) => <String, dynamic>{
      'defaultValue': instance.defaultValue?.toJson(),
    };

PPostCode _$PPostCodeFromJson(Map<String, dynamic> json) {
  return PPostCode(
    defaultValue: json['defaultValue'] == null
        ? null
        : PostCode.fromJson(json['defaultValue'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PPostCodeToJson(PPostCode instance) => <String, dynamic>{
      'defaultValue': instance.defaultValue?.toJson(),
    };

PGeoLocation _$PGeoLocationFromJson(Map<String, dynamic> json) {
  return PGeoLocation(
    defaultValue: json['defaultValue'] == null
        ? null
        : GeoLocation.fromJson(json['defaultValue'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PGeoLocationToJson(PGeoLocation instance) => <String, dynamic>{
      'defaultValue': instance.defaultValue?.toJson(),
    };
