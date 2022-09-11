// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import '../../common/exception.dart';
import '../../common/log.dart';
import '../../data/select/condition/condition.dart';
import '../../util/interpolate.dart';
import '../../util/walker.dart';
import '../query/expression.dart';
import '../schema.dart';
import '../validation/validation_error_messages.dart';
import 'pointer.dart';
import 'relation.dart';

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
abstract class Field<MODEL, C extends Condition<MODEL>> extends SchemaElement {
  Field({
    this.constraints = const [],
    required this.required,
    this.defaultValue,
    this.validation,
    required super.isReadOnly,
  });

  @override
  List<Object?> get props =>
      [...super.props, _conditions, required, defaultValue];

  List<Object?> get excludeProps => [constraints, validation];

  final List<C> constraints;
  final String? validation;
  final bool required;

  final MODEL? defaultValue;

  /// Returns [_conditions], which is built during [Field.doInit] to combine
  /// [constraints] and [validation].  As long as the end result is the same,
  /// it does not matter which method (or even both) is used to specify a condition
  ///
  /// Ignore for JSON output, as the original [validation] and [constraints] are
  /// serialised.
  final List<Condition<dynamic>> _conditions = [];

  /// True only for [FPointer] and [FRelation]
  bool get isLinkField => false;

  bool get hasValidation => required || (conditions.isNotEmpty);

  List<Condition<dynamic>> get conditions => _conditions;

  Type get modelType;

  /// Returns a list of validation errors, or an empty list if there are none
  List<String> doValidation(
      MODEL value, ValidationErrorMessages errorMessages) {
    if (conditions.isEmpty) {
      return List.empty();
    }
    final List<String> errors = List.empty(growable: true);
    for (final Condition<dynamic> condition in conditions) {
      if (!condition.isValid(value)) {
        final String? errorPattern = errorMessages.find(condition.operator);
        if (errorPattern == null) {
          final String msg =
              'error message not defined for ${condition.operator}';
          logType(runtimeType).e(msg);
          throw TakkanException(msg);
        } else {
          errors.add(expandErrorMessage(
              operandIsString: condition.operand is String,
              errorPattern,
              {
                'threshold': condition.operand,
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
      _conditions.add(condition.withField(name));
    }
    final vs = validation;
    if (vs != null) {
      final c = ConditionBuilder(document: parent as Document)
          .parseForValidation(field: this, expression: vs);
      final List<Condition<MODEL>> c1 = List.castFrom(c);
      _conditions.addAll(c1);
    }
  }
}
