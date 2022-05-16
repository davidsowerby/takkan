import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/schema/field/field.dart';
import 'package:takkan_script/validation/result.dart';
import 'package:takkan_script/validation/validate.dart';

part 'string.freezed.dart';
part 'string.g.dart';

@JsonSerializable(explicitToJson: true)
class FString extends Field<VString, String> {
  @override
  Type get modelType => String;

  FString({
    super.defaultValue,
    super.validations = const [],
    super.required = false,
    super.readOnly = IsReadOnly.inherited,
  }) ;

  factory FString.fromJson(Map<String, dynamic> json) =>
      _$FStringFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FStringToJson(this);
}

@freezed
class VString with _$VString implements V {
  const factory VString.longerThan(int threshold) = _$StringGreaterThan;

  const factory VString.shorterThan(int threshold) = _$StringLessThan;

  factory VString.fromJson(Map<String, dynamic> json) =>
      _$VStringFromJson(json);

  static VResult validate(VString validation, String value) {
    final bool passed = validation.map(
        longerThan: (v) => value.length > v.threshold,
        shorterThan: (v) => value.length < v.threshold);
    return VResult(passed: passed, ref: ref(validation));
  }

  static VResultRef ref(VString validation) {
    return validation.map(
      longerThan: (v) => VResultRef(
        messageKey: StringValidation.longerThan,
        javaScript: 'value.length > threshold',
        toJson: v.toJson(),
      ),
      shorterThan: (v) => VResultRef(
        messageKey: StringValidation.shorterThan,
        javaScript: 'value.length < threshold',
        toJson: v.toJson(),
      ),
    );
  }

  static List<VString> values() {
    return [VString.longerThan(1), VString.shorterThan(1)];
  }

  static List<VResultRef> refs() {
    List<VResultRef> refsList = List.empty(growable: true);
    final values = VString.values();
    values.forEach((element) {
      refsList.add(VString.ref(element));
    });
    return refsList;
  }
}

enum StringValidation { longerThan, shorterThan }
