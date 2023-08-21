// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_schema/common/debug.dart';
import 'package:takkan_schema/takkan/takkan_element.dart';
import 'package:takkan_schema/util/walker.dart';

import '../data/provider/data_provider.dart';
import '../data/select/data_selector.dart';
import '../page/page.dart';
import '../script/content.dart';
import '../script/element.dart';
import '../script/help.dart';
import '../script/layout.dart';
import '../script/script_element.dart';

part 'panel.g.dart';

/// [children], [documentClass], [cloudFunction] see [PodBase]
@JsonSerializable(explicitToJson: true)
class Panel extends PodBase implements Panels {
  Panel({
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
    super.dataProvider,
    super.controlEdit = ControlEdit.inherited,
    super.id,
  }) : _heading = heading;

  factory Panel.fromJson(Map<String, dynamic> json) => _$PanelFromJson(json);

  @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  List<Object?> get props => [
        ...super.props,
        dataSelectors,
        openExpanded,
        pageArguments,
        _heading,
        scrollable,
        help
      ];
  @JsonKey(
    fromJson: DataListJsonConverter.fromJson,
    toJson: DataListJsonConverter.toJson,
  )
  final List<DataSelector> dataSelectors;
  @JsonKey(
    fromJson: ContentConverter.fromJson,
    toJson: ContentConverter.toJson,
  )
  @JsonKey(includeToJson: false, includeFromJson: false)
  PanelHeading? _heading;

  final bool openExpanded;
  final bool scrollable;
  final Help? help;
  final Map<String, dynamic> pageArguments;

  @override
  Map<String, dynamic> toJson() => _$PanelToJson(this);

  /// See [TakkanElement.subElements]
  @override
  List<Object> get subElements => [
        if (heading != null) heading!,
        children,
        ...super.subElements,
      ];

  @override
  void walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    if (heading != null) {
      heading?.walk(visitors);
    }
    for (final Content entry in children) {
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
class PanelHeading extends TakkanElement {
  PanelHeading({
    this.expandable = true,
    this.canEdit = false,
    this.help,
    super.id,
  });

  factory PanelHeading.fromJson(Map<String, dynamic> json) =>
      _$PanelHeadingFromJson(json);
  final bool expandable;
  final bool canEdit;
  final Help? help;

  @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  List<Object?> get props => [...super.props, expandable, canEdit, help];

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
  @override
  @JsonKey(
    fromJson: ContentConverter.fromJson,
    toJson: ContentConverter.toJson,
  )
  final List<Content> children;
  final String? _documentClass;

  @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  List<Object?> get props => [...super.props, layout, _documentClass, children];
  @override
  @JsonKey(
    fromJson: LayoutJsonConverter.fromJson,
    toJson: LayoutJsonConverter.toJson,
  )
  final Layout layout;

  /// A computed boolean indicating whether or not the instance is at the root of a data chain
  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  bool get isDataRoot => _documentClass != null;

  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
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
