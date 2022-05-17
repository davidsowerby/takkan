import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/common/debug.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/script/content.dart';
import 'package:takkan_script/script/element.dart';
import 'package:takkan_script/script/help.dart';
import 'package:takkan_script/script/layout.dart';
import 'package:takkan_script/script/takkan_item.dart';
import 'package:takkan_script/util/visitor.dart';
import 'package:takkan_script/panel/panel.dart';
import 'package:takkan_script/panel/panel_style.dart';
import 'package:takkan_script/trait/text_trait.dart';

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
  final bool openExpanded;
  final bool scrollable;
  final Help? help;
  final PanelStyle panelStyle;
  final Map<String, dynamic> pageArguments;

  factory PanelStatic.fromJson(Map<String, dynamic> json) =>
      _$PanelStaticFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PanelStaticToJson(this);

  PanelStatic({
    String? function,
    super.caption,
    super.documentClass,
    this.openExpanded = true,
    super.children = const [],
    this.pageArguments = const {},
    super.layout = const LayoutDistributedColumn(),
    PanelHeading? heading,
    this.scrollable = false,
    this.help,
    this.panelStyle = const PanelStyle(),
    super.dataProvider,
    TextTrait textTrait = const TextTrait(),
    super.controlEdit = ControlEdit.inherited,
    super.id,
  }) : _heading = heading;

  /// See [TakkanItem.subElements]
  @override
  List<dynamic> get subElements => [
        if (heading != null) heading,
        children,
        ...super.subElements,
      ];

  @override
  walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    if (heading != null) heading?.walk(visitors);
    for (Content entry in children) {
      entry.walk(visitors);
    }
  }

  Content get baseConfig => this;

  @override
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

  @override
  bool get isStatic => true;
}
