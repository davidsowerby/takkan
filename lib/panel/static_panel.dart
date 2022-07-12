// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';

import '../common/debug.dart';
import '../script/content.dart';
import '../script/element.dart';
import '../script/help.dart';
import '../script/layout.dart';
import '../script/script_element.dart';
import '../script/takkan_element.dart';
import '../script/walker.dart';
import 'panel.dart';

part 'static_panel.g.dart';

/// [children], [documentClass], [cloudFunction] see [PodBase]
@JsonSerializable(explicitToJson: true)
class PanelStatic extends PodBase implements Panels {
  PanelStatic({
    super.caption,
    super.documentClass,
    this.openExpanded = true,
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

  factory PanelStatic.fromJson(Map<String, dynamic> json) =>
      _$PanelStaticFromJson(json);
  @JsonKey(
    fromJson: ContentConverter.fromJson,
    toJson: ContentConverter.toJson,
  )
  @JsonKey(ignore: true)
  PanelHeading? _heading;
  final bool openExpanded;
  final bool scrollable;
  final Help? help;
  final Map<String, dynamic> pageArguments;

  @override
  Map<String, dynamic> toJson() => _$PanelStaticToJson(this);

  @JsonKey(ignore: true)
  @override
  List<Object?> get props =>
      [_heading, openExpanded, scrollable, help, pageArguments];

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
  bool get isDataRoot => false;

  @override
  bool get isStatic => true;
}
