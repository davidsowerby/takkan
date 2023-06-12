// ignore_for_file: must_be_immutable

import 'package:json_annotation/json_annotation.dart';

import '../../common/constants.dart';
import '../../common/exception.dart';
import '../../common/log.dart';
import '../../data/select/condition/bool_condition.dart';
import '../../data/select/condition/condition.dart';
import '../../data/select/condition/date_time_condition.dart';
import '../../data/select/condition/double_condition.dart';
import '../../data/select/condition/geo_point_condition.dart';
import '../../data/select/condition/geo_polygon_condition.dart';
import '../../data/select/condition/geo_position_condition.dart';
import '../../data/select/condition/integer_condition.dart';
import '../../data/select/condition/json_object_condition.dart';
import '../../data/select/condition/list_int_condition.dart';
import '../../data/select/condition/pointer_condition.dart';
import '../../data/select/condition/post_code_condition.dart';
import '../../data/select/condition/string_condition.dart';
import '../schema.dart';
import 'expression.dart';

part 'query.g.dart';

/// A [Query] can be defined using either a [queryScript] or set of [conditions], or even
/// both. They are combined by the getter [combinedConditions].
///
/// The Back4App control fields (objectId,updatedAt,createdAt) do not need to
/// be declared, as they are added during the [doInit] call.
///
/// TODO:  https://gitlab.com/takkan/takkan_script/-/issues/49
///
/// If [returnSingle] is true, the query must return exactly one document.
/// if false, the query returns a 0..n List of Documents
///
/// If [useStream] is true results are returned as a Stream, otherwise as a simple
/// Future. [NOT YET IMPLEMENTED - ALWAYS A FUTURE CURRENTLY] TODO:https://gitlab.com/takkan/takkan_design/-/issues/46
///
/// [conditions] is created with a List.from to allow further conditions
/// to be added from [queryScript]
///
/// [params] are not yet implemented - TODO: https://gitlab.com/takkan/takkan_design/-/issues/47
@JsonSerializable(explicitToJson: true)
class Query extends SchemaElement {
  Query({
    this.conditions = const [],
    this.params = const [],
    this.queryScript,
    this.returnSingle = false,
    this.useStream = false,
  });

  factory Query.fromJson(Map<String, dynamic> json) => _$QueryFromJson(json);

  final String? queryScript;
  final List<String> params;
  final bool returnSingle;
  final bool useStream;

  /// To retrieve conditions specified by [queryScript] as well,
  /// use [combinedConditions]
  @JsonKey(fromJson: conditionListFromJson,toJson: conditionListToJson)
  final List<Condition<dynamic>> conditions;

  /// Combines [conditions] with [script].  Use this to ensure you have all
  /// conditions
  @JsonKey(ignore: true)
  List<Condition<dynamic>> get combinedConditions {
    final Document document = parent as Document;
    final qs = queryScript;
    if (qs == null) {
      return conditions;
    }
    final combined = List<Condition<dynamic>>.from(conditions);
    combined.addAll(
        ConditionBuilder(document: document).parseForQuery(expression: qs));
    combined.sort((a, b) => a.field.compareTo(b.field));
    return combined;
  }

  @override
  Map<String, dynamic> toJson() => _$QueryToJson(this);

  @override
  List<Object?> get props => [
        ...super.props,
        params,
        queryScript,
        returnSingle,
        useStream,
        conditions
      ];
}

List<Condition<dynamic>> conditionListFromJson(List<dynamic>? input) {
  if (input == null) {
    throw const TakkanException('Null thrown');
  }
  final List<Map<String, dynamic>> json = List.castFrom(input);
  final List<Condition<dynamic>> results = List<Condition<dynamic>>.empty(growable: true);
  for (final Map<String, dynamic> entry in json) {
    final String dataType = entry[jsonClassKey] as String;
    switch (dataType) {
      case 'IntegerCondition':
        results.add(IntegerCondition.fromJson(entry));
        break;
      case 'StringCondition':
        results.add(StringCondition.fromJson(entry));
        break;
      case 'PointerCondition':
        results.add(PointerCondition.fromJson(entry));
        break;
      case 'GeoPositionCondition':
        results.add(GeoPositionCondition.fromJson(entry));
        break;
      case 'GeoPointCondition':
        results.add(GeoPointCondition.fromJson(entry));
        break;
      case 'DateTimeCondition':
        results.add(DateTimeCondition.fromJson(entry));
        break;
      case 'BoolCondition':
        results.add(BoolCondition.fromJson(entry));
        break;
      case 'PostCodeCondition':
        results.add(PostCodeCondition.fromJson(entry));
        break;
      case 'DoubleCondition':
        results.add(DoubleCondition.fromJson(entry));
        break;
      case 'GeoPolygonCondition':
        results.add(GeoPolygonCondition.fromJson(entry));
        break;
      case 'JsonObjectCondition':
        results.add(JsonObjectCondition.fromJson(entry));
        break;
      case 'ListIntCondition':
        results.add(ListIntCondition.fromJson(entry));
        break;
      default:
        final String msg = 'data type $dataType not recognised';
        logName('DataListJsonConverter').e(msg);
        throw TakkanException(msg);
    }
  }
  return results;
}

List<Map<String, dynamic>> conditionListToJson(List<Condition<dynamic>> objectList) {
  final List<Map<String, dynamic>> results =
      List<Map<String, dynamic>>.empty(growable: true);
  for (final Condition<dynamic> entry in objectList) {
    final Map<String, dynamic> jsonMap=entry.toJson();

    /// Will only need the replace if we use freezed again
    /// freezed creates a delegate, hence the name change
    jsonMap[jsonClassKey] = entry.runtimeType.toString();
    results.add(jsonMap);
  } //.replaceFirst('_\$_', '');
  return results;
}
