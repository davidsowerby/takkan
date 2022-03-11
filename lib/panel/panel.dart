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
import 'package:precept_script/data/select/data.dart';
import 'package:precept_script/panel/panel_style.dart';
import 'package:precept_script/trait/style.dart';
import 'package:precept_script/trait/text_trait.dart';

part 'panel.g.dart';

/// [children], [documentClass], [cloudFunction] see [PPodBase]
@JsonSerializable(explicitToJson: true)
class PPanel extends PPodBase implements PPanels {
  @JsonKey(
    fromJson: PDataListJsonConverter.fromJson,
    toJson: PDataListJsonConverter.toJson,
  )
  final List<PData> dataSelectors;
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

  factory PPanel.fromJson(Map<String, dynamic> json) => _$PPanelFromJson(json);

  Map<String, dynamic> toJson() => _$PPanelToJson(this);

  PPanel({
    String? function,
    String? caption,
    this.dataSelectors = const [const PProperty()],
    PPanel? listEntryConfig,
    String? documentClass,
    this.openExpanded = true,
    String? property,
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
          property: property,
          children: children,
          documentClass: documentClass,
          listEntryConfig: listEntryConfig,
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
  bool get isDataRoot => documentClass != null;

  bool get isStatic => false;
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

  PPodBase get parent => super.parent as PPodBase;
}

/// A Pod is a generic term for a Precept construct that contains children.
///
/// Currently the only implementations are Panel and Page.  The name is chosen mainly to avoid
/// a clash with Flutter's Container
///
/// [children] is a list of elements to display within this container
/// [documentClass] is the document class to display (Class in Back4App, Collection in Firestore).
///
/// [liveConnect] If true, a Stream of data is expected (equivalent to a Back4App LiveQuery)

abstract class PPodBase extends PContent implements PPod {
  @JsonKey(
    fromJson: PContentConverter.fromJson,
    toJson: PContentConverter.toJson,
  )
  final List<PContent> children;
  final String? _documentClass;

  @JsonKey(
    fromJson: PLayoutJsonConverter.fromJson,
    toJson: PLayoutJsonConverter.toJson,
  )
  final PLayout layout;

  PPodBase({
    required this.children,
    this.layout = const PLayoutDistributedColumn(),
    String? documentClass,
    String? caption,
    PDataProvider? dataProvider,
    String? property,
    PPanel? listEntryConfig,
    ControlEdit controlEdit = ControlEdit.inherited,
    String? id,
  })  : _documentClass = documentClass,
        super(
          caption: caption,
          property: property,
          listEntryConfig: listEntryConfig,
          dataProvider: dataProvider,
          controlEdit: controlEdit,
          id: id,
        );

  /// A computed boolean indicating whether or not the instance is at the root of a data chain
  @JsonKey(ignore: true)
  bool get isDataRoot => (_documentClass != null);

  @JsonKey(ignore: true)
  String? get documentClass {
    if (_documentClass != null) {
      return _documentClass;
    }
    if (parent is PPodBase) {
      return (parent as PPodBase).documentClass;
    }
    return null;
  }
}

abstract class PPanels {
  bool get isStatic;
}

abstract class PPod {
  List<PContent> get children;

  bool get isStatic;

  bool get isDataRoot;

  bool get dataProviderIsDeclared;

  String? get documentClass;

  PDataProvider? get dataProvider;

  String? get debugId;

  PLayout get layout;

  bool get hasEditControl;
}

/// A [PGroup] is used only to indicate to a layout component that the contained
/// elements should not be separated.  It therefore does not contain any properties
/// relating to data or appearance.
///
/// If you need to control appearance or interact with data, used a [PPanel] instead.
@JsonSerializable(explicitToJson: true)
class PGroup extends PPodBase implements PPod {
  PGroup({required List<PContent> children}) : super(children: children);

  factory PGroup.fromJson(Map<String, dynamic> json) => _$PGroupFromJson(json);

  Map<String, dynamic> toJson() => _$PGroupToJson(this);
}
