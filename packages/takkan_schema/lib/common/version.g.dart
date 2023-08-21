// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Version _$VersionFromJson(Map<String, dynamic> json) => Version(
      versionIndex: json['versionIndex'] as int,
      label: json['label'] as String? ?? '',
      status: $enumDecodeNullable(_$VersionStatusEnumMap, json['status']) ??
          VersionStatus.development,
    );

Map<String, dynamic> _$VersionToJson(Version instance) => <String, dynamic>{
      'versionIndex': instance.versionIndex,
      'label': instance.label,
      'status': _$VersionStatusEnumMap[instance.status]!,
    };

const _$VersionStatusEnumMap = {
  VersionStatus.alpha: 'alpha',
  VersionStatus.beta: 'beta',
  VersionStatus.released: 'released',
  VersionStatus.deprecated: 'deprecated',
  VersionStatus.excluded: 'excluded',
  VersionStatus.expired: 'expired',
  VersionStatus.development: 'development',
};
