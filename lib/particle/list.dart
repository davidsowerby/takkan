import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/panel/panel.dart';
import 'package:takkan_script/particle/particle.dart';

part 'list.g.dart';

/// Display of a list's entries can be a tile or a panel.
/// [itemConfigAsTile] eventually becomes a Flutter ListTile, and can only take two properties,
/// whereas the [itemConfigAsPanel] can be any structure supported by a Precept Panel
/// A [NavTile] is a specialised form which also defines a route to navigate to when tapped.
///
/// Using a List is the only occasion that a Particle contains a Panel, normally it is at the lowest
/// level of granularity
@JsonSerializable(explicitToJson: true)
class ListRead extends ReadParticle {
  final ListTile? itemConfigAsTile;
  final Panel? itemConfigAsPanel;

  ListRead(
      {super. styleName = 'default',
     super.showCaption = false,
      this.itemConfigAsTile,
      this.itemConfigAsPanel});

  factory ListRead.fromJson(Map<String, dynamic> json) =>
      _$ListReadFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ListReadToJson(this);

  @override
  Type get viewDataType => List;
}

/// Display of a list's entries can be a tile or a panel.
/// [itemConfigAsTile] eventually becomes a Flutter ListTile, and can only take two properties,
/// whereas the [itemConfigAsPanel] can be any structure supported by a Precept Panel
/// A [NavTile] is a specialised form which also defines a route to navigate to when tapped.
///
/// Using a List is the only occasion that a Particle contains a Panel, normally it is at the lowest
/// level of granularity
@JsonSerializable(explicitToJson: true)
class ListEdit {
  final ListTile? itemConfigAsTile;
  final Panel? itemConfigAsPanel;

  ListEdit(
      {String styleName = 'default',
      bool showCaption = false,
      this.itemConfigAsPanel,
      this.itemConfigAsTile});

  factory ListEdit.fromJson(Map<String, dynamic> json) =>
      _$ListEditFromJson(json);

  Map<String, dynamic> toJson() => _$ListEditToJson(this);

  Type get viewDataType => List;
}

/// Defines the property names to used to create a Flutter ListTile
@JsonSerializable(explicitToJson: true)
class ListTile {
  final String titleProperty;
  final String subTitleProperty;

  const ListTile({
    this.titleProperty = 'title',
    this.subTitleProperty = 'subTitle',
  });

  factory ListTile.fromJson(Map<String, dynamic> json) =>
      _$ListTileFromJson(json);

  Map<String, dynamic> toJson() => _$ListTileToJson(this);
}

/// Defines the property names to used to create a Flutter ListTile, and a [route] to navigate to
/// when tapped
@JsonSerializable(explicitToJson: true)
class NavTile extends ListTile {
  final String route;

  NavTile({
    required this.route,
    super. titleProperty = 'title',
    super. subTitleProperty = 'subTitle',
  }) ;
  factory NavTile.fromJson(Map<String, dynamic> json) =>
      _$NavTileFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NavTileToJson(this);
}
