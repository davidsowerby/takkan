// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patterns.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidationErrorMessages _$ValidationErrorMessagesFromJson(
    Map<String, dynamic> json) {
  return ValidationErrorMessages(
    (json['typePatterns'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  );
}

Map<String, dynamic> _$ValidationErrorMessagesToJson(
        ValidationErrorMessages instance) =>
    <String, dynamic>{
      'typePatterns': instance.typePatterns,
    };
