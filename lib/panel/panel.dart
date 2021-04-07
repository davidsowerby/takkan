import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/debug.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/common/script/element.dart';
import 'package:precept_script/common/script/help.dart';
import 'package:precept_script/common/script/layout.dart';
import 'package:precept_script/common/script/preceptItem.dart';
import 'package:precept_script/common/util/visitor.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/panel/panelStyle.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/trait/style.dart';
import 'package:precept_script/trait/textTrait.dart';
import 'package:precept_script/validation/message.dart';

part 'panel.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PPanel extends PSubContent{
  @JsonKey(fromJson: PElementListConverter.fromJson, toJson: PElementListConverter.toJson)
  final List<PSubContent> content;
  @JsonKey(ignore: true)
  PPanelHeading _heading;
  final PPanelLayout layout;
  final bool openExpanded;
  final bool scrollable;
  final PHelp help;
  final String property;
  final PPanelStyle style;
  final Map<String, dynamic> pageArguments;

  factory PPanel.fromJson(Map<String, dynamic> json) => _$PPanelFromJson(json);

  Map<String, dynamic> toJson() => _$PPanelToJson(this);

  PPanel({
    this.openExpanded = true,
    @required this.property,
    this.content = const [],
    this.pageArguments = const {},
    this.layout=const PPanelLayout(),
    PPanelHeading heading,
    String caption,
    this.scrollable = false,
    this.help,
    this.style = const PPanelStyle(),
    IsStatic isStatic = IsStatic.inherited,
    PDataProvider dataProvider,
    PQuery query,
    PPanelStyle panelStyle = const PPanelStyle(),
    PTextTrait textTrait = const PTextTrait(),
    ControlEdit controlEdit = ControlEdit.inherited,
    String id,
  }) : _heading=heading, super(
    id: id,
    isStatic: isStatic,
    dataProvider: dataProvider,
    query: query,
    panelStyle: panelStyle,
    textTrait: textTrait,
    controlEdit: controlEdit,
    caption: caption,
  );

  @override
  doInit(PScript script, PreceptItem parent, int index, {bool useCaptionsAsIds = true}) {
    super.doInit(script, parent, index, useCaptionsAsIds: useCaptionsAsIds);
    if (heading != null) {
      heading.doInit(script, this, index, useCaptionsAsIds: useCaptionsAsIds);
    }
    int i = 0;
    for (var element in content) {
      element.doInit(script, this, i, useCaptionsAsIds: useCaptionsAsIds);
      i++;
    }
  }

  walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    if (heading != null) heading.walk(visitors);
    for (PSubContent entry in content) {
      entry.walk(visitors);
    }
  }

  void doValidate(List<ValidationMessage> messages) {
    super.doValidate(messages);
    for (PSubContent element in content) {
      element.doValidate(messages);
    }
  }

  DebugNode get debugNode {
    final List<DebugNode> children = content.map((e) => e.debugNode).toList();
    if (dataProviderIsDeclared) {
      children.add(dataProvider.debugNode);
    }
    if (queryIsDeclared) {
      children.add(query.debugNode);
    }
    return DebugNode(this, children);
  }

  PPanelHeading get heading => _heading;


}

@JsonSerializable(nullable: true, explicitToJson: true)
class PListTile extends PPanel  {

  PListTile() : super();

  factory PListTile.fromJson(Map<String, dynamic> json) =>
      _$PListTileFromJson(json);

  Map<String, dynamic> toJson() => _$PListTileToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PNavTile extends PPanel {

  PNavTile() ;

  factory PNavTile.fromJson(Map<String, dynamic> json) =>
      _$PNavTileFromJson(json);

  Map<String, dynamic> toJson() => _$PNavTileToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PPanelHeading extends PreceptItem {
  final bool expandable;
  final bool canEdit;
  final PHelp help;
  final PHeadingStyle style;

  PPanelHeading({
    this.expandable = true,
    this.canEdit = false,
    this.help,
    this.style = const PHeadingStyle(),
    String id,
  }) : super(id: id);

  factory PPanelHeading.fromJson(Map<String, dynamic> json) => _$PPanelHeadingFromJson(json);

  Map<String, dynamic> toJson() => _$PPanelHeadingToJson(this);

  PPanel get parent => super.parent;
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PPanelLayout {
  final PPadding padding;
  final double width;

  const PPanelLayout({this.padding = const PPadding(), this.width=150});

  factory PPanelLayout.fromJson(Map<String, dynamic> json) => _$PPanelLayoutFromJson(json);

  Map<String, dynamic> toJson() => _$PPanelLayoutToJson(this);
}