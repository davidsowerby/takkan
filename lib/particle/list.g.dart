// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PListRead _$PListReadFromJson(Map<String, dynamic> json) {
  return PListRead(
    styleName: json['styleName'] as String,
    showCaption: json['showCaption'] as bool,
    itemConfigAsTile: json['itemConfigAsTile'] == null
        ? null
        : PListTile.fromJson(json['itemConfigAsTile'] as Map<String, dynamic>),
    itemConfigAsPanel: json['itemConfigAsPanel'] == null
        ? null
        : PPanel.fromJson(json['itemConfigAsPanel'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PListReadToJson(PListRead instance) => <String, dynamic>{
      'styleName': instance.styleName,
      'showCaption': instance.showCaption,
      'itemConfigAsTile': instance.itemConfigAsTile?.toJson(),
      'itemConfigAsPanel': instance.itemConfigAsPanel?.toJson(),
    };

PListEdit _$PListEditFromJson(Map<String, dynamic> json) {
  return PListEdit(
    styleName: json['styleName'] as String,
    showCaption: json['showCaption'] as bool,
    itemConfigAsPanel: json['itemConfigAsPanel'] == null
        ? null
        : PPanel.fromJson(json['itemConfigAsPanel'] as Map<String, dynamic>),
    itemConfigAsTile: json['itemConfigAsTile'] == null
        ? null
        : PListTile.fromJson(json['itemConfigAsTile'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PListEditToJson(PListEdit instance) => <String, dynamic>{
      'styleName': instance.styleName,
      'showCaption': instance.showCaption,
      'itemConfigAsTile': instance.itemConfigAsTile?.toJson(),
      'itemConfigAsPanel': instance.itemConfigAsPanel?.toJson(),
    };

PListTile _$PListTileFromJson(Map<String, dynamic> json) {
  return PListTile(
    titleProperty: json['titleProperty'] as String,
    subTitleProperty: json['subTitleProperty'] as String,
  );
}

Map<String, dynamic> _$PListTileToJson(PListTile instance) => <String, dynamic>{
      'titleProperty': instance.titleProperty,
      'subTitleProperty': instance.subTitleProperty,
    };

PNavTile _$PNavTileFromJson(Map<String, dynamic> json) {
  return PNavTile(
    route: json['route'] as String,
    titleProperty: json['titleProperty'] as String,
    subTitleProperty: json['subTitleProperty'] as String,
  );
}

Map<String, dynamic> _$PNavTileToJson(PNavTile instance) => <String, dynamic>{
      'titleProperty': instance.titleProperty,
      'subTitleProperty': instance.subTitleProperty,
      'route': instance.route,
    };
