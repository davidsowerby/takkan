import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/validation/result.dart';
import 'package:precept_script/validation/validate.dart';

part 'integer.freezed.dart';
part 'integer.g.dart';

@JsonSerializable(explicitToJson: true)
class PInteger extends PField<VInteger, int> {
  Type get modelType => int;

  PInteger({
    int? defaultValue,
    List<VInteger> validations = const [],
    bool required = false,
    IsReadOnly readOnly = IsReadOnly.inherited,
  }) : super(
    readOnly: readOnly,
          required: required,
          validations: validations,
          defaultValue: defaultValue,
        );

  factory PInteger.fromJson(Map<String, dynamic> json) =>
      _$PIntegerFromJson(json);

  Map<String, dynamic> toJson() => _$PIntegerToJson(this);
}

@freezed
class VInteger with _$VInteger implements V {
  const factory VInteger.greaterThan(int threshold) = _$IntegerGreaterThan;

  const factory VInteger.lessThan(int threshold) = _$IntegerLessThan;

  factory VInteger.fromJson(Map<String, dynamic> json) =>
      _$VIntegerFromJson(json);

  static VResult validate(VInteger validation, int value) {
    final bool passed = validation.map(
        greaterThan: (v) => value > v.threshold,
        lessThan: (v) => value < v.threshold);
    return VResult(passed: passed, ref: ref(validation));
  }

  static VResultRef ref(VInteger validation) {
    return validation.map(
      greaterThan: (v) => VResultRef(
        messageKey: IntegerValidation.greaterThan,
        javaScript: 'value > threshold',
        toJson: v.toJson(),
      ),
      lessThan: (v) => VResultRef(
        messageKey: IntegerValidation.lessThan,
        javaScript: 'value < threshold',
        toJson: v.toJson(),
      ),
    );
  }

  static List<VInteger> values() {
    return [VInteger.greaterThan(1), VInteger.lessThan(1)];
  }

  static List<VResultRef> refs() {
    List<VResultRef> refsList = List.empty(growable: true);
    final values = VInteger.values();
    values.forEach((element) {
      refsList.add(VInteger.ref(element));
    });
    return refsList;
  }
}

enum IntegerValidation { greaterThan, lessThan }
