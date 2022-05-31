import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/schema/field/field.dart';
import 'package:takkan_script/validation/result.dart';
import 'package:takkan_script/validation/validate.dart';

part 'integer.freezed.dart';
part 'integer.g.dart';

@JsonSerializable(explicitToJson: true)
class FInteger extends Field<VInteger, int> {
  @override
  Type get modelType => int;

  FInteger({
    super.defaultValue,
    super. validations = const [],
    super. required = false,
    super. readOnly = IsReadOnly.inherited,
  });

  factory FInteger.fromJson(Map<String, dynamic> json) =>
      _$FIntegerFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FIntegerToJson(this);
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
    return [const VInteger.greaterThan(1), const VInteger.lessThan(1)];
  }

  static List<VResultRef> refs() {
    final List<VResultRef> refsList = List.empty(growable: true);
    final values = VInteger.values();
    for (final element in values) {
      refsList.add(VInteger.ref(element));
    }
    return refsList;
  }
}

enum IntegerValidation { greaterThan, lessThan }
