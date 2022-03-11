// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PPadding _$PPaddingFromJson(Map<String, dynamic> json) => PPadding(
      left: (json['left'] as num?)?.toDouble() ?? 8.0,
      top: (json['top'] as num?)?.toDouble() ?? 8.0,
      bottom: (json['bottom'] as num?)?.toDouble() ?? 8.0,
      right: (json['right'] as num?)?.toDouble() ?? 8.0,
    );

Map<String, dynamic> _$PPaddingToJson(PPadding instance) => <String, dynamic>{
      'left': instance.left,
      'top': instance.top,
      'bottom': instance.bottom,
      'right': instance.right,
    };

PMargins _$PMarginsFromJson(Map<String, dynamic> json) => PMargins(
      left: (json['left'] as num?)?.toDouble() ?? 8.0,
      top: (json['top'] as num?)?.toDouble() ?? 8.0,
      bottom: (json['bottom'] as num?)?.toDouble() ?? 8.0,
      right: (json['right'] as num?)?.toDouble() ?? 8.0,
    );

Map<String, dynamic> _$PMarginsToJson(PMargins instance) => <String, dynamic>{
      'left': instance.left,
      'top': instance.top,
      'bottom': instance.bottom,
      'right': instance.right,
    };

PLayoutDistributedColumn _$PLayoutDistributedColumnFromJson(
        Map<String, dynamic> json) =>
    PLayoutDistributedColumn(
      padding: json['padding'] == null
          ? const PPadding()
          : PPadding.fromJson(json['padding'] as Map<String, dynamic>),
      preferredColumnWidth:
          (json['preferredColumnWidth'] as num?)?.toDouble() ?? 360,
    );

Map<String, dynamic> _$PLayoutDistributedColumnToJson(
        PLayoutDistributedColumn instance) =>
    <String, dynamic>{
      'padding': instance.padding.toJson(),
      'preferredColumnWidth': instance.preferredColumnWidth,
    };
