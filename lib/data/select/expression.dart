import 'package:characters/characters.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:validators/validators.dart';

import '../../common/exception.dart';
import '../../common/log.dart';
import '../../schema/field/field.dart';
import '../../schema/field/integer.dart';
import '../../schema/schema.dart';

part 'expression.g.dart';

class Expression extends Equatable {
  const Expression({required this.conditions});

  /// Combines the query conditions from both the [queryScript] and [query]
  factory Expression.fromSource(
    String? expression,
    Query ? query,
  ) {
    final conditions = List<Condition>.empty(growable: true);
    if (expression != null) {
      conditions.addAll(parse(expression));
    }
    if (query != null) {
      conditions.addAll(query.conditions);
    }
    conditions.sort((a, b) => a.field.compareTo(b.field));
    return Expression(conditions: conditions);
  }

  // factory Expression.fromC(List<C> cond){
  //   final result=List<Condition>.empty(growable: true);
  //   for (final C<dynamic> c in cond){
  //     result.add(c.toCondition);
  //   }
  //   return Expression(conditions: result);
  // }

  final List<Condition> conditions;

  @override
  List<Object?> get props => [conditions];
}

List<Condition<dynamic>> parse(String expression) {
  final List<Condition<dynamic>> conditions =
      List<Condition<dynamic>>.empty(growable: true);
  final c = expression.split(separator);
  for (final String cond in c) {
    conditions.add(_parseCondition(cond));
  }
  return conditions;
}

Condition<dynamic> _parseCondition(String cond) {
  final Characters chars = Characters(cond);
  bool foundOp = false;
  bool conditionCreated = false;
  for (final Operator op in Operator.values) {
    final opChar = Characters(op.expression);
    if (chars.containsAll(opChar)) {
      foundOp = true;
      final segments = chars.split(opChar);
      final trimmed = segments.map((e) => e.toString().trim()).toList();
      // segments.where((e) => e.toString().trim().isNotEmpty).toList();
      if (trimmed.length != 2) {
        final String msg = '$cond is not a valid condition';
        logName('Condition').e(msg);
        throw TakkanException(msg);
      }
      final c = Condition(
        field: trimmed[0],
        operator: op,
        value: _decodeValueType(trimmed[1]),
      );
      conditionCreated = true;
      return c;
    }
  }
  if (!foundOp) {
    final String msg = 'Unable to identify operator in condition $cond ';
    logName('Condition').e(msg);
    throw TakkanException(msg);
  }
  if (!conditionCreated) {
    final String msg = 'Unable to process condition $cond';
    logName('Condition').e(msg);
    throw TakkanException(msg);
  }
  final String msg = 'Failed to parse condition $cond';
  logName('Condition').e(msg);
  throw TakkanException(msg);
}

const separator = '&&';

dynamic _decodeValueType(String source) {
  final src = Characters(source);
  final range = src.getRange(0);
  final CharacterRange? singleQuoted = range.findFirst("'".characters);
  if (singleQuoted != null) {
    singleQuoted.moveUntil("'".characters);
    return singleQuoted.currentCharacters.toString();
  }
  final CharacterRange? doubleQuoted = range.findFirst('"'.characters);
  if (doubleQuoted != null) {
    doubleQuoted.moveUntil('"'.characters);
    return doubleQuoted.currentCharacters.toString();
  }
  if (int.tryParse(source) != null) {
    return int.parse(source);
  }
  if (double.tryParse(source) != null) {
    return double.parse(source);
  }
  if (source.toLowerCase() == 'true') {
    return true;
  }
  if (source.toLowerCase() == 'false') {
    return false;
  }
  if (source.toLowerCase() == 'null') {
    return null;
  }
  if (DateTime.tryParse(source) != null) {
    return DateTime.parse(source);
  }
  throw UnimplementedError(
      'https://gitlab.com/takkan/takkan_script/-/issues/40');
}

enum Operator {
  equalTo(expression: '==', b4aSnippet: 'equalTo("#n",#v'),
  notEqualTo(expression: '!=', b4aSnippet: 'notEqualTo("#n",#v'),
  greaterThan(expression: '>', b4aSnippet: 'greaterThan("#n",#v'),
  ;

  const Operator({
    required this.expression,
    required this.b4aSnippet,
  });

  final String expression;
  final String b4aSnippet;
}

@JsonSerializable(explicitToJson: true)
class Condition<T> extends Equatable {
  const Condition(
      {required this.field, required this.operator, required this.value});

  factory Condition.fromJson(Map<String, dynamic> json) =>
      _$ConditionFromJson(json);

  factory Condition.equalTo(String field, T value) {
    return Condition(field: field, operator: Operator.equalTo, value: value);
  }

  final String field;
  final Operator operator;
  final dynamic value;

  @override
  List<Object?> get props => [field, operator, value];

  String get cloudOut =>
      'query.${operator.b4aSnippet.replaceAll('#n', field).replaceAll('#v', (value is String) ? '"$value"' : value.toString())});';

  Map<String, dynamic> toJson() => _$ConditionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Query {
  Query(this.document, this.conditions);

  factory Query.fromJson(Map<String, dynamic> json) => _$QueryFromJson(json);
  final Document document;

  final List<Condition<dynamic>> conditions;

  Map<String, dynamic> toJson() => _$QueryToJson(this);
}

class ConditionBuilder {
  ConditionBuilder(this.document, this.fieldName, this.field);

  final Document document;
  final Field<dynamic, dynamic> field;
  final String fieldName;

  IntegerConditionBuilder get int =>
      IntegerConditionBuilder(document, fieldName, field, this);

  StringConditionBuilder get string =>
      StringConditionBuilder(document, fieldName, field, this);
}

class IntegerConditionBuilder {
  IntegerConditionBuilder(
      this.parent, this.fieldName, this.field, this.builder);

  Document parent;
  Field<dynamic, dynamic> field;
  String fieldName;
  ConditionBuilder builder;

  Condition<int> equalTo(int value) {
    return Condition(
      field: fieldName,
      operator: Operator.equalTo,
      value: value,
    );
  }

  Condition<int> notEqualTo(int value) {
    return Condition(
      field: fieldName,
      operator: Operator.notEqualTo,
      value: value,
    );
  }

  Condition<int> greaterThan(int value) {
    return Condition(
      field: fieldName,
      operator: Operator.greaterThan,
      value: value,
    );
  }
}

class StringConditionBuilder {
  StringConditionBuilder(this.parent, this.fieldName, this.field, this.builder);

  Document parent;
  Field<dynamic, dynamic> field;
  String fieldName;
  ConditionBuilder builder;

  Condition<String> equalTo(String value) {
    return Condition(
      field: fieldName,
      operator: Operator.equalTo,
      value: value,
    );
  }

  Condition<String> notEqualTo(String value) {
    return Condition(
      field: fieldName,
      operator: Operator.notEqualTo,
      value: value,
    );
  }

  Condition<String> longerThan(int value) {
    return Condition(
      field: fieldName,
      operator: Operator.greaterThan,
      value: value,
    );
  }
}
