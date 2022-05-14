// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListRead _$ListReadFromJson(Map<String, dynamic> json) => ListRead(
      styleName: json['styleName'] as String? ?? 'default',
      showCaption: json['showCaption'] as bool? ?? false,
      itemConfigAsTile: json['itemConfigAsTile'] == null
          ? null
          : ListTile.fromJson(json['itemConfigAsTile'] as Map<String, dynamic>),
      itemConfigAsPanel: json['itemConfigAsPanel'] == null
          ? null
          : Panel.fromJson(json['itemConfigAsPanel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListReadToJson(ListRead instance) => <String, dynamic>{
      'styleName': instance.styleName,
      'showCaption': instance.showCaption,
      'itemConfigAsTile': instance.itemConfigAsTile?.toJson(),
      'itemConfigAsPanel': instance.itemConfigAsPanel?.toJson(),
    };

ListEdit _$ListEditFromJson(Map<String, dynamic> json) => ListEdit(
      itemConfigAsPanel: json['itemConfigAsPanel'] == null
          ? null
          : Panel.fromJson(json['itemConfigAsPanel'] as Map<String, dynamic>),
      itemConfigAsTile: json['itemConfigAsTile'] == null
          ? null
          : ListTile.fromJson(json['itemConfigAsTile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListEditToJson(ListEdit instance) => <String, dynamic>{
      'itemConfigAsTile': instance.itemConfigAsTile?.toJson(),
      'itemConfigAsPanel': instance.itemConfigAsPanel?.toJson(),
    };

ListTile _$ListTileFromJson(Map<String, dynamic> json) => ListTile(
      titleProperty: json['titleProperty'] as String? ?? 'title',
      subTitleProperty: json['subTitleProperty'] as String? ?? 'subTitle',
    );

Map<String, dynamic> _$ListTileToJson(ListTile instance) => <String, dynamic>{
      'titleProperty': instance.titleProperty,
      'subTitleProperty': instance.subTitleProperty,
    };

NavTile _$NavTileFromJson(Map<String, dynamic> json) => NavTile(
      route: json['route'] as String,
      titleProperty: json['titleProperty'] as String? ?? 'title',
      subTitleProperty: json['subTitleProperty'] as String? ?? 'subTitle',
    );

Map<String, dynamic> _$NavTileToJson(NavTile instance) => <String, dynamic>{
      'titleProperty': instance.titleProperty,
      'subTitleProperty': instance.subTitleProperty,
      'route': instance.route,
    };
