import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/field/string.dart';

part 'validationErrorMessages.g.dart';

/// This is a temporary setup until the validation patterns can be included in PScript,
/// or some other server based method is designed
///
@JsonSerializable(nullable: true, explicitToJson: true)
class ValidationErrorMessages {
  final Map<dynamic, String> typePatterns;

  const ValidationErrorMessages( this.typePatterns);

  factory ValidationErrorMessages.fromJson(Map<String, dynamic> json) =>
      _$ValidationErrorMessagesFromJson(json);

  Map<String, dynamic> toJson() => _$ValidationErrorMessagesToJson(this);

  /// Unfortunately we cannot make this type safe, but [key] needs to be an enum constant such as [ValidateInteger.isGreaterThan]
  String find(dynamic key){
    return typePatterns[key.toString()];
  }
}

const Map<dynamic, String> defaultValidationPatterns = const {
  ValidateInteger.isGreaterThan: 'must be greater than {0}',
  ValidateInteger.isLessThan: 'must be less than {0}',
  ValidateString.isLongerThan: 'must be more than {0} characters',
  ValidateString.isShorterThan: 'must be less than {0} characters',
};
