// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PListBoolean _$PListBooleanFromJson(Map<String, dynamic> json) {
  return PListBoolean(
    defaultValue: (json['defaultValue'] as List)?.map((e) => e as bool)?.toList(),
  );
}

Map<String, dynamic> _$PListBooleanToJson(PListBoolean instance) => <String, dynamic>{
      'defaultValue': instance.defaultValue,
    };

PListString _$PListStringFromJson(Map<String, dynamic> json) {
  return PListString(
    defaultValue: (json['defaultValue'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$PListStringToJson(PListString instance) => <String, dynamic>{
      'defaultValue': instance.defaultValue,
    };

PGeoRegion _$PGeoRegionFromJson(Map<String, dynamic> json) {
  return PGeoRegion(
    defaultValue: (json['defaultValue'] as List)
        ?.map((e) => e == null ? null : GeoPosition.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PGeoRegionToJson(PGeoRegion instance) => <String, dynamic>{
      'defaultValue': instance.defaultValue?.map((e) => e?.toJson())?.toList(),
    };
