import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/debug.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/constants.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/common/script/element.dart';
import 'package:precept_script/common/script/help.dart';
import 'package:precept_script/common/script/layout.dart';
import 'package:precept_script/common/script/precept_item.dart';
import 'package:precept_script/common/util/visitor.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/panel/panel_style.dart';
import 'package:precept_script/query/query.dart';
import 'package:precept_script/trait/style.dart';
import 'package:precept_script/trait/text_trait.dart';
import 'package:precept_script/validation/message.dart';

part 'panel.g.dart';

@JsonSerializable(explicitToJson: true)
class PPanel extends PSubContent {
  @JsonKey(
      fromJson: PElementListConverter.fromJson,
      toJson: PElementListConverter.toJson)
  final List<PSubContent> content;
  @JsonKey(ignore: true)
  PPanelHeading? _heading;
  final PPanelLayout layout;
  final bool openExpanded;
  final bool scrollable;
  final PHelp? help;
  final PPanelStyle panelStyle;
  final Map<String, dynamic> pageArguments;

  factory PPanel.fromJson(Map<String, dynamic> json) => _$PPanelFromJson(json);

  Map<String, dynamic> toJson() => _$PPanelToJson(this);

  PPanel({
    this.openExpanded = true,
    String property = notSet,
    this.content = const [],
    this.pageArguments = const {},
    this.layout = const PPanelLayout(),
    PPanelHeading? heading,
    String? caption,
    this.scrollable = false,
    this.help,
    this.panelStyle = const PPanelStyle(),
    IsStatic isStatic = IsStatic.inherited,
    PDataProvider? dataProvider,
    PQuery? query,
    PTextTrait textTrait = const PTextTrait(),
    ControlEdit controlEdit = ControlEdit.inherited,
    String? id,
  })  : _heading = heading,
        super(
          id: id,
          isStatic: isStatic,
          dataProvider: dataProvider,
          query: query,
          controlEdit: controlEdit,
          caption: caption,
          property: property,
        );

  List<dynamic> get children => [
        if (heading != null) heading,
        content,
        ...super.children,
      ];

  walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    if (heading != null) heading?.walk(visitors);
    for (PSubContent entry in content) {
      entry.walk(visitors);
    }
  }

  DebugNode get debugNode {
    final List<DebugNode> children = content.map((e) => e.debugNode).toList();
    if (dataProviderIsDeclared) {
      final DebugNode? dn = dataProvider?.debugNode;
      if (dn != null) {
        children.add(dn);
      }
    }
    if (queryIsDeclared) {
      final DebugNode? dn = query?.debugNode;
      if (dn != null) {
        children.add(dn);
      }
    }
    return DebugNode(this, children);
  }

  PPanelHeading? get heading => _heading;
}

@JsonSerializable(explicitToJson: true)
class PPanelHeading extends PreceptItem {
  final bool expandable;
  final bool canEdit;
  final PHelp? help;
  final PHeadingStyle style;

  PPanelHeading({
    this.expandable = true,
    this.canEdit = false,
    this.help,
    this.style = const PHeadingStyle(),
    String? id,
  }) : super(id: id);

  factory PPanelHeading.fromJson(Map<String, dynamic> json) =>
      _$PPanelHeadingFromJson(json);

  Map<String, dynamic> toJson() => _$PPanelHeadingToJson(this);

  PPanel get parent => super.parent as PPanel;
}

@JsonSerializable(explicitToJson: true)
class PPanelLayout {
  final PPadding padding;
  final double? width;

  const PPanelLayout({this.padding = const PPadding(), this.width});

  factory PPanelLayout.fromJson(Map<String, dynamic> json) =>
      _$PPanelLayoutFromJson(json);

  Map<String, dynamic> toJson() => _$PPanelLayoutToJson(this);
}
