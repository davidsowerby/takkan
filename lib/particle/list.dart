import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/particle/particle.dart';

part 'list.g.dart';

/// Display of a list's entries can be a tile or a panel.
/// [itemConfigAsTile] eventually becomes a Flutter ListTile, and can only take two properties,
/// whereas the [itemConfigAsPanel] can be any structure supported by a Precept Panel
/// A [PNavTile] is a specialised form which also defines a route to navigate to when tapped.
///
/// Using a List is the only occasion that a Particle contains a Panel, normally it is at the lowest
/// level of granularity
@JsonSerializable(nullable: true, explicitToJson: true)
class PListRead extends PReadParticle {
  final PListTile itemConfigAsTile;
  final PPanel itemConfigAsPanel;

  PListRead(
      {String styleName = 'default',
        bool showCaption,
        this.itemConfigAsTile,
        this.itemConfigAsPanel})
      : super(showCaption: showCaption, styleName: styleName);

  factory PListRead.fromJson(Map<String, dynamic> json) => _$PListReadFromJson(json);

  Map<String, dynamic> toJson() => _$PListReadToJson(this);

  @override
  Type get viewDataType => List;
}

/// Display of a list's entries can be a tile or a panel.
/// [itemConfigAsTile] eventually becomes a Flutter ListTile, and can only take two properties,
/// whereas the [itemConfigAsPanel] can be any structure supported by a Precept Panel
/// A [PNavTile] is a specialised form which also defines a route to navigate to when tapped.
///
/// Using a List is the only occasion that a Particle contains a Panel, normally it is at the lowest
/// level of granularity
@JsonSerializable(nullable: true, explicitToJson: true)
class PListEdit extends PEditParticle {
  final PListTile itemConfigAsTile;
  final PPanel itemConfigAsPanel;
  PListEdit({String styleName = 'default', bool showCaption, this.itemConfigAsPanel, this.itemConfigAsTile})
      : super(showCaption: showCaption, styleName: styleName);

  factory PListEdit.fromJson(Map<String, dynamic> json) => _$PListEditFromJson(json);

  Map<String, dynamic> toJson() => _$PListEditToJson(this);

  @override
  Type get viewDataType => List;
}

/// Defines the property names to used to create a Flutter ListTile
@JsonSerializable(nullable: true, explicitToJson: true)
class PListTile {
  final String titleProperty;
  final String subTitleProperty;

  const PListTile({this.titleProperty = 'title', this.subTitleProperty = 'subTitle',});

  factory PListTile.fromJson(Map<String, dynamic> json) => _$PListTileFromJson(json);

  Map<String, dynamic> toJson() => _$PListTileToJson(this);
}

/// Defines the property names to used to create a Flutter ListTile, and a [route] to navigate to
/// when tapped
@JsonSerializable(nullable: true, explicitToJson: true)
class PNavTile extends PListTile {
  final String route;

  PNavTile({
    @required this.route,
    String titleProperty = 'title',
    String subTitleProperty = 'subTitle',
  }) : super(
    titleProperty: titleProperty,
    subTitleProperty: subTitleProperty,
  );

  factory PNavTile.fromJson(Map<String, dynamic> json) => _$PNavTileFromJson(json);

  Map<String, dynamic> toJson() => _$PNavTileToJson(this);
}
