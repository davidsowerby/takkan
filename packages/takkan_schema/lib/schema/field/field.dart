// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:change_case/change_case.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/constants.dart';
import '../../common/exception.dart';
import '../../common/log.dart';
import '../../data/json_converter.dart';
import '../../data/select/condition/condition.dart';
import '../../util/interpolate.dart';
import '../../util/walker.dart';
import '../common/diff.dart';
import '../common/schema_element.dart';
import '../document/document.dart';
import '../query/expression.dart';
import '../query/query.dart';
import '../schema.dart';
import '../validation/validation_error_messages.dart';

part 'field.g.dart';

/// [MODEL] the data type of the model attribute represented
///
/// - [index] is the type of index to apply to this field, if any.  See [Index]
///
/// Validation can be defined by either or both of the following properties:
/// - [validation] is a script version of validation, for example '> 100'
/// - [constraints] defines validation but in a code format.  The easiest way
/// to define these are with the helper class 'V', for example:  V.int.greaterThan(0)
///
/// Both achieve the same thing, and if both are defined, they are combined, and
/// retrieved as [conditions].  The underlying [_conditions] property is built
/// in [doInit]
///
/// The apparently unnecessary set up of [constraints], and passing them to [_constraints]
/// is to facilitate the use of a common condition converter
@JsonSerializable(explicitToJson: true)
class Field<MODEL> extends SchemaElement {

  Field({
    bool? required,
    this.defaultValue,
    this.validation,
    IsReadOnly? isReadOnly,
    Index? index,
    List<Condition<MODEL>> constraints = const [],
  })  : index = index ?? Index.none,
        _constraints = constraints,
        required = required ?? false,
        super(isReadOnly: isReadOnly ?? IsReadOnly.no);
  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);

  @JsonKey(fromJson: conditionListFromJson, toJson: conditionListToJson)
  List<Condition<dynamic>> _constraints;

  @override
  List<Object?> get props =>
      [...super.props, _conditions, required, index, defaultValue];

  final Index index;

  @JsonKey(includeToJson: false, includeFromJson: false)
  List<Condition<MODEL>> get constraints =>
      _constraints as List<Condition<MODEL>>;

  final String? validation;
  final bool required;
  @DataTypeConverter()
  final MODEL? defaultValue;

  String get cloudTypeLabel {
    switch (modelType) {
      case int:
        return 'integer';
      default:
        throw UnsupportedError('Unsupported model type: $modelType');
    }
  }

  String get cloudImportName => 'validate${cloudTypeLabel.toCapitalCase()}';

  String get cloudImportStatement =>
      "const $cloudImportName = require('./${cloudTypeLabel}_validation.js');";

  @JsonKey(includeToJson: false, includeFromJson: false)
  final List<Condition<MODEL>> _conditions = [];

  /// True only for [FPointer] and [FRelation]
  bool get isLinkField => false;

  bool get hasValidation => required || (conditions.isNotEmpty);

  /// Built during [Field.doInit] to combine [constraints] and [validation].  It
  /// does not matter which method (or even both) is used to specify a condition
  ///
  /// See [conditions]
  ///
  /// Ignore for JSON output, as the original [validation] and [constraints] are
  /// serialised.
  @JsonKey(includeToJson: false, includeFromJson: false)
  List<Condition<MODEL>> get conditions => _conditions;

  Type get modelType => MODEL;

  @override
  Map<String, dynamic> toJson() => _$FieldToJson(this);

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
    _conditions.clear();
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

/// The following notes relate specifically to Back4App running on MongoDB
/// backend:
///
/// ## Overview of Use
///
/// - Use [hashed] for unique identifiers
/// - Use [geo2d], [geo2dSphere], [geoHaystack] for location data
/// - Use [text] for text search and language queries
///
/// **2dsphere** - This is the recommended index for most geospatial data. It indexes
/// geometry as GeoJSON points, lines and polygons on a sphere. Supports the most
/// precise queries and complex shapes.

/// **2d** - Indexes data in 2 dimensions on a flat plane, like Cartesian coordinates.
/// Less precise than 2dsphere but has lower overhead. Best for simple point data
/// and queries.

/// **geoHaystack** -
/// Designed for very large geospatial data sets. Uses buckets to group nearby
/// points and improve performance. Sacrifices precision for speed with large data.
///
///
/// ## Recommendations for Location Data:
///
/// - Start with 2dsphere for precise geospatial queries.
/// - Use 2d if you just need basic point queries and want lower overhead.
/// - Consider geoHaystack if you have huge data sets and can sacrifice some
/// accuracy for speed.
/// - Most apps are fine with 2dsphere unless they have complex performance needs
/// or very large data volumes.
///
/// So in summary, 2dsphere is best for precision, 2d for simpler points, and
/// geoHaystack for optimizing large data sets by approximating location.
enum Index {
  none,
  ascending,
  descending,
  geo2d,
  geo2dSphere,
  geoHaystack,
  text,
  hashed
}

/// Captures changes to a field as part of a [DocumentDiff].  Properties are
/// nullable as the intent is to require specification of only those fields that
/// are changed
///
/// The apparently unnecessary set up of [constraints], and passing them to [_constraints]
/// is to facilitate the use of a common Condition converter
///
/// Note the use of [removeDefaultValue].  Set this to true if you wish to clear
/// the base default value to null.  Setting [defaultValue] to null does not work
/// for this purpose, as a null diff represents 'no change'
///
@JsonSerializable(explicitToJson: true)
class FieldDiff<MODEL> implements Diff<Field<MODEL>>{

  FieldDiff({
    this.required,
    this.defaultValue,
    this.validation,
    this.isReadOnly,
    this.index,
    this.removeDefaultValue=false,
    List<Condition<MODEL>>? constraints,
  }) : _constraints = constraints;

  factory FieldDiff.fromJson(Map<String, dynamic> json) =>
      _$FieldDiffFromJson(json);
  bool removeDefaultValue;

  final Index? index;
  @JsonKey(fromJson: conditionListFromJson, toJson: conditionListToJson)
  final List<Condition<dynamic>>? _constraints;

  @JsonKey(includeToJson: false, includeFromJson: false)
  List<Condition<MODEL>>? get constraints =>
      _constraints as List<Condition<MODEL>>?;

  final String? validation;
  final bool? required;
  final IsReadOnly? isReadOnly;
  @DataTypeConverter()
  final MODEL? defaultValue;

  /// Applies this diff to the [base]
  @override
  Field<MODEL> applyTo(Field<MODEL> base) {
    return Field<MODEL>(
      defaultValue: removeDefaultValue ? null : defaultValue ?? base.defaultValue,
      required: required ?? base.required,
      index: index ?? base.index,
      isReadOnly: isReadOnly ?? base.isReadOnly,
      validation: validation ?? base.validation,
      constraints: constraints ?? base.constraints,
    );
  }

  Map<String, dynamic> toJson() => _$FieldDiffToJson(this);
}
