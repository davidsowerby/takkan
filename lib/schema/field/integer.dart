import 'package:freezed_annotation/freezed_annotation.dart';

import '../../script/common.dart';
import '../../validation/result.dart';
import '../../validation/validate.dart';
import 'field.dart';

part 'integer.freezed.dart';
part 'integer.g.dart';

@JsonSerializable(explicitToJson: true)
class FInteger extends Field<VInteger, int> {

  FInteger({
    super.defaultValue,
    super. validations = const [],
    super. required = false,
    super. readOnly = IsReadOnly.inherited,
  });

  factory FInteger.fromJson(Map<String, dynamic> json) =>
      _$FIntegerFromJson(json);
  @override
  Type get modelType => int;

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
