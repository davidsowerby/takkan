import 'package:characters/characters.dart';
import '../../common/exception.dart';
import '../../common/log.dart';

import '../../data/select/condition/condition.dart';
import '../../data/select/condition/integer_condition.dart';
import '../../data/select/condition/string_condition.dart';
import '../document/document.dart';
import '../field/field.dart';
import '../schema.dart';

const separator = '&&';

/// Builds a [Condition] instance from an expression in the form of "field operator operand"
///
/// - a > b
/// - a contains b
///
/// where the operator is separated from operands by a single space
///
/// For String operands, surround with single quotes:
///
/// - a contains 'x'
///
/// For operands held in parameters, use a '#':
///
/// - a > #b
///
/// Or for a String
///
/// - a contains '#x'
///
/// The value will be looked up from [lookupParameterValue]
class ConditionBuilder {
  const ConditionBuilder(
      {required this.document, dynamic Function(String)? lookupParameterValue});

  final Document document;

  Condition<dynamic> _parseCondition(String cond, bool forQuery) {
    final s = cond.split(' ');

    /// helps with minor spacing issues
    s.removeWhere((element) => element.isEmpty);
    if (s.length != 3) {
      final String msg = '$cond is not a valid condition';
      logName('Condition').e(msg);
      throw TakkanException(msg);
    }
    final String operand1 = s[0];
    final String operator = s[1];
    final String operand2 = s[2];
    bool foundOp = false;
    bool conditionCreated = false;
    for (final Operator op in Operator.values) {
      if (op.operator == operator) {
        foundOp = true;
        final Condition<dynamic> c = _createCondition(
          fieldName: operand1,
          operator: op,
          operand: _decodeValue(operand2),
          forQuery: forQuery,
        );
        // Make sure this is a valid operation
        c.checkValidOperation(
            op); // TODO: Whatever this is supposed to do will break if operand is different type to value
        // TODO: valid at this point means that the condition will not fial from one of the exclusions, eg 'notValidForType - call it 'compliant''
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

  Condition<dynamic> _createCondition({
    required String fieldName,
    required Operator operator,
    dynamic operand,
    required bool forQuery,
  }) {
    final f = document.field(fieldName);
    switch (f.modelType) {
      case int:
        return IntegerCondition(
          field: fieldName,
          operator: operator,
          operand: operand,
          forQuery: forQuery,
        );
      case String:
        return StringCondition(
          field: fieldName,
          operator: operator,
          operand: operand,
          forQuery: forQuery,
        );
      default:
        final String msg = '${f.runtimeType} not implemented yet';
        logType(runtimeType).e(msg);
        throw UnimplementedError(msg);
    }
  }

  dynamic _decodeValue(String source) {
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
        'value: $source Have you forgotten to put quotes around String in queryScript?. If not, see https://gitlab.com/takkan/takkan_script/-/issues/40');
  }

  /// Parses a String expression and converts to one or more [Condition]s
  /// Field names are part of the query expression, unlike [parseForValidation],
  /// which relate to a specific field
  List<Condition<dynamic>> parseForQuery({required String expression}) {
    final List<Condition<dynamic>> conditions =
        List<Condition<dynamic>>.empty(growable: true);
    final c = expression.split(separator);
    for (final String cond in c) {
      conditions.add(_parseCondition(cond, true));
    }
    return conditions;
  }

  /// Parses a String expression and converts to one or more [Condition]s
  /// The field name for the [Condition] is taken from [field], unlike [parseForQuery],
  /// which contains field names as part of the query expression
  List<Condition<dynamic>> parseForValidation({
    required Field<dynamic> field,
    required String expression,
  }) {
    final f = field;
    final List<Condition<dynamic>> conditions =
        List<Condition<dynamic>>.empty(growable: true);
    final c = expression.split(separator);
    for (final String cond in c) {
      conditions.add(_parseCondition('${f.name} $cond', false));
    }
    return conditions;
  }
}
