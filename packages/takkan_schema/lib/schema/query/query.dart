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
import '../../util/walker.dart';
import '../common/diff.dart';
import '../common/schema_element.dart';
import '../document/document.dart';
import '../schema.dart';
import 'expression.dart';

part 'query.g.dart';

/// A [Query] can be defined using either a [queryScript] or set of [constraints], or even
/// both as they are combined in [doInit]. You get get the resultant combination
/// from [conditions].
///
/// The Back4App control fields (objectId,updatedAt,createdAt) should not need to
/// be declared,but this is an open issue:
///
/// TODO:  https://gitlab.com/takkan/takkan_schema/-/issues/3
///
/// If [returnSingle] is true, the query must return exactly one document.
/// if false, the query returns a 0..n List of Documents
///
/// If [useStream] is true results are returned as a Stream, otherwise as a simple
/// Future. [NOT YET IMPLEMENTED - ALWAYS A FUTURE CURRENTLY] TODO:https://gitlab.com/takkan/takkan_design/-/issues/46
///
///
/// [params] are not yet implemented - TODO: https://gitlab.com/takkan/takkan_design/-/issues/47
@JsonSerializable(explicitToJson: true)
class Query extends SchemaElement {
  Query({
    this.constraints = const [],
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
  /// use [conditions]
  @JsonKey(fromJson: conditionListFromJson, toJson: conditionListToJson)
  List<Condition<dynamic>> constraints;

  @JsonKey(includeToJson: false, includeFromJson: false)
  final List<Condition<dynamic>> _conditions = [];

  /// Combines [constraints] with [queryScript].  Use this to ensure you have all
  /// conditions
  @JsonKey(includeToJson: false, includeFromJson: false)
  List<Condition<dynamic>> get conditions => _conditions;

  @override
  Map<String, dynamic> toJson() => _$QueryToJson(this);

  @override
  void doInit(InitWalkerParams params) {
    super.doInit(params);
    _buildConditions();
  }

  void _buildConditions() {
    _conditions.clear();
    for (final condition in constraints) {
      _conditions.add(condition);
    }
    final script = queryScript;
    if (script != null) {
      final scriptConditions = ConditionBuilder(document: parent as Document)
          .parseForQuery(expression: script);
      _conditions.addAll(scriptConditions);
    }
  }

  @override
  List<Object?> get props => [
        ...super.props,
        _conditions,
        params,
        queryScript,
        returnSingle,
        useStream,
      ];
}

@JsonSerializable(explicitToJson: true)
class QueryDiff implements Diff<Query> {
  const QueryDiff({
    this.constraints,
    this.params,
    this.queryScript,
    this.returnSingle,
    this.useStream,
    this.removeQueryScript = false,
  });

  factory QueryDiff.fromJson(Map<String, dynamic> json) =>
      _$QueryDiffFromJson(json);

  final String? queryScript;
  final List<String>? params;
  final bool? returnSingle;
  final bool? useStream;
  final bool removeQueryScript;

  @JsonKey(
      fromJson: nullableConditionListFromJson,
      toJson: nullableConditionListToJson)
  final List<Condition<dynamic>>? constraints;

  Map<String, dynamic> toJson() => _$QueryDiffToJson(this);

  @override
  Query applyTo(Query base) {
    return Query(
      queryScript: removeQueryScript ? null : queryScript ?? base.queryScript,
      params: params ?? base.params,
      returnSingle: returnSingle ?? base.returnSingle,
      useStream: useStream ?? base.useStream,
      constraints: constraints ?? base.constraints,
    );
  }
}
