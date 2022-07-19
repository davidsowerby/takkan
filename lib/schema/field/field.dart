// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';

import '../../common/log.dart';
import '../../data/select/condition/condition.dart';
import '../../script/walker.dart';
import '../../util/interpolate.dart';
import '../query/expression.dart';
import '../query/query_combiner.dart';
import '../schema.dart';
import '../validation/validation_error_messages.dart';

/// [MODEL] the data type of the model attribute represented
///
/// Validation can be defined by either or both of the following properties:
/// - [validation] is a script version of validation, for example '> 100'
/// - [constraints] also defines validation but in a code format.  The easiest way
/// to define these are with the helper class 'V', for example:  V.int.greaterThan(0)
///
/// Both achieve the same thing, and if both are defined, they are combined.
///
/// [_conditions] is the result of that combination. It is built in [doInit]
@ConditionConverter()
abstract class Field<MODEL> extends SchemaElement {
  Field({
    this.constraints = const [],
    required this.required,
    this.defaultValue,
    this.validation,
    required super.readOnly,
  });

  /// Returns [conditions] as this is the combination of [constraints] and
  /// [validation].  As long as the end result is the same, it does not matter
  /// which method is used to specify a condition
  @JsonKey(ignore: true)
  @override
  List<Object?> get props =>
      [...super.props, _conditions, required, defaultValue];

  List<Object?> get excludeProps => [constraints, validation];

  @JsonKey(ignore: true)
  final List<Condition<MODEL>> constraints;
  final String? validation;
  final bool required;
  @JsonKey(includeIfNull: false)
  final MODEL? defaultValue;

  /// Not really a Query, just holds conditions for validation
  final Query _conditions = Query([]);

  bool get hasValidation => required || (conditions.isNotEmpty);

  List<Condition<dynamic>> get conditions => _conditions.conditions;

  Type get modelType;

  /// Returns a list of validation errors, or an empty list if there are none
  List<String> doValidation(
      MODEL value, ValidationErrorMessages errorMessages) {
    if (conditions.isEmpty) {
      return List.empty();
    }
    final List<String> errors = List.empty(growable: true);
    for (final Condition<dynamic> condition in _conditions.conditions) {
      if (!condition.isValid(value)) {
        String? errorPattern = errorMessages.find(condition.operator);
        if (errorPattern == null) {
          errorPattern = 'error message not defined for ${condition.operator}';
          logType(runtimeType).e(errorPattern);
        } else {
          errors.add(expandErrorMessage(errorPattern, {
            'threshold': condition.reference,
          }));
        }
      }
    }
    return errors;
  }

  @override
  void doInit(InitWalkerParams params) {
    super.doInit(params);
    _buildValidations();
  }

  void _buildValidations() {
    for (final condition in constraints) {
      _conditions.conditions.add(condition.withField(name));
    }
    final vs = validation;
    if (vs != null) {
      final c = Expression(field: this).parseValidation(vs);
      final List<Condition<MODEL>> c1 = List.castFrom(c);
      _conditions.conditions.addAll(c1);
    }
  }
}
