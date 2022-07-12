import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../data/select/condition/condition.dart';
import '../schema.dart';
import 'expression.dart';

part 'query_combiner.g.dart';

class QueryCombiner extends Equatable {
  const QueryCombiner({required this.conditions});

  /// Combines the query conditions from both the [queryScript] and [query]
  factory QueryCombiner.fromSource(
    Document document,
    String? queryScript,
    Query? query,
  ) {
    final conditions = List<Condition<dynamic>>.empty(growable: true);
    if (queryScript != null) {
      conditions.addAll(Expression(document:document).parseQuery(queryScript));
    }
    if (query != null) {
      conditions.addAll(query.conditions);
    }
    conditions.sort((a, b) => a.field.compareTo(b.field));
    return QueryCombiner(conditions: conditions);
  }

  // factory Expression.fromC(List<C> cond){
  //   final result=List<Condition>.empty(growable: true);
  //   for (final C<dynamic> condition in cond){
  //     result.add(condition.toCondition);
  //   }
  //   return Expression(conditions: result);
  // }

  final List<Condition<dynamic>> conditions;
  @JsonKey(ignore: true)
  @override
  List<Object?> get props => [conditions];
}

@JsonSerializable(explicitToJson: true)
@ConditionConverter()
class Query {
  Query(List<Condition<dynamic>> conditions)
      : conditions = List.from(conditions) {
    this.conditions.sort((a, b) => a.field.compareTo(b.field));
  }

  factory Query.fromJson(Map<String, dynamic> json) => _$QueryFromJson(json);

  final List<Condition<dynamic>> conditions;

  Map<String, dynamic> toJson() => _$QueryToJson(this);
}

enum QueryReturnType{futureItem, futureList,unexpected,}
