import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/debug.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/common/script/element.dart';
import 'package:precept_script/common/script/layout.dart';
import 'package:precept_script/common/script/precept_item.dart';
import 'package:precept_script/common/util/visitor.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/page/page.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/validation/message.dart';

part 'static_page.g.dart';

/// A [PPageStatic] defines a static presentation of a Page, as perceived by a user.
/// It is mapped to a route in the *precept_client* PreceptRouter. See [PPage] for pages connecting
/// to data).
///
/// A [PPageStatic] is static and requires no dynamic data.   [PPanel] instances in [children] may however define their own data connections.
///
/// The [PreceptRouter] uses routes to navigate to the appropriate page.
///
/// [routes] must define at least one route to associate with a {PPageStatic] instance
///
/// A route may be any valid String, except that it may not start with 'document/'
/// or 'documents/'
///
/// A list of all routes generated and defined will be available during script
/// validation, see https://gitlab.com/precept1/precept_script/-/issues/28
///
/// [pageType] may in future be used to look up from [PageLibrary] - not currently used
///
/// -- Note: [PContentConverter] has to be imported for code generation
@JsonSerializable(explicitToJson: true)
class PPageStatic extends PPodBase implements PPages {
  final String pageType;
  final bool scrollable;

  final List<String> routes;

  final PLayout layout;

  PPageStatic({
    this.routes = const [],
    String? caption,
    this.pageType = 'defaultPage',
    this.scrollable = true,
    this.layout = const PLayoutDistributedColumn(),
    List<PContent> children = const [],
    PDataProvider? dataProvider,
    ControlEdit controlEdit = ControlEdit.inherited,
    String? id,
  }) : super(
          id: id,
          dataProvider: dataProvider,
          controlEdit: controlEdit,
          caption: caption,
          children: children,
          layout: layout,
        );

  factory PPageStatic.fromJson(Map<String, dynamic> json) =>
      _$PPageStaticFromJson(json);

  PScript get parent => super.parent as PScript;

  PContent get baseConfig => this;

  bool get isDataRoot => documentClass != null;

  DebugNode get debugNode {
    final List<DebugNode> subs = children.map((e) => e.debugNode).toList();
    if (dataProviderIsDeclared) {
      DebugNode? dn = dataProvider?.debugNode;
      if (dn != null) subs.add(dn);
    }
    return DebugNode(this, subs);
  }

  Map<String, dynamic> toJson() => _$PPageStaticToJson(this);

  void doValidate(ValidationWalkerCollector collector) {
    super.doValidate(collector);
    if (pageType.isEmpty) {
      collector.messages.add(ValidationMessage(
        item: this,
        msg: 'must define a non-empty pageType',
      ));
    }
  }

  /// See [PreceptItem.subElements]
  List<dynamic> get subElements => [
        children,
        ...super.subElements,
      ];

  walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    for (PContent entry in children) {
      entry.walk(visitors);
    }
  }

  String? get title => caption;

  /// [dataProvider] is always
  /// considered 'declared' by the page, if any level above it actually declares it.
  /// This is because a page is the first level to be actually built into the Widget tree
  bool get dataProviderIsDeclared =>
      (dataProvider != null && !(dataProvider is PNoDataProvider));

  String? get idAlternative => title;

  Map<String, PContent> get contentAsMap {
    final Map<String, PContent> map = Map();
    for (PContent content in children) {
      if (content.property != null) {
        map[content.property!] = content;
      }
    }
    return map;
  }

  bool get isStatic => true;

  @override
  Map<String, PPages> get routeMap {
   final Map<String, PPages> map=Map();
   for(String route in routes){
     map[route]=this;
   }
   return map;
  }
}
