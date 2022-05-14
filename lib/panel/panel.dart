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
import 'package:precept_script/page/page.dart';
import 'package:precept_script/panel/panel_style.dart';
import 'package:precept_script/trait/style.dart';
import 'package:precept_script/trait/text_trait.dart';

part 'panel.g.dart';

/// [children], [documentClass], [cloudFunction] see [PodBase]
@JsonSerializable(explicitToJson: true)
class Panel extends PodBase implements Panels {
  @JsonKey(
    fromJson: DataListJsonConverter.fromJson,
    toJson: DataListJsonConverter.toJson,
  )
  final List<Data> dataSelectors;
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

  factory Panel.fromJson(Map<String, dynamic> json) => _$PanelFromJson(json);

  Map<String, dynamic> toJson() => _$PanelToJson(this);

  Panel({
    String? function,
    String? caption,
    this.dataSelectors = const [const Property()],
    Panel? listEntryConfig,
    String? documentClass,
    this.openExpanded = true,
    String? property,
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
  bool get isDataRoot => documentClass != null;

  bool get isStatic => false;
}

@JsonSerializable(explicitToJson: true)
class PanelHeading extends PreceptItem {
  final bool expandable;
  final bool canEdit;
  final Help? help;
  final HeadingStyle style;

  PanelHeading({
    this.expandable = true,
    this.canEdit = false,
    this.help,
    this.style = const HeadingStyle(),
    String? id,
  }) : super(id: id);

  factory PanelHeading.fromJson(Map<String, dynamic> json) =>
      _$PanelHeadingFromJson(json);

  Map<String, dynamic> toJson() => _$PanelHeadingToJson(this);

  PodBase get parent => super.parent as PodBase;
}

/// A Pod is a generic term for a Precept construct that contains children.
///
/// Implementations include [Panel], [Page] and [Group].  The name is chosen
/// mainly to avoid a clash with Flutter's Container
///
/// [children] is a list of elements to display within this container
/// [documentClass] is the document class to display (Class in Back4App, Collection in Firestore).
///
/// [liveConnect] If true, a Stream of data is expected (equivalent to a Back4App LiveQuery)

abstract class PodBase extends Content implements Pod {
  @JsonKey(
    fromJson: ContentConverter.fromJson,
    toJson: ContentConverter.toJson,
  )
  final List<Content> children;
  final String? _documentClass;

  @JsonKey(
    fromJson: LayoutJsonConverter.fromJson,
    toJson: LayoutJsonConverter.toJson,
  )
  final Layout layout;

  PodBase({
    required this.children,
    this.layout = const LayoutDistributedColumn(),
    String? documentClass,
    String? caption,
    DataProvider? dataProvider,
    String? property,
    Panel? listEntryConfig,
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
    if (parent is PodBase) {
      return (parent as PodBase).documentClass;
    }
    return null;
  }
}

abstract class Panels {
  bool get isStatic;
}

///
abstract class Pod {
  List<Content> get children;

  bool get isStatic;

  bool get isDataRoot;

  bool get dataProviderIsDeclared;

  String? get documentClass;

  DataProvider? get dataProvider;

  String? get debugId;

  Layout get layout;

  bool get hasEditControl;
}

/// A [Group] is used only to indicate to a layout component that the contained
/// elements should not be separated.  It therefore does not contain any properties
/// relating to data or appearance.
///
/// If you need to control appearance or interact with data, used a [Panel] instead.
@JsonSerializable(explicitToJson: true)
class Group extends PodBase implements Pod {
  Group({required List<Content> children}) : super(children: children);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
