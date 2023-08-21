import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../common/exception.dart';
import '../../../schema/field/field.dart';
import '../../../schema/query/expression.dart';
import '../../../schema/query/query.dart';
import 'integer_condition.dart';
import 'string_condition.dart';

part 'condition.g.dart';

/// Represents a condition used for a query or validation.  Used to generate
/// server side code, and support client side validation.
///
/// There is a type specific implementation for each supported data type, but not
/// all [operator]s are applicable to all Takkan data types.  The 'lengthXXX' operators,
/// for example, apply only to types such as String and List.  Refer to the type
/// specific implementation for details.
///
/// There are also some operators which are not currently supported in query
/// (this is determined by Parse.Query), but this may be overcome, see https://gitlab.com/takkan/takkan_design/-/issues/49
///
///
/// To validate a [Condition] dynamically, construct it, and then call [isValid].
/// A [TakkanException] is thrown if the operator is not supported.  A true/false
/// result will be returned if it is.
///
/// A String expression can also be used to create [Condition] instances, see [ConditionBuilder]
///
/// if [forQuery] is true, this condition applies to a [Query], otherwise it applies to validation.

const String concrete =
    'Must be defined in sub-class.  This should not be used as a concrete class, but needed for serialisation';

// @JsonSerializable()
abstract class Condition<T> extends Equatable {
  const Condition({
    required this.field,
    required this.operator,
    required this.operand,
    required this.forQuery,
  });

  final String field;
  final Operator operator;
  final dynamic operand;
  final bool forQuery;

  bool isValid(T value) {
    return typedOperations(value);
  }

  bool throwOperatorInvalid() {
    throw UnimplementedError(
        "This should not occur.  Has an operator been missed from type specific implementation '${runtimeType.toString()}'?\nAlso check getters 'notValidForType', 'notValidForQuery' and 'notValidForValidation'");
  }

  Condition<T> withField(String field) => throw UnimplementedError(concrete);

  Map<String, dynamic> toJson();

 @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  List<Object?> get props => [field, operator, operand];

  T get typedOperand => operand as T;

  List<Operator> get notValidForType => [];

  List<Operator> get notValidForQuery => [...lengthOperations];

  List<Operator> get notValidForValidation => [];

  String get cloudOut =>
      'query.${operator.b4aSnippet.replaceAll('#n', field).replaceAll('#v', (operand is String) ? '"$operand"' : operand.toString())});';

  /// Call inherited method [isValid] rather than directly accessing this method
  bool typedOperations(T value) => throw UnimplementedError(concrete);

  /// Throws an exception if the proposed operation is not valid for type, query or validation as appropriate
  void checkValidOperation(Operator op) {
    if (notValidForType.contains(operator)) {
      throw UnsupportedError('Operator $operator is not supported for type $T');
    }
    if (forQuery && notValidForQuery.contains(operator)) {
      throw UnsupportedError('Operator $operator is not supported in a Query');
    }
    if (!forQuery && notValidForValidation.contains(operator)) {
      throw UnsupportedError(
          'Operator $operator is not supported in validation');
    }
  }
}

/// [Operator] is used in [Condition] for specifying query and validation conditions
///
/// [operator] provides the syntax for String based expressions, translated by
/// [ConditionBuilder] into [Condition] instances.
///
/// [b4aSnippet] is used to generate Back4App code
///
/// Not all conditions are suitable for queries, and this is determined by the Back4App
/// Parse.Query.  For example, Parse.Query has no option for selecting String fields
/// on the basis of String length.  These operations therefore have [supportsQuery] set to false
///
/// The #n, #v syntax is not ideal, as JavaScript formatting requires space after comma for formatting
/// and this is an odd place to be worrying about that.  Is there a better way?
/// See https://gitlab.com/takkan/takkan_script/-/issues/53
@JsonEnum(alwaysCreate: true)
enum Operator {
  equalTo(operator: '==', b4aSnippet: 'equalTo("#n", #v'),
  notEqualTo(operator: '!=', b4aSnippet: 'notEqualTo("#n", #v'),
  greaterThan(operator: '>', b4aSnippet: 'greaterThan("#n", #v'),
  greaterThanOrEqualTo(
      operator: '>=', b4aSnippet: 'greaterThanOrEqualTo("#n", #v'),
  lessThan(operator: '<', b4aSnippet: 'lessThan("#n", #v'),
  lessThanOrEqualTo(operator: '<=', b4aSnippet: 'lessThanOrEqualTo("#n", #v'),
  lengthEqualTo(
      operator: 'length==', b4aSnippet: '????("#n", #v', supportsQuery: false),
  lengthGreaterThan(
      operator: 'length>', b4aSnippet: '????("#n", #v', supportsQuery: false),
  lengthGreaterThanOrEqualTo(
      operator: 'length>=', b4aSnippet: '????("#n", #v', supportsQuery: false),
  lengthLessThan(
      operator: 'length<', b4aSnippet: '????("#n", #v', supportsQuery: false),
  lengthLessThanOrEqualTo(
      operator: 'length<=', b4aSnippet: '????("#n", #v', supportsQuery: false),
  ;

  const Operator({
    required this.operator,
    required this.b4aSnippet,
    this.supportsQuery = true,
  });

  final String operator;
  final String b4aSnippet;
  final bool supportsQuery;
}

/// A [ConditionBuilder] abbreviated for brevity in [Query] definitions
class C {
  C(this.fieldName);

  final String fieldName;

  IntegerConditionBuilder get int =>
      IntegerConditionBuilder(fieldName: fieldName, forQuery: true);

  StringConditionBuilder get string =>
      StringConditionBuilder(fieldName: fieldName, forQuery: true);
}

// ignore: avoid_classes_with_only_static_members
/// This is a static only class to allow easier construction of validation
/// constraints in [Field.constraints].
///
/// It should always mirror the getters in [C]
///
/// The field name in the returned builder is set to an empty String.  This
/// is corrected by the validation building process in [Field.doInit]
class V {
  static IntegerConditionBuilder get int =>
      IntegerConditionBuilder(fieldName: '', forQuery: false);

  static StringConditionBuilder get string =>
      StringConditionBuilder(fieldName: '', forQuery: false);
}

List<Operator> lengthOperations = const [
  Operator.lengthEqualTo,
  Operator.lengthGreaterThan,
  Operator.lengthGreaterThanOrEqualTo,
  Operator.lengthLessThan,
  Operator.lengthLessThanOrEqualTo,
];
