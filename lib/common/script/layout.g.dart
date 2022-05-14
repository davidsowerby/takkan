// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Padding _$PaddingFromJson(Map<String, dynamic> json) => Padding(
      left: (json['left'] as num?)?.toDouble() ?? 8.0,
      top: (json['top'] as num?)?.toDouble() ?? 8.0,
      bottom: (json['bottom'] as num?)?.toDouble() ?? 8.0,
      right: (json['right'] as num?)?.toDouble() ?? 8.0,
    );

Map<String, dynamic> _$PaddingToJson(Padding instance) => <String, dynamic>{
      'left': instance.left,
      'top': instance.top,
      'bottom': instance.bottom,
      'right': instance.right,
    };

LayoutDistributedColumn _$LayoutDistributedColumnFromJson(
        Map<String, dynamic> json) =>
    LayoutDistributedColumn(
      padding: json['padding'] == null
          ? const Padding()
          : Padding.fromJson(json['padding'] as Map<String, dynamic>),
      preferredColumnWidth:
          (json['preferredColumnWidth'] as num?)?.toDouble() ?? 360,
    );

Map<String, dynamic> _$LayoutDistributedColumnToJson(
        LayoutDistributedColumn instance) =>
    <String, dynamic>{
      'padding': instance.padding.toJson(),
      'preferredColumnWidth': instance.preferredColumnWidth,
    };
