import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../common/debug.dart';
import '../data/provider/data_provider.dart';
import '../data/select/data_selector.dart';
import '../data/select/data_item.dart';
import '../data/select/data_list.dart';
import '../panel/panel.dart';
import '../part/part.dart';
import '../schema/field/integer.dart';
import '../schema/field/string.dart';
import '../schema/schema.dart';
import '../script/common.dart';
import '../script/content.dart';
import '../script/element.dart';
import '../script/layout.dart';
import '../script/script.dart';
import '../script/takkan_item.dart';
import '../util/visitor.dart';

part 'page.g.dart';

/// A [Page] defines the presentation of a Page, as perceived by a user.
///
/// A [Page] contains [children] of type [Panel] and [Part] which define the detail
/// of the presentation, and in conjunction with the [Schema] manages connection
/// to data, validation and permissions.
///
/// [name] must be unique within the [script], and must not contain a '/'
///
/// Recognising that the same page layout may be desirable for multiple data
/// sets, especially query results, a [Page] may define multiple [dataSelectors].
///
/// For example, one page could be defined for 'open issues','closed issues' and
/// 'my issues', with [dataSelectors] determining the data selection.  This
/// would result in the generation of 3 routes, one for each data selector.
///
/// The name of a [dataSelectors] entry must be unique within the page.
///
/// - [DataItem] specifies a single document instance
/// - [DataList] specifies 0..n instances, therefore a list
///
/// [DataItem] and [DataList] have a number of variations to enable different data
/// selection methods.
///
/// For static pages - for example a splash page - leave [dataSelectors] empty
///
/// The [TakkanRouter] uses routes to navigate to a page + data selector combination.
/// The route is extremely simple:
///
/// - for dynamic pages: {page.name}/{dataSelector.name}/{objectId}
/// - for static pages: {page.name}/static
///
/// - static/{dataSelector.tag}/{page.tag}
///
/// Routes are generated automatically and accessible from [script.routeMap]
///
/// A list of all routes generated and defined will be available during script
/// validation, see https://gitlab.com/takkan/takkan_script/-/issues/28
///
///
/// -- Note: [ContentConverter] has to be imported for code generation
@JsonSerializable(explicitToJson: true)
class Page extends PodBase {
  Page({
    required this.name,
    super.documentClass,
    super.caption,
    super.listEntryConfig,
    this.scrollable = true,
    super.layout = const LayoutDistributedColumn(),
    super.children = const [],
    super.dataProvider,
    super.controlEdit = ControlEdit.inherited,
    super.id,
    super.property,
    List<DataSelector>? dataSelectors,
  }) : dataSelectors = dataSelectors ?? List.empty(growable: true);

  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
  final bool scrollable;
  final String name;

  @JsonKey(
    fromJson: DataListJsonConverter.fromJson,
    toJson: DataListJsonConverter.toJson,
  )
  final List<DataSelector> dataSelectors;

  DataSelector dataSelectorByName(String name){
    for (final DataSelector selector in dataSelectors){
      if (selector.name==name){
        return selector;
      }
    }
    return const NoData();
  }
  bool get dataIsItem {
    if (isStatic) {
      return false;
    }
    return dataSelectors[0].isItem;
  }

  bool get dataIsList {
    if (isStatic) {
      return false;
    }
    return dataSelectors[0].isList;
  }

  @override
  void doInit(InitWalkerParams params) {
    super.doInit(params);
    if (property != null) {
      dataSelectors.clear();
      dataSelectors.add(const Property());
    }
  }

  @override
  Script get parent => super.parent as Script;

  @override
  bool get isStatic {
    if (dataSelectors.isEmpty) {
      return true;
    }

    return dataSelectors[0] is NoData;
  }

  Content get baseConfig => this;

  @override
  bool get isDataRoot => documentClass != null;

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

  @override
  Map<String, dynamic> toJson() => _$PageToJson(this);

  /// Generates structured routes.  See [TakkanRoute] for structure
  Map<TakkanRoute, Page> get routeMap {
    final Map<TakkanRoute, Page> map = {};
    if(dataSelectors.isEmpty){
      final TakkanRoute takkanRoute=TakkanRoute.fromConfig(page: this, selector:const NoData());
      map[takkanRoute] = this;
      return map;
    }
    for (final DataSelector selector in dataSelectors) {
      final TakkanRoute takkanRoute = TakkanRoute.fromConfig(
        page: this,
        selector: selector,
      );
      map[takkanRoute] = this;
    }
    return map;
  }

  /// See [TakkanItem.subElements]
  @override
  List<Object> get subElements => [
        children,
        ...super.subElements,
      ];

  @override
  void walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    for (final Content entry in children) {
      entry.walk(visitors);
    }
  }

  String? get title => caption;

  /// [dataProvider] is always
  /// considered 'declared' by the page, if any level above it actually declares it.
  /// This is because a page is the first level to be actually built into the Widget tree
  @override
  bool get dataProviderIsDeclared =>
      dataProvider != null && (dataProvider is! NullDataProvider);

  @override
  String? get idAlternative => title;

  Map<String, Content> get contentAsMap {
    final Map<String, Content> map = {};
    for (final Content content in children) {
      if (content.property != null) {
        map[content.property!] = content;
      }
    }
    return map;
  }
}

// TODO(David): add pages (PObject) data-select & conversionErrorMessages,
final Document pScriptSchema0 = Document(
  documentType: DocumentType.versioned,
  fields: {
    'nameLocale': FString(),
    'name': FString(),
    'version': FInteger(),
    'locale': FString(),
    'controlEdit': FString(),
  },
);

enum PageType { standard }

/// property || documentSelector must be non-null
/// parts || sections must be non empty

//

class RoleVisitor implements ScriptVisitor {
  final Set<String> roles = {};

  @override
  void step(Object entry) {
    if (entry is Document) {
      roles.addAll(entry.permissions.allRoles);
    }
  }
}

/// A structured representation of a route.
///
/// The structure is simple enough to just use Strings, but using this class
/// should be a bit more future proof if something does need to change later.
/// A route may have an objectId or list of objectIds appended.  [TakkanRoute]
/// only uses the [pageName] and [dataSelectorName].
///
/// - individual documents: {page.name}/{dataSelector.name}/{objectId*}
/// - list of documents:  {page.name}/{dataSelector.name}/{[objectId, objectId]*}
/// - static pages: {page.name}/{dataSelector.name}/static
///
@immutable
class TakkanRoute extends Equatable{
  const TakkanRoute({
    required this.dataSelectorName,
    required this.pageName,
  });


  /// Constructs an instance from [Page] and [DataSelector]
  factory TakkanRoute.fromConfig({
    required Page page,
    required DataSelector selector,
  }) {
    return TakkanRoute(
      dataSelectorName:selector.name,
      pageName: page.name,
    );
  }

  factory TakkanRoute.fromString(String route) {
    final segments = route.split('/');
    return TakkanRoute(
        pageName: segments[0],
        dataSelectorName: segments[1]);
  }

  final String dataSelectorName;
  final String pageName;

  @override
  String toString() {
    return '$pageName/$dataSelectorName';
  }

  @override
  List<Object?> get props => [pageName,dataSelectorName];



}
