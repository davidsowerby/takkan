import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/common/debug.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/script/content.dart';
import 'package:takkan_script/script/element.dart';
import 'package:takkan_script/script/help.dart';
import 'package:takkan_script/script/layout.dart';
import 'package:takkan_script/script/takkan_item.dart';
import 'package:takkan_script/util/visitor.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/select/data.dart';
import 'package:takkan_script/page/page.dart';
import 'package:takkan_script/panel/panel_style.dart';
import 'package:takkan_script/trait/style.dart';

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

  final bool openExpanded;
  final bool scrollable;
  final Help? help;
  final PanelStyle panelStyle;
  final Map<String, dynamic> pageArguments;

  factory Panel.fromJson(Map<String, dynamic> json) => _$PanelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PanelToJson(this);

  Panel({
    String? function,
    super.caption,
    this.dataSelectors = const [Property()],
    super.listEntryConfig,
    super.documentClass,
    this.openExpanded = true,
    super.property,
    super.children = const [],
    this.pageArguments = const {},
    super.layout = const LayoutDistributedColumn(),
    PanelHeading? heading,
    this.scrollable = false,
    this.help,
    this.panelStyle = const PanelStyle(),
    super.dataProvider,
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
  bool get isDataRoot => documentClass != null;

  @override
  bool get isStatic => false;
}

@JsonSerializable(explicitToJson: true)
class PanelHeading extends TakkanItem {
  final bool expandable;
  final bool canEdit;
  final Help? help;
  final HeadingStyle style;

  PanelHeading({
    this.expandable = true,
    this.canEdit = false,
    this.help,
    this.style = const HeadingStyle(),
    super.id,
  });

  factory PanelHeading.fromJson(Map<String, dynamic> json) =>
      _$PanelHeadingFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PanelHeadingToJson(this);

  @override
  PodBase get parent => super.parent as PodBase;
}

/// A Pod is a generic term for a Takkan construct that contains children.
///
/// Implementations include [Panel], [Page] and [Group].  The name is chosen
/// mainly to avoid a clash with Flutter's Container
///
/// [children] is a list of elements to display within this container
/// [documentClass] is the document class to display (Class in Back4App, Collection in Firestore).
///
/// [liveConnect] If true, a Stream of data is expected (equivalent to a Back4App LiveQuery)

abstract class PodBase extends Content implements Pod {
  @override
  @JsonKey(
    fromJson: ContentConverter.fromJson,
    toJson: ContentConverter.toJson,
  )
  final List<Content> children;
  final String? _documentClass;

  @override
  @JsonKey(
    fromJson: LayoutJsonConverter.fromJson,
    toJson: LayoutJsonConverter.toJson,
  )
  final Layout layout;

  PodBase({
    required this.children,
    this.layout = const LayoutDistributedColumn(),
    String? documentClass,
    super.caption,
    super.dataProvider,
    super.property,
    super.listEntryConfig,
    super.controlEdit = ControlEdit.inherited,
    super.id,
  }) : _documentClass = documentClass;

  /// A computed boolean indicating whether or not the instance is at the root of a data chain
  @override
  @JsonKey(ignore: true)
  bool get isDataRoot => (_documentClass != null);

  @override
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
  Group({required super.children});

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
