// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PPadding _$PPaddingFromJson(Map<String, dynamic> json) {
  return PPadding(
    left: (json['left'] as num).toDouble(),
    top: (json['top'] as num).toDouble(),
    bottom: (json['bottom'] as num).toDouble(),
    right: (json['right'] as num).toDouble(),
  );
}

Map<String, dynamic> _$PPaddingToJson(PPadding instance) => <String, dynamic>{
      'left': instance.left,
      'top': instance.top,
      'bottom': instance.bottom,
      'right': instance.right,
    };

PMargins _$PMarginsFromJson(Map<String, dynamic> json) {
  return PMargins(
    left: (json['left'] as num).toDouble(),
    top: (json['top'] as num).toDouble(),
    bottom: (json['bottom'] as num).toDouble(),
    right: (json['right'] as num).toDouble(),
  );
}

Map<String, dynamic> _$PMarginsToJson(PMargins instance) => <String, dynamic>{
      'left': instance.left,
      'top': instance.top,
      'bottom': instance.bottom,
      'right': instance.right,
    };

PPageLayout _$PPageLayoutFromJson(Map<String, dynamic> json) {
  return PPageLayout(
    margins: PMargins.fromJson(json['margins'] as Map<String, dynamic>),
    preferredColumnWidth: (json['preferredColumnWidth'] as num).toDouble(),
  );
}

Map<String, dynamic> _$PPageLayoutToJson(PPageLayout instance) =>
    <String, dynamic>{
      'margins': instance.margins.toJson(),
      'preferredColumnWidth': instance.preferredColumnWidth,
    };
