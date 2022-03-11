import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/debug.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/common/script/element.dart';
import 'package:precept_script/common/script/layout.dart';
import 'package:precept_script/common/script/precept_item.dart';
import 'package:precept_script/common/util/visitor.dart';
import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/data/select/data.dart';
import 'package:precept_script/data/select/multi.dart';
import 'package:precept_script/data/select/single.dart';
import 'package:precept_script/page/static_page.dart';
import 'package:precept_script/panel/panel.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/validation/message.dart';

part 'page.g.dart';

/// A [PPage] defines the presentation of a Page, as perceived by a user.  It is
/// mapped to a route in the *precept_client* PreceptRouter, and connects to dynamic data.
///
/// For static pages see [PPageStatic].
///
/// A [PPage] contains [children] of type [PPanel] and [PPart] which define the detail
/// of the presentation, and in conjunction with the [PSchema] manages connection
/// to data, validation and permissions.  It can also contain further [PPage]
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
/// Its [children] usually then present elements of that data, but [PPanel]
/// instances may connect to their own data. To the user, this looks like the
/// page is displaying data of multiple document classes, and potentially also
/// multiple data providers. [documentClass] references a [PDocument] defined
/// within [PSchema] to provide validation and permissions, while [dataSelectors] defines
/// how to retrieve the data.
///
/// For dynamic data, the method of selecting data is specified in one or more
/// [dataSelectors].  Having multiple selectors allows, for example, a single
/// [PPage] to be declared for 'Open Issues', 'Closed Issues', 'My Issues'
///
/// - [PSingle] specifies a single document instance
/// - [PMulti] specifies 0..n instances, therefore a list
///
/// [PSingle] and [PMulti] have a number of variations to enable different data
/// selection methods.
///
/// If different representations of the same [documentClass] are required then
/// multiple [PPage]s must be defined and differentiated by [tag].
///
/// The [PreceptRouter] uses routes to navigate to the appropriate page.
///
/// For a static page, [PStatic.route] requires a developer defined specific
/// route.  For a dynamic page,[PSingle] and [PMulti] are used to automatically
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
/// validation, see https://gitlab.com/precept1/precept_script/-/issues/28
///
/// For a list of documents, [children] will often comprise a single [PNavTile],
/// to enable tapping to select a single document
///
/// [pageType] may in future be used to look up from [PageLibrary] - not currently used
///
/// -- Note: [PContentConverter] has to be imported for code generation
@JsonSerializable(explicitToJson: true)
class PPage extends PPodBase implements PPages {
  final String pageType;
  final bool scrollable;
  final String? tag;

  @JsonKey(
    fromJson: PDataListJsonConverter.fromJson,
    toJson: PDataListJsonConverter.toJson,
  )
  final List<PData> dataSelectors;
  @JsonKey(
    toJson: PLayoutJsonConverter.toJson,
    fromJson: PLayoutJsonConverter.fromJson,
  )
  final PLayout layout;

  PPage({
    this.tag,
    String? documentClass,
    String? caption,
    PPanel? listEntryConfig,
    this.pageType = 'defaultPage',
    this.scrollable = true,
    this.layout = const PLayoutDistributedColumn(),
    List<PContent> children = const [],
    PDataProvider? dataProvider,
    ControlEdit controlEdit = ControlEdit.inherited,
    String? id,
    String? property,
    this.dataSelectors = const [const PProperty()],
  }) : super(
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

  factory PPage.fromJson(Map<String, dynamic> json) => _$PPageFromJson(json);

  PScript get parent => super.parent as PScript;

  bool get isStatic => false;

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

  Map<String, dynamic> toJson() => _$PPageToJson(this);

  void doValidate(ValidationWalkerCollector collector) {
    super.doValidate(collector);
    if (pageType.isEmpty) {
      collector.messages.add(ValidationMessage(
        item: this,
        msg: 'must define a non-empty pageType',
      ));
    }
  }

  Map<String, PPages> get routeMap {
    final Map<String, PPages> map = Map();
    for (PData selector in dataSelectors) {
      final prefix = (selector.isSingle) ? 'document' : 'documents';
      final route = '$prefix/$documentClass/${selector.tag}';
      if (tag == null) {
        map[route] = this;
      } else {
        map['$route/$tag'] = this;
      }
    }
    return map;
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
}

// TODO add pages (PObject), data-select & conversionErrorMessages
final PDocument pScriptSchema0 = PDocument(
  documentType: PDocumentType.versioned,
  fields: {
    'nameLocale': PString(),
    'name': PString(),
    'version': PInteger(),
    'locale': PString(),
    'controlEdit': PString(),
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
    if (entry is PDocument) {
      roles.addAll(entry.permissions.allRoles);
    }
  }
}

abstract class PPages {
  Map<String, PPages> get routeMap;

  List<PContent> get children;

  Map<String, PContent> get contentAsMap;

  String? get title;

  bool get isStatic;
}

class PPagesJsonConverter {
  static List<PPages> fromJson(List<dynamic>? json) {
    if (json == null) throw NullThrownError();
    final List<PPages> results = List.empty(growable: true);
    for (Map<String, dynamic> entry in json) {
      final dataType = entry["-data-"];
      switch (dataType) {
        case 'PPage':
          results.add(PPage.fromJson(entry));
          break;
        case 'PPageStatic':
          results.add(PPageStatic.fromJson(entry));
          break;

        default:
          print("data type $dataType not recognised");
          throw PreceptException("data type $dataType not recognised");
      }
    }
    return results;
  }

  static List<Map<String, dynamic>> toJson(List<PPages> objectList) {
    final List<Map<String, dynamic>> results = List.empty(growable: true);
    for (PPages entry in objectList) {
      late Map<String, dynamic> jsonMap;
      switch (entry.runtimeType) {
        case PPage:
          jsonMap = (entry as PPage).toJson();
          break;
        case PPageStatic:
          jsonMap = (entry as PPageStatic).toJson();
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
