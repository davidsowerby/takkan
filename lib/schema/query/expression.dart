import 'package:characters/characters.dart';

import '../../common/exception.dart';
import '../../common/log.dart';
import '../../data/select/condition/condition.dart';
import '../../data/select/condition/integer_condition.dart';
import '../../data/select/condition/string_condition.dart';
import '../field/field.dart';
import '../field/integer.dart';
import '../field/string.dart';
import '../schema.dart';

const separator = '&&';

/// Pass either a Field or Document - one of them must be non-null
class Expression {
  const Expression({this.document, this.field});

  final Document? document;
  final Field<dynamic>? field;

  /// Query expresses field names, where for [parseValidation] the field name is implicit
  List<Condition<dynamic>> parseQuery(String expression) {
    if (document==null){
      const String msg="'document' property must be set to parse query";
      logType(runtimeType).e(msg);
      throw const TakkanException(msg);
    }
    final List<Condition<dynamic>> conditions =
        List<Condition<dynamic>>.empty(growable: true);
    final c = expression.split(separator);
    for (final String cond in c) {
      conditions.add(_parseCondition(cond));
    }
    return conditions;
  }

  /// Query expresses field names, where for [parseValidation] the field name is implicit.
  /// It is prepended to conditions, using [field]
  List<Condition<dynamic>> parseValidation(String expression) {
    final f= field;
    if (f==null){
      const String msg="'field' property must be set to parse validation";
      logType(runtimeType).e(msg);
      throw const TakkanException(msg);
    }
    final List<Condition<dynamic>> conditions =
    List<Condition<dynamic>>.empty(growable: true);
    final c = expression.split(separator);
    for (final String cond in c) {
      conditions.add(_parseCondition('${f.name} $cond'));
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
        final Condition<dynamic> c =
            _createCondition(trimmed[0], op, _decodeValue(trimmed[1]));
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

  Condition<dynamic> _createCondition(
      String fieldName, Operator op, reference) {
    final f = field ?? document?.field(fieldName);
    switch (f.runtimeType) {
      case FInteger:
        return IntegerCondition(
            field: fieldName, operator: op, reference: reference);
      case FString:
        return StringCondition(
            field: fieldName, operator: op, reference: reference);
      default:
        final String msg = '${f.runtimeType} not implemented yet';
        logType(runtimeType).e(msg);
        throw UnimplementedError(msg);
    }
  }
}
