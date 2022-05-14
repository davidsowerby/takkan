import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/debug.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/common/script/element.dart';
import 'package:precept_script/common/script/help.dart';
import 'package:precept_script/common/script/layout.dart';
import 'package:precept_script/common/script/precept_item.dart';
import 'package:precept_script/common/util/visitor.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/panel/panel_style.dart';
import 'package:precept_script/trait/text_trait.dart';

part 'static_panel.g.dart';

/// [children], [documentClass], [cloudFunction] see [PodBase]
@JsonSerializable(explicitToJson: true)
class PanelStatic extends PodBase implements Panels {
  @JsonKey(
    fromJson: ContentConverter.fromJson,
    toJson: ContentConverter.toJson,
  )
  @JsonKey(ignore: true)
  PanelHeading? _heading;
  final Layout layout;
  final bool openExpanded;
  final bool scrollable;
  final Help? help;
  final PanelStyle panelStyle;
  final Map<String, dynamic> pageArguments;

  factory PanelStatic.fromJson(Map<String, dynamic> json) =>
      _$PanelStaticFromJson(json);

  Map<String, dynamic> toJson() => _$PanelStaticToJson(this);

  PanelStatic({
    String? function,
    String? caption,
    String? documentClass,
    this.openExpanded = true,
    List<Content> children = const [],
    this.pageArguments = const {},
    this.layout = const LayoutDistributedColumn(),
    PanelHeading? heading,
    this.scrollable = false,
    this.help,
    this.panelStyle = const PanelStyle(),
    DataProvider? dataProvider,
    TextTrait textTrait = const TextTrait(),
    ControlEdit controlEdit = ControlEdit.inherited,
    String? id,
  })  : _heading = heading,
        super(
          id: id,
          dataProvider: dataProvider,
          controlEdit: controlEdit,
          caption: caption,
          children: children,
          documentClass: documentClass,
          layout: layout,
        );

  /// See [PreceptItem.subElements]
  List<dynamic> get subElements => [
        if (heading != null) heading,
        children,
        ...super.subElements,
      ];

  walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    if (heading != null) heading?.walk(visitors);
    for (Content entry in children) {
      entry.walk(visitors);
    }
  }

  Content get baseConfig => this;

  DebugNode get debugNode {
    final List<DebugNode> subs = children.map((e) => e.debugNode).toList();
    if (dataProviderIsDeclared) {
      final DebugNode? dn = dataProvider?.debugNode;
      if (dn != null) {
        subs.add(dn);
      }
    }
    return DebugNode(this, subs);
  }

  PanelHeading? get heading => _heading;

  @override
  bool get isDataRoot => false;
   bool get isStatic => true;
}





