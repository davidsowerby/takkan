import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_schema/common/constants.dart';
import 'package:takkan_schema/common/exception.dart';
import 'package:takkan_schema/common/log.dart';

import '../../../schema/field/field.dart';
import 'integer_condition.dart';
import 'string_condition.dart';

abstract class Condition<T> extends Equatable {
  const Condition({
    required this.field,
    required this.operator,
    required this.reference,
  });

  final String field;
  final Operator operator;
  final dynamic reference;

  bool isValid(T value);

  Condition<T> withField(String field);

  Map<String, dynamic> toJson();

  @JsonKey(ignore: true)
  @override
  List<Object?> get props => [field, operator, reference];

  String get cloudOut =>
      'query.${operator.b4aSnippet.replaceAll('#n', field).replaceAll('#v', (reference is String) ? '"$reference"' : reference.toString())});';
}

/// This is not ideal, as JavaScript formatting requires space after comma for formatting
/// and this is an odd place to be worrying about that.  Is there a better way?
/// See https://gitlab.com/takkan/takkan_script/-/issues/53
enum Operator {
  equalTo(expression: '==', b4aSnippet: 'equalTo("#n", #v'),
  notEqualTo(expression: '!=', b4aSnippet: 'notEqualTo("#n", #v'),
  greaterThan(expression: '>', b4aSnippet: 'greaterThan("#n", #v'),
  lessThan(expression: '<', b4aSnippet: 'lessThan("#n", #v'),
  longerThan(expression: '>', b4aSnippet: 'greaterThan("#n", #v'),
  shorterThan(expression: '<', b4aSnippet: 'lessThan("#n", #v'),
  ;

  const Operator({
    required this.expression,
    required this.b4aSnippet,
  });

  final String expression;
  final String b4aSnippet;
}

/// A [ConditionBuilder] abbreviated for brevity in definitions
class C {
  C(this.fieldName);

  final String fieldName;

  IntegerConditionBuilder get int => IntegerConditionBuilder(fieldName);

  StringConditionBuilder get string => StringConditionBuilder(fieldName);
}

// ignore: avoid_classes_with_only_static_members
// class C {
//
//   static IntegerConditionBuilder int(String fieldName) => IntegerConditionBuilder(fieldName);
//
//   static StringConditionBuilder string(String fieldName) => StringConditionBuilder(fieldName);
// }

// ignore: avoid_classes_with_only_static_members
/// This is a static only class to allow easier construction of validation
/// constraints in [Field.constraints].
///
/// It should always mirror the getters in [C]
///
/// The field name in the returned builder is set to an empty String.  This
/// is corrected by the validation building process in [Field.doInit]
class V {
  static IntegerConditionBuilder get int => IntegerConditionBuilder('');

  static StringConditionBuilder get string => StringConditionBuilder('');
}

class ConditionConverter
    implements JsonConverter<Condition<dynamic>, Map<String, dynamic>> {
  const ConditionConverter();

  @override
  Condition<dynamic> fromJson(Map<String, dynamic> json) {
    final elementType = json[jsonClassKey];
    switch (elementType) {
      case 'IntegerCondition':
        return IntegerCondition.fromJson(json);
      case 'StringCondition':
        return StringCondition.fromJson(json);

      default:
        final msg = 'SchemaElement type $elementType not recognised';
        logType(runtimeType).e(msg);
        throw SchemaException(msg);
    }
  }

  @override
  Map<String, dynamic> toJson(Condition<dynamic> object) {
    final type = object.runtimeType;
    final Map<String, dynamic> jsonMap = object.toJson();
    jsonMap[jsonClassKey] = type.toString();
    return jsonMap;
  }
}
