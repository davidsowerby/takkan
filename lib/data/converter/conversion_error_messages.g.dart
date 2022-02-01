// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversion_error_messages.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversionErrorMessages _$ConversionErrorMessagesFromJson(
        Map<String, dynamic> json) =>
    ConversionErrorMessages(
      patterns: (json['patterns'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$ConversionErrorMessagesToJson(
        ConversionErrorMessages instance) =>
    <String, dynamic>{
      'patterns': instance.patterns,
    };
