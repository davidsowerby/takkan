import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_schema/data/select/condition/geo_position_condition.dart';
import 'package:takkan_schema/data/select/condition/post_code_condition.dart';

import '../../../common/constants.dart';
import '../../../common/exception.dart';
import '../../../common/log.dart';
import '../../../common/serial.dart';
import '../../../schema/field/field.dart';
import '../../../schema/query/expression.dart';
import '../../../schema/query/query.dart';
import '../../json_converter.dart';
import 'bool_condition.dart';
import 'date_time_condition.dart';
import 'double_condition.dart';
import 'geo_point_condition.dart';
import 'geo_polygon_condition.dart';
import 'integer_condition.dart';
import 'json_object_condition.dart';
import 'list_int_condition.dart';
import 'pointer_condition.dart';
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

abstract class Condition<T> extends Equatable implements Serializable {
  const Condition({
    required this.field,
    required this.operator,
    required this.operand,
    required this.forQuery,
  });

  final String field;
  final Operator operator;
  @DataTypeConverter()
  final dynamic operand;
  final bool forQuery;

  bool isValid(T value) {
    return typedOperations(value);
  }

  bool throwOperatorInvalid() {
    throw UnimplementedError(
        "This should not occur.  Has an operator been missed from type specific implementation '${runtimeType.toString()}'?\nAlso check getters 'notValidForType', 'notValidForQuery' and 'notValidForValidation'");
  }

  Condition<T> withField(String field) =>
      throw UnimplementedError('with field: $field. $concrete');

  @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  List<Object?> get props => [field, operator, operand];

  T get typedOperand => operand as T;

  List<Operator> get notValidForType => [];

  List<Operator> get notValidForQuery => [...lengthOperations];

  List<Operator> get notValidForValidation => [];

  String get cloudCode =>
      '${operator.b4aSnippet.replaceAll('#n', field).replaceAll('#v', (operand is String) ? '"$operand"' : operand.toString())});';

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
      operator: 'length==',
      b4aSnippet: 'lengthEqualTo("#n", #v',
      supportsQuery: false),
  lengthGreaterThan(
      operator: 'length>',
      b4aSnippet: 'lengthGreaterThan("#n", #v',
      supportsQuery: false),
  lengthGreaterThanOrEqualTo(
      operator: 'length>=',
      b4aSnippet: 'lengthGreaterThanOrEqualTo("#n", #v',
      supportsQuery: false),
  lengthLessThan(
      operator: 'length<',
      b4aSnippet: 'lengthLessThan("#n", #v',
      supportsQuery: false),
  lengthLessThanOrEqualTo(
      operator: 'length<=',
      b4aSnippet: 'lengthLessThanOrEqualTo("#n", #v',
      supportsQuery: false),
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

/// A [ConditionBuilder] for use in [Query] definitions, with name abbreviated
/// for brevity
class Q {
  Q(this.fieldName);

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
/// It should always mirror the getters in [Q]
///
/// The field name in the returned builder is set to an empty String, because
/// the this validation is applied to a specific field.  This is adjusted by the
/// validation building process in [Field.doInit]
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

List<Condition<dynamic>>? nullableConditionListFromJson(List<dynamic>? input) {
  if (input == null) {
    return null;
  }
  return conditionListFromJson(input);
}

List<Map<String, dynamic>>? nullableConditionListToJson(
    List<Condition<dynamic>>? objectList) {
  if (objectList == null) {
    return null;
  }
  return conditionListToJson(objectList);
}

List<Condition<dynamic>> conditionListFromJson(List<dynamic> input) {
  final List<Map<String, dynamic>> json = List.castFrom(input);
  final List<Condition<dynamic>> results =
      List<Condition<dynamic>>.empty(growable: true);
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

List<Map<String, dynamic>> conditionListToJson(
    List<Condition<dynamic>> objectList) {
  final List<Map<String, dynamic>> results =
      List<Map<String, dynamic>>.empty(growable: true);
  for (final Condition<dynamic> entry in objectList) {
    final Map<String, dynamic> jsonMap = entry.toJson();

    /// Will only need the replace if we use freezed again
    /// freezed creates a delegate, hence the name change
    jsonMap[jsonClassKey] = entry.runtimeType.toString();
    results.add(jsonMap);
  } //.replaceFirst('_\$_', '');
  return results;
}
