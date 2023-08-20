import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../script/script.dart';
import 'converter.dart';

part 'conversion_error_messages.g.dart';

/// Holds error message patterns for [ModelViewConverter] implementations
/// This will become part of [Script]
@JsonSerializable(explicitToJson: true)
class ConversionErrorMessages extends Equatable {
  const ConversionErrorMessages({this.patterns = const {}});

  factory ConversionErrorMessages.fromJson(Map<String, dynamic> json) =>
      _$ConversionErrorMessagesFromJson(json);
  final Map<String, String> patterns;

  Map<String, dynamic> toJson() => _$ConversionErrorMessagesToJson(this);

  @JsonKey(ignore: true)
  @override
  List<Object?> get props => [patterns];
}

const Map<String, String> defaultConversionPatterns = {
  'IntStringConverter': 'must be a whole number',
  'DoubleStringConverter': 'must be a number',
};
