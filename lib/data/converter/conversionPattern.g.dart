// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversionPattern.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversionErrorMessages _$ConversionErrorMessagesFromJson(
    Map<String, dynamic> json) {
  return ConversionErrorMessages(
    (json['patterns'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  );
}

Map<String, dynamic> _$ConversionErrorMessagesToJson(
        ConversionErrorMessages instance) =>
    <String, dynamic>{
      'patterns': instance.patterns,
    };
