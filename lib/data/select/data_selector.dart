import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common/constants.dart';
import '../../common/exception.dart';
import '../../common/log.dart';
import '../../page/page.dart';
import '../../panel/panel.dart';
import '../../script/content.dart';
import 'data_item.dart';
import 'data_list.dart';

part 'data_selector.g.dart';

/// [pageLength] is the number of documents to be returned for each data-select 'page'
/// Relevant ony to [DataList], and just returns 1 from [DataItem]
///
/// [caption] can be used in the display and is therefore subject to translation
/// for multi-lingual apps, but [name] is used in the construction of the route
/// associated with the data selection, and should be constant regardless of language.
///
/// Examples:
/// - [caption] 'Open Issues', 'Closed Issues'
/// - [name] 'openIssues', 'closedIssues'  (you can use spaces, but debugging can be easier if you don't)
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

abstract class DataSelector {
  String get name;

  String? get caption;

  bool get liveConnect;

  int get pageLength;

  bool get isItem;

  bool get isList;
}

abstract class DocumentListSelector extends DataSelector{

}

abstract class DocumentSelector implements DataSelector{


}

@JsonSerializable(explicitToJson: true)
class NoData implements DataSelector {

  const NoData();
  factory NoData.fromJson(Map<String, dynamic> json) => _$NoDataFromJson(json);

  @override
  String? get caption=>'static';

  @override
  String get name => 'static';

  @override
  bool get isItem => false;

  @override
  bool get isList => false;

  @override
  bool get liveConnect => false;

  @override
  int get pageLength => 0;

  Map<String, dynamic> toJson() => _$NoDataToJson(this);
}

/// [properties] is used to specify properties and values as required by the
/// custom page implementation.  Note that the following getters will also need
/// values assigned if the defaults are not correct for the intended use:
/// - [isList], [isItem], [pageLength]
///
/// [routes] must contain at least one entry, but multiple routes may be specified
@JsonSerializable(explicitToJson: true)
class PageCustom implements DataSelector {
  const PageCustom({
    required this.routes,
    this.properties = const <String, dynamic>{},
required this.name,
    this.liveConnect = false,
    required this.caption,
  });

  factory PageCustom.fromJson(Map<String, dynamic> json) =>
      _$PageCustomFromJson(json);
  final List<String> routes;
  final Map<String, dynamic> properties;
  @override
  final String name;
  @override
  final bool liveConnect;
  @override
  final String caption;

  Map<String, dynamic> toJson() => _$PageCustomToJson(this);

  @override
  bool get isList {
    const String prop = 'isMulti';
    if (properties[prop] == null) {
      return false;
    }
    return properties[prop] as bool;
  }

  @override
  bool get isItem {
    const String prop = 'isSingle';
    if (properties[prop] == null) {
      return false;
    }
    return properties[prop] as bool;
  }

  @override
  int get pageLength {
    const String prop = 'pageLength';
    if (properties[prop] == null) {
      return 1;
    }
    return properties[prop] as int;
  }
}

/// Effectively just a marker.  This is the default value for the [Page.dataSelectors]
/// and [Panel.dataSelectors] properties when their respective [Content.property] is non-null.
class Property implements DataSelector {
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
  String get name => 'property';

  @override
  String get caption => 'property';
}

// ignore: avoid_classes_with_only_static_members
class DataListJsonConverter {
  static List<DataSelector> fromJson(List<dynamic>? input) {
    if (input == null) {
      throw NullThrownError();
    }
    final List<Map<String,dynamic>> json = List.castFrom(input);
    final List<DataSelector> results = List<DataSelector>.empty(growable: true);
    for (final Map<String, dynamic> entry in json) {
      final String dataType = entry[jsonClassKey] as String;
      switch (dataType) {
        case 'DocByFunction':
          results.add(DocByFunction.fromJson(entry));
          break;
        case 'DocByQuery':
          results.add(DocByQuery.fromJson(entry));
          break;
        case 'DocByGQL':
          results.add(DocByGQL.fromJson(entry));
          break;
        case 'DocListByFunction':
          results.add(DocListByFunction.fromJson(entry));
          break;
        case 'DocListByQuery':
          results.add(DocListByQuery.fromJson(entry));
          break;
        case 'DocListByGQL':
          results.add(DocListByGQL.fromJson(entry));
          break;
        case 'NoData':
          results.add(NoData.fromJson(entry));
          break;

        default:
          final String msg='data type $dataType not recognised';
          logName('DataListJsonConverter').e(msg);
          throw TakkanException(msg);

      }
    }
    return results;
  }

  static List<Map<String, dynamic>> toJson(List<DataSelector> objectList) {
    final List<Map<String, dynamic>> results = List<Map<String, dynamic>>.empty(growable: true);
    for (final DataSelector entry in objectList) {
      late Map<String, dynamic> jsonMap;
      final Type type = entry.runtimeType;
      switch (type) {
        case DocByFunction:
          jsonMap = (entry as DocByFunction).toJson();
          break;
        case DocByQuery:
          jsonMap = (entry as DocByQuery).toJson();
          break;
        case DocByGQL:
          jsonMap = (entry as DocByGQL).toJson();
          break;
        case DocListByFunction:
          jsonMap = (entry as DocListByFunction).toJson();
          break;
        case DocListByQuery:
          jsonMap = (entry as DocListByQuery).toJson();
          break;
        case DocListByGQL:
          jsonMap = (entry as DocListByGQL).toJson();
          break;
        case NoData:
          jsonMap = (entry as NoData).toJson();
          break;

        default:
          final String msg = '${type.toString()} is not recognised';
          logName('PDataListJsonConverter').e(msg);
          throw TakkanException(msg);
      }

      /// Will only need the replace if we use freezed again
      /// freezed creates a delegate, hence the name change
      jsonMap[jsonClassKey] = type.toString();
      results.add(jsonMap);
    } //.replaceFirst('_\$_', '');
    return results;
  }
}
