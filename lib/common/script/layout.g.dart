// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PPadding _$PPaddingFromJson(Map<String, dynamic> json) => PPadding(
      left: (json['left'] as num?)?.toDouble() ?? 0.0,
      top: (json['top'] as num?)?.toDouble() ?? 0.0,
      bottom: (json['bottom'] as num?)?.toDouble() ?? 0.0,
      right: (json['right'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$PPaddingToJson(PPadding instance) => <String, dynamic>{
      'left': instance.left,
      'top': instance.top,
      'bottom': instance.bottom,
      'right': instance.right,
    };

PMargins _$PMarginsFromJson(Map<String, dynamic> json) => PMargins(
      left: (json['left'] as num?)?.toDouble() ?? 0.0,
      top: (json['top'] as num?)?.toDouble() ?? 0.0,
      bottom: (json['bottom'] as num?)?.toDouble() ?? 0.0,
      right: (json['right'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$PMarginsToJson(PMargins instance) => <String, dynamic>{
      'left': instance.left,
      'top': instance.top,
      'bottom': instance.bottom,
      'right': instance.right,
    };

PPageLayout _$PPageLayoutFromJson(Map<String, dynamic> json) => PPageLayout(
      margins: json['margins'] == null
          ? const PMargins()
          : PMargins.fromJson(json['margins'] as Map<String, dynamic>),
      preferredColumnWidth:
          (json['preferredColumnWidth'] as num?)?.toDouble() ?? 360,
    );

Map<String, dynamic> _$PPageLayoutToJson(PPageLayout instance) =>
    <String, dynamic>{
      'margins': instance.margins.toJson(),
      'preferredColumnWidth': instance.preferredColumnWidth,
    };
