import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/script/content.dart';
import 'package:takkan_script/data/select/data_item.dart';
import 'package:takkan_script/data/select/data_list.dart';
import 'package:takkan_script/page/page.dart';
import 'package:takkan_script/panel/panel.dart';

part 'data.g.dart';

/// [pageLength] is the number of documents to be returned for each data-select 'page'
/// Relevant ony to [DataList], and just returns 1 from [DataItem]
///
/// [caption] can be used in the display and is therefore subject to translation
/// for multi-lingual apps, but [tag] is used in the construction of the route
/// associated with the data selection, and should be constant regardless of language.
///
/// Examples:
/// - [caption] 'Open Issues', 'Closed Issues'
/// - [tag] 'openIssues', 'closedIssues'  (you can use spaces, but debugging can be easier if you don't)
///
/// The implementations of this interface used to use [freezed](https://pub.dev/packages/freezed), and may revert
/// to doing so.  This creates proxy classes during code generation, so it is easier
/// to specify certain attributes explicitly, rather than rely on class comparison
/// using the 'is' operator.
///
/// These are:
///
/// [isItem]
/// [isList]
/// [isStatic]
abstract class Data {
  String get tag;

  String? get caption;

  bool get liveConnect;

  int get pageLength;

  bool get isItem;

  bool get isList;
}

/// [properties] is used to specify properties and values as required by the
/// custom page implementation.  Note that the following getters will also need
/// values assigned if the defaults are not correct for the intended use:
/// - [isList], [isItem], [isStatic], [pageLength]
///
/// [routes] must contain at least one entry, but multiple routes may be specified
@JsonSerializable(explicitToJson: true)
class PageCustom implements Data {
  final List<String> routes;
  final Map<String, dynamic> properties;
  @override
  final String tag;
  @override
  final bool liveConnect;
  @override
  final String caption;

  const PageCustom({
    required this.routes,
    this.properties = const {},
    this.tag = 'default',
    this.liveConnect = false,
    required this.caption,
  });

  factory PageCustom.fromJson(Map<String, dynamic> json) =>
      _$PageCustomFromJson(json);

  Map<String, dynamic> toJson() => _$PageCustomToJson(this);

  @override
  bool get isList => properties['isMulti'] ?? false;

  @override
  bool get isItem => properties['isSingle'] ?? true;

  @override
  int get pageLength => properties['pageLength'] ?? 1;
}


/// Effectively just a marker.  This is the default value for the [Page.dataSelectors]
/// and [Panel.dataSelectors] properties when their respective [Content.property] is non-null.
class Property implements Data {
  const Property();

  @override
  bool get isList => false;

  @override
  bool get isItem => false;

  @override
  int get pageLength => 0;

  @override
  bool get liveConnect => false;

  @override
  String get tag => 'property';

  @override
  String get caption => 'property';


}

class DataListJsonConverter {
  static List<Data> fromJson(List<dynamic>? json) {
    if (json == null) throw NullThrownError();
    final List<Data> results = List.empty(growable: true);
    for (Map<String, dynamic> entry in json) {
      final dataType = entry["-data-"];
      switch (dataType) {
        case 'DataItem':
          results.add(DataItem.fromJson(entry));
          break;
        case 'DataItemById':
          results.add(DataItemById.fromJson(entry));
          break;
        case 'DataItemByFunction':
          results.add(DataItemByFunction.fromJson(entry));
          break;
        case 'DataItemByFilter':
          results.add(DataItemByFilter.fromJson(entry));
          break;
        case 'DataItemByGQL':
          results.add(DataItemByGQL.fromJson(entry));
          break;
        case 'DataList':
          results.add(DataList.fromJson(entry));
          break;
        case 'DataListById':
          results.add(DataListById.fromJson(entry));
          break;
        case 'DataListByFunction':
          results.add(DataListByFunction.fromJson(entry));
          break;
        case 'DataListByFilter':
          results.add(DataListByFilter.fromJson(entry));
          break;
        case 'DataListByGQL':
          results.add(DataListByGQL.fromJson(entry));
          break;

        default:
          print("data type $dataType not recognised");
          throw PreceptException("data type $dataType not recognised");
      }
    }
    return results;
  }

  static List<Map<String, dynamic>> toJson(List<Data> objectList) {
    final List<Map<String, dynamic>> results = List.empty(growable: true);
    for (Data entry in objectList) {
      late Map<String, dynamic> jsonMap;
      final type = entry.runtimeType;
      switch (type) {
        case DataItem:
          jsonMap = (entry as DataItem).toJson();
          break;
        case DataItemById:
          jsonMap = (entry as DataItemById).toJson();
          break;
        case DataItemByFunction:
          jsonMap = (entry as DataItemByFunction).toJson();
          break;
        case DataItemByFilter:
          jsonMap = (entry as DataItemByFilter).toJson();
          break;
        case DataItemByGQL:
          jsonMap = (entry as DataItemByGQL).toJson();
          break;
        case DataList:
          jsonMap = (entry as DataList).toJson();
          break;
        case DataListById:
          jsonMap = (entry as DataListById).toJson();
          break;
        case DataListByFunction:
          jsonMap = (entry as DataListByFunction).toJson();
          break;
        case DataListByFilter:
          jsonMap = (entry as DataListByFilter).toJson();
          break;
        case DataListByGQL:
          jsonMap = (entry as DataListByGQL).toJson();
          break;

        default:
          String msg = '${type.toString()} is not recognised';
          logName('PDataListJsonConverter').e(msg);
          throw PreceptException(msg);
      }

      /// Will only need the replace if we use freezed again
      /// freezed creates a delegate, hence the name change
      jsonMap["-data-"] = type.toString();
      results.add(jsonMap);
    } //.replaceFirst('_\$_', '');
    return results;
  }
}


