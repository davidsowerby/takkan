import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/data/converter/converter.dart';
import 'package:takkan_script/script/script.dart';

part 'conversion_error_messages.g.dart';

/// Holds error message patterns for [ModelViewConverter] implementations
/// This will become part of [Script]
@JsonSerializable( explicitToJson: true)
class ConversionErrorMessages {
  final Map<String, String> patterns;

  const ConversionErrorMessages({this.patterns=const {}});

  factory ConversionErrorMessages.fromJson(Map<String, dynamic> json) =>
      _$ConversionErrorMessagesFromJson(json);

  Map<String, dynamic> toJson() => _$ConversionErrorMessagesToJson(this);
}

const Map<String, String> defaultConversionPatterns =  {
  'IntStringConverter': 'must be a whole number',
  'DoubleStringConverter': 'must be a number',
};

