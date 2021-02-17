import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/data/converter/converter.dart';
import 'package:precept_script/script/script.dart';

part 'conversionErrorMessages.g.dart';

/// Holds error message patterns for [ModelViewConverter] implementations
/// This will become part of [PScript]
@JsonSerializable(nullable: true, explicitToJson: true)
class ConversionErrorMessages {
  final Map<String, String> patterns;

  const ConversionErrorMessages(this.patterns);

  factory ConversionErrorMessages.fromJson(Map<String, dynamic> json) =>
      _$ConversionErrorMessagesFromJson(json);

  Map<String, dynamic> toJson() => _$ConversionErrorMessagesToJson(this);
}

const Map<String, String> defaultConversionPatterns = const {
  'IntStringConverter': 'must be a whole number',
  'DoubleStringConverter': 'must be a number',
};

