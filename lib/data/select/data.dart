import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/content.dart';
import 'package:precept_script/data/select/multi.dart';
import 'package:precept_script/data/select/single.dart';
import 'package:precept_script/page/page.dart';
import 'package:precept_script/panel/panel.dart';

part 'data.g.dart';

/// [pageLength] is the number of documents to be returned for each data-select 'page'
/// Relevant ony to [PMulti], and just returns 1 from [PSingle]
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
/// [isSingle]
/// [isMulti]
/// [isStatic]
abstract class PData {
  String get tag;

  String? get caption;

  bool get liveConnect;

  int get pageLength;

  bool get isSingle;

  bool get isMulti;
}

/// [properties] is used to specify properties and values as required by the
/// custom page implementation.  Note that the following getters will also need
/// values assigned if the defaults are not correct for the intended use:
/// - [isMulti], [isSingle], [isStatic], [pageLength]
///
/// [routes] must contain at least one entry, but multiple routes may be specified
@JsonSerializable(explicitToJson: true)
class PPageCustom implements PData {
  final List<String> routes;
  final Map<String, dynamic> properties;
  final String tag;
  final bool liveConnect;
  final String caption;

  const PPageCustom({
    required this.routes,
    this.properties = const {},
    this.tag = 'default',
    this.liveConnect = false,
    required this.caption,
  });

  factory PPageCustom.fromJson(Map<String, dynamic> json) =>
      _$PPageCustomFromJson(json);

  Map<String, dynamic> toJson() => _$PPageCustomToJson(this);

  @override
  bool get isMulti => properties['isMulti'] ?? false;

  @override
  bool get isSingle => properties['isSingle'] ?? true;



  @override
  int get pageLength => properties['pageLength'] ?? 1;
}


/// Effectively just a marker.  This is the default value for the [PPage.dataSelectors]
/// and [PPanel.dataSelectors] properties when their respective [PContent.property] is non-null.
class PProperty implements PData {
  const PProperty();

  @override
  bool get isMulti => false;

  @override
  bool get isSingle => false;



  @override
  int get pageLength => 0;

  @override
  bool get liveConnect => false;

  @override
  String get tag => 'property';

  @override
  String get caption => 'property';


}

class PDataListJsonConverter {
  static List<PData> fromJson(List<dynamic>? json) {
    if (json == null) throw NullThrownError();
    final List<PData> results = List.empty(growable: true);
    for (Map<String, dynamic> entry in json) {
      final dataType = entry["-data-"];
      switch (dataType) {
        case 'PSingle':
          results.add(PSingle.fromJson(entry));
          break;
        case 'PSingleById':
          results.add(PSingleById.fromJson(entry));
          break;
        case 'PSingleByFunction':
          results.add(PSingleByFunction.fromJson(entry));
          break;
        case 'PSingleByFilter':
          results.add(PSingleByFilter.fromJson(entry));
          break;
        case 'PSingleByGQL':
          results.add(PSingleByGQL.fromJson(entry));
          break;
        case 'PMulti':
          results.add(PMulti.fromJson(entry));
          break;
        case 'PMultiById':
          results.add(PMultiById.fromJson(entry));
          break;
        case 'PMultiByFunction':
          results.add(PMultiByFunction.fromJson(entry));
          break;
        case 'PMultiByFilter':
          results.add(PMultiByFilter.fromJson(entry));
          break;
        case 'PMultiByGQL':
          results.add(PMultiByGQL.fromJson(entry));
          break;

        default:
          print("data type $dataType not recognised");
          throw PreceptException("data type $dataType not recognised");
      }
    }
    return results;
  }

  static List<Map<String, dynamic>> toJson(List<PData> objectList) {
    final List<Map<String, dynamic>> results = List.empty(growable: true);
    for (PData entry in objectList) {
      late Map<String, dynamic> jsonMap;
      final type=entry.runtimeType;
      switch (type) {
        case PSingle:
          jsonMap = (entry as PSingle).toJson();
          break;
        case PSingleById:
          jsonMap = (entry as PSingleById).toJson();
          break;
        case PSingleByFunction:
          jsonMap = (entry as PSingleByFunction).toJson();
          break;
        case PSingleByFilter:
          jsonMap = (entry as PSingleByFilter).toJson();
          break;
        case PSingleByGQL:
          jsonMap = (entry as PSingleByGQL).toJson();
          break;
        case PMulti:
          jsonMap = (entry as PMulti).toJson();
          break;
        case PMultiById:
          jsonMap = (entry as PMultiById).toJson();
          break;
        case PMultiByFunction:
          jsonMap = (entry as PMultiByFunction).toJson();
          break;
        case PMultiByFilter:
          jsonMap = (entry as PMultiByFilter).toJson();
          break;
        case PMultiByGQL:
          jsonMap = (entry as PMultiByGQL).toJson();
          break;

        default : String msg='${type.toString()} is not recognised';
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


