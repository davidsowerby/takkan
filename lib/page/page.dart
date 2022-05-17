import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/common/debug.dart';
import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/script/content.dart';
import 'package:takkan_script/script/element.dart';
import 'package:takkan_script/script/layout.dart';
import 'package:takkan_script/script/takkan_item.dart';
import 'package:takkan_script/util/visitor.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/data/select/data.dart';
import 'package:takkan_script/data/select/data_item.dart';
import 'package:takkan_script/data/select/data_list.dart';
import 'package:takkan_script/page/static_page.dart';
import 'package:takkan_script/panel/panel.dart';
import 'package:takkan_script/schema/field/integer.dart';
import 'package:takkan_script/schema/field/string.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/validation/message.dart';

part 'page.g.dart';

/// A [Page] defines the presentation of a Page, as perceived by a user.  It is
/// mapped to a route in the *takkan_client* TakkanRouter, and connects to dynamic data.
///
/// For static pages see [PageStatic].
///
/// A [Page] contains [children] of type [Panel] and [PPart] which define the detail
/// of the presentation, and in conjunction with the [Schema] manages connection
/// to data, validation and permissions.  It can also contain further [Page]
/// instances which are not children in the presentation sense, but are children
/// in the sense of data connection.
///
/// These are the principal use cases for pages coonecting to dynamic data [PPage]:
///
///
///
/// - The page uses dynamic data but actually uses the data from a 'parent' page.
/// [property] defines which element of the parent data to use. [children] must then
/// be appropriate to the structure of data obtained.  The user just sees this as
/// another page.
///
///
/// - The most common case is for the the page to use dynamic data, and be the
/// start point, or root, for presentation of an instance of [documentClass].
/// Its [children] usually then present elements of that data, but [Panel]
/// instances may connect to their own data. To the user, this looks like the
/// page is displaying data of multiple document classes, and potentially also
/// multiple data providers. [documentClass] references a [Document] defined
/// within [Schema] to provide validation and permissions, while [dataSelectors] defines
/// how to retrieve the data.
///
/// For dynamic data, the method of selecting data is specified in one or more
/// [dataSelectors].  Having multiple selectors allows, for example, a single
/// [Page] to be declared for 'Open Issues', 'Closed Issues', 'My Issues'
///
/// - [DataItem] specifies a single document instance
/// - [DataList] specifies 0..n instances, therefore a list
///
/// [DataItem] and [DataList] have a number of variations to enable different data
/// selection methods.
///
/// If different representations of the same [documentClass] are required then
/// multiple [Page]s must be defined and differentiated by [tag].
///
/// The [TakkanRouter] uses routes to navigate to the appropriate page.
///
/// For a static page, [PStatic.route] requires a developer defined specific
/// route.  For a dynamic page,[DataItem] and [DataList] are used to automatically
/// generate routes in the following structure:
///
/// - individual documents: document/[documentClass]/{dataSelector.tag}/{page.tag}
/// - list of documents:  documents/[documentClass]/{dataSelector.tag}/{page.tag}
///
/// If a data selector [tag] is not specified it defaults to 'default'
/// If a page tag is not specified it is just ignored, and no trailing slash is expected:
///
/// - document/[documentClass]/{dataSelector.tag
///
/// A list of all routes generated and defined will be available during script
/// validation, see https://gitlab.com/takkan/takkan_script/-/issues/28
///
/// For a list of documents, [children] will often comprise a single [PNavTile],
/// to enable tapping to select a single document
///
/// [pageType] may in future be used to look up from [PageLibrary] - not currently used
///
/// -- Note: [ContentConverter] has to be imported for code generation
@JsonSerializable(explicitToJson: true)
class Page extends PodBase implements Pages {
  final String pageType;
  final bool scrollable;
  final String? tag;

  @JsonKey(
    fromJson: DataListJsonConverter.fromJson,
    toJson: DataListJsonConverter.toJson,
  )
  final List<Data> dataSelectors;

