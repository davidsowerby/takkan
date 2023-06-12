// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Version _$VersionFromJson(Map<String, dynamic> json) => Version(
      number: json['number'] as int,
      label: json['label'] as String? ?? '',
      deprecated: (json['deprecated'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$VersionToJson(Version instance) => <String, dynamic>{
      'number': instance.number,
      'label': instance.label,
      'deprecated': instance.deprecated,
    };
