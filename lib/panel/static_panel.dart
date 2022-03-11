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

/// [children], [documentClass], [cloudFunction] see [PPodBase]
@JsonSerializable(explicitToJson: true)
class PPanelStatic extends PPodBase implements PPanels {
  @JsonKey(
    fromJson: PContentConverter.fromJson,
    toJson: PContentConverter.toJson,
  )
  @JsonKey(ignore: true)
  PPanelHeading? _heading;
  final PLayout layout;
  final bool openExpanded;
  final bool scrollable;
  final PHelp? help;
  final PPanelStyle panelStyle;
  final Map<String, dynamic> pageArguments;



  factory PPanelStatic.fromJson(Map<String, dynamic> json) => _$PPanelStaticFromJson(json);

  Map<String, dynamic> toJson() => _$PPanelStaticToJson(this);

  PPanelStatic({
    String? function,
    String? caption,
    String? documentClass,
    this.openExpanded = true,
    List<PContent> children = const [],
    this.pageArguments = const {},
    this.layout = const PLayoutDistributedColumn(),
    PPanelHeading? heading,
    this.scrollable = false,
    this.help,
    this.panelStyle = const PPanelStyle(),
    PDataProvider? dataProvider,
    PTextTrait textTrait = const PTextTrait(),
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
    for (PContent entry in children) {
      entry.walk(visitors);
    }
  }

  PContent get baseConfig => this;

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

  PPanelHeading? get heading => _heading;

  @override
  bool get isDataRoot => false;
   bool get isStatic => true;
}





