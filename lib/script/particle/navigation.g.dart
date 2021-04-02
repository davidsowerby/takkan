// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PNavParticle _$PNavParticleFromJson(Map<String, dynamic> json) {
  return PNavParticle(
    route: json['route'] as String,
    args: json['args'] as Map<String, dynamic>,
    caption: json['caption'] as String,
    styleName: json['styleName'] as String,
    showCaption: json['showCaption'] as bool,
  );
}

Map<String, dynamic> _$PNavParticleToJson(PNavParticle instance) =>
    <String, dynamic>{
      'styleName': instance.styleName,
      'showCaption': instance.showCaption,
      'route': instance.route,
      'caption': instance.caption,
      'args': instance.args,
    };

PNavPart _$PNavPartFromJson(Map<String, dynamic> json) {
  return PNavPart(
    readOnly: json['readOnly'] as bool,
    caption: json['caption'] as String,
    property: json['property'] as String,
    staticData: json['staticData'] as String,
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PNavPartToJson(PNavPart instance) => <String, dynamic>{
      'version': instance.version,
      'caption': instance.caption,
      'readOnly': instance.readOnly,
      'property': instance.property,
      'staticData': instance.staticData,
    };

PNavButtonSet _$PNavButtonSetFromJson(Map<String, dynamic> json) {
  return PNavButtonSet()..version = json['version'] as int;
}

Map<String, dynamic> _$PNavButtonSetToJson(PNavButtonSet instance) =>
    <String, dynamic>{
      'version': instance.version,
    };

PNavButtonSetParticle _$PNavButtonSetParticleFromJson(
    Map<String, dynamic> json) {
  return PNavButtonSetParticle(
    buttons: (json['buttons'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    width: (json['width'] as num)?.toDouble(),
    height: (json['height'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PNavButtonSetParticleToJson(
        PNavButtonSetParticle instance) =>
    <String, dynamic>{
      'buttons': instance.buttons,
      'width': instance.width,
      'height': instance.height,
    };