  Page({
    this.tag,
    super.documentClass,
    super.caption,
    super.listEntryConfig,
    this.pageType = 'defaultPage',
    this.scrollable = true,
    super.layout = const LayoutDistributedColumn(),
    super.children = const [],
    super.dataProvider,
    super. controlEdit = ControlEdit.inherited,
   super. id,
    super. property,
    this.dataSelectors = const [const Property()],
  }) ;

  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);

  @override
  Script get parent => super.parent as Script;

  @override
  bool get isStatic => false;

  Content get baseConfig => this;

  @override
  bool get isDataRoot => documentClass != null;

  @override
  DebugNode get debugNode {
    final List<DebugNode> subs = children.map((e) => e.debugNode).toList();
    if (dataProviderIsDeclared) {
      DebugNode? dn = dataProvider?.debugNode;
      if (dn != null) subs.add(dn);
    }
    return DebugNode(this, subs);
  }

  @override
  Map<String, dynamic> toJson() => _$PageToJson(this);

  @override
  void doValidate(ValidationWalkerCollector collector) {
    super.doValidate(collector);
    if (pageType.isEmpty) {
      collector.messages.add(ValidationMessage(
        item: this,
        msg: 'must define a non-empty pageType',
      ));
    }
  }

  @override
  Map<String, Pages> get routeMap {
    final Map<String, Pages> map = Map();
    for (Data selector in dataSelectors) {
      final prefix = (selector.isItem) ? 'document' : 'documents';
      final route = '$prefix/$documentClass/${selector.tag}';
      if (tag == null) {
        map[route] = this;
      } else {
        map['$route/$tag'] = this;
      }
    }
    return map;
  }

  /// See [TakkanItem.subElements]
  @override
  List<dynamic> get subElements => [
        children,
        ...super.subElements,
      ];

  @override
  walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    for (Content entry in children) {
      entry.walk(visitors);
    }
  }

  @override
  String? get title => caption;

  /// [dataProvider] is always
  /// considered 'declared' by the page, if any level above it actually declares it.
  /// This is because a page is the first level to be actually built into the Widget tree
  @override
  bool get dataProviderIsDeclared =>
      (dataProvider != null && !(dataProvider is NullDataProvider));

  @override
  String? get idAlternative => title;

  @override
  Map<String, Content> get contentAsMap {
    final Map<String, Content> map = Map();
    for (Content content in children) {
      if (content.property != null) {
        map[content.property!] = content;
      }
    }
    return map;
  }
}

// TODO add pages (PObject), data-select & conversionErrorMessages
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
  final Set<String> roles = Set();

  @override
  step(Object entry) {
    if (entry is Document) {
      roles.addAll(entry.permissions.allRoles);
    }
  }
}

abstract class Pages {
  Map<String, Pages> get routeMap;

  List<Content> get children;

  Map<String, Content> get contentAsMap;

  String? get title;

  bool get isStatic;
}

class PagesJsonConverter {
  static List<Pages> fromJson(List<dynamic>? json) {
    if (json == null) throw NullThrownError();
    final List<Pages> results = List.empty(growable: true);
    for (Map<String, dynamic> entry in json) {
      final dataType = entry["-data-"];
      switch (dataType) {
        case 'Page':
          results.add(Page.fromJson(entry));
          break;
        case 'PageStatic':
          results.add(PageStatic.fromJson(entry));
          break;

        default:
          print("data type $dataType not recognised");
          throw TakkanException("data type $dataType not recognised");
      }
    }
    return results;
  }

  static List<Map<String, dynamic>> toJson(List<Pages> objectList) {
    final List<Map<String, dynamic>> results = List.empty(growable: true);
    for (Pages entry in objectList) {
      late Map<String, dynamic> jsonMap;
      switch (entry.runtimeType) {
        case Page:
          jsonMap = (entry as Page).toJson();
          break;
        case PageStatic:
          jsonMap = (entry as PageStatic).toJson();
          break;
      }

      /// Will only need the replace if we use freezed again
      /// freezed creates a delegate, hence the name change
      jsonMap["-data-"] = entry.runtimeType.toString();
      results.add(jsonMap);
    } //.replaceFirst('_\$_', '');
    return results;
  }
}
