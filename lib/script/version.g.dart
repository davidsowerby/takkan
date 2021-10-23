// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PVersion _$PVersionFromJson(Map<String, dynamic> json) => PVersion(
      number: json['number'] as int,
      label: json['label'] as String? ?? '',
      deprecated: (json['deprecated'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PVersionToJson(PVersion instance) => <String, dynamic>{
      'number': instance.number,
      'label': instance.label,
      'deprecated': instance.deprecated,
    };
