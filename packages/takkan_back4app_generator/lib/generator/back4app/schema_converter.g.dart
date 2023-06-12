// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema_converter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Back4AppSchema _$Back4AppSchemaFromJson(Map<String, dynamic> json) =>
    Back4AppSchema(
      results: (json['results'] as List<dynamic>)
          .map((e) => ServerSchemaClass.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$Back4AppSchemaToJson(Back4AppSchema instance) =>
    <String, dynamic>{
      'results': instance.results.map((e) => e.toJson()).toList(),
    };

ServerSchemaClass _$ServerSchemaClassFromJson(Map<String, dynamic> json) =>
    ServerSchemaClass(
      fields: (json['fields'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, ServerSchemaField.fromJson(e as Map<String, dynamic>)),
      ),
      className: json['className'] as String,
      classLevelPermissions: json['classLevelPermissions'] == null
          ? null
          : SchemaClassLevelPermissions.fromJson(
              json['classLevelPermissions'] as Map<String, dynamic>),
      indexes: json['indexes'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ServerSchemaClassToJson(ServerSchemaClass instance) {
  final val = <String, dynamic>{
    'className': instance.className,
    'fields': instance.fields.map((k, e) => MapEntry(k, e.toJson())),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'classLevelPermissions', instance.classLevelPermissions?.toJson());
  writeNotNull('indexes', instance.indexes);
  return val;
}

ServerSchemaField _$ServerSchemaFieldFromJson(Map<String, dynamic> json) =>
    ServerSchemaField(
      type: json['type'] as String,
      required: json['required'] as bool?,
      defaultValue: json['defaultValue'],
    );

Map<String, dynamic> _$ServerSchemaFieldToJson(ServerSchemaField instance) {
  final val = <String, dynamic>{
    'type': instance.type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('required', instance.required);
  writeNotNull('defaultValue', instance.defaultValue);
  return val;
}

ReferenceSchemaField _$ReferenceSchemaFieldFromJson(
        Map<String, dynamic> json) =>
    ReferenceSchemaField(
      targetClass: json['targetClass'] as String,
      required: json['required'] as bool,
      type: json['type'] as String,
      defaultValue: json['defaultValue'],
    );

Map<String, dynamic> _$ReferenceSchemaFieldToJson(
    ReferenceSchemaField instance) {
  final val = <String, dynamic>{
    'type': instance.type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('required', instance.required);
  writeNotNull('defaultValue', instance.defaultValue);
  val['targetClass'] = instance.targetClass;
  return val;
}

SchemaClassLevelPermissions _$SchemaClassLevelPermissionsFromJson(
        Map<String, dynamic> json) =>
    SchemaClassLevelPermissions(
      find: json['find'] as Map<String, dynamic>,
      get: json['get'] as Map<String, dynamic>,
      count: json['count'] as Map<String, dynamic>,
      create: json['create'] as Map<String, dynamic>,
      update: json['update'] as Map<String, dynamic>,
      delete: json['delete'] as Map<String, dynamic>,
      addField: json['addField'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$SchemaClassLevelPermissionsToJson(
        SchemaClassLevelPermissions instance) =>
    <String, dynamic>{
      'find': instance.find,
      'get': instance.get,
      'count': instance.count,
      'create': instance.create,
      'update': instance.update,
      'delete': instance.delete,
      'addField': instance.addField,
    };
