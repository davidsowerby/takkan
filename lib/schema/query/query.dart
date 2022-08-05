// ignore_for_file: must_be_immutable

import 'package:json_annotation/json_annotation.dart';

import '../../data/select/condition/condition.dart';
import '../schema.dart';
import 'expression.dart';

part 'query.g.dart';

/// A [Query] can be defined using either a [script] or set of [conditions], or even
/// both. They are combined by the getter [combinedConditions].
///
/// The Back4App control fields (objectId,updatedAt,createdAt) do not need to
/// be declared, as they are added during the [doInit] call.
/// https://gitlab.com/takkan/takkan_script/-/issues/49
///
/// If [returnSingle] is true, the query must return exactly one document.
/// if false, the query returns a 0..n List of Documents
///
/// If [useStream] is true results are returned as a Stream, otherwise as a simple
/// Future. [NOT YET IMPLEMENTED - ALWAYS A FUTURE]
///
/// [conditions] is created with a List.from to allow further conditions
/// to be added from [queryScript]
///
/// [params] are not yet implemented
@JsonSerializable(explicitToJson: true)
@ConditionConverter()
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
    combined
        .addAll(QueryExpression(document: document).parseQuery(expression: qs));
    combined.sort((a, b) => a.field.compareTo(b.field));
    return combined;
  }

  @override
  Map<String, dynamic> toJson() => _$QueryToJson(this);

  @override
  List<Object?> get props =>
      [
        ...super.props,
        params,
        queryScript,
        returnSingle,
        useStream,
        conditions
      ];
}
