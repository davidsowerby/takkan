import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/data/object/geo.dart';
import 'package:precept_script/data/object/jsonObject.dart';
import 'package:precept_script/data/object/pointer.dart';
import 'package:precept_script/data/object/relation.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/field/pointer.dart';
import 'package:precept_script/schema/field/relation.dart';
import 'package:precept_script/schema/schema.dart';

import 'converter.dart';

part 'schema_converter.g.dart';



@JsonSerializable(explicitToJson: true)
class Back4AppSchema implements DataProviderSchema {
  final List<ServerSchemaClass> results;

  const Back4AppSchema({required this.results});

  // SchemaClass get role => SchemaClass(results['_Role']);

  factory Back4AppSchema.fromJson(Map<String, dynamic> json) =>
      _$Back4AppSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$Back4AppSchemaToJson(this);

  void addClass(ServerSchemaClass schemaClass) {
    results.add(schemaClass);
  }

  /// Obtain a copy of results optionally excluding '_User' and '_Role',
  /// mapped by element className
  Map<String, ServerSchemaClass> extract(
      {bool excludeUser = true, bool excludeRole = true}) {
    final List<ServerSchemaClass> trimmedList = results
        .where((element) =>
            element.className != '_User' && element.className != '_Role')
        .toList();
    final Map<String, ServerSchemaClass> mapped = {};
    for (var element in trimmedList) {
      mapped[element.className] = element;
    }
    return mapped;
  }
}

@JsonSerializable(explicitToJson: true)
class ServerSchemaClass {
  final String className;
  final Map<String, ServerSchemaField> fields;
  @JsonKey(includeIfNull: false)
  final SchemaClassLevelPermissions? classLevelPermissions;
  @JsonKey(includeIfNull: false)
  final Map<String, dynamic>? indexes;

  const ServerSchemaClass(
      {required this.fields,
      required this.className,
      this.classLevelPermissions,
      this.indexes});

  factory ServerSchemaClass.fromJson(Map<String, dynamic> json) =>
      _$ServerSchemaClassFromJson(json);

  Map<String, dynamic> toJson() => _$ServerSchemaClassToJson(this);

  ServerSchemaClass.fromPrecept(PDocument doc)
      : className = doc.name,
        fields = convertFields(doc),
        classLevelPermissions = SchemaClassLevelPermissions.fromDocument(doc),
        indexes = null;

  static Map<String, ServerSchemaField> convertFields(PDocument doc) {
    Map<String, ServerSchemaField> fields = {};
    doc.fields.forEach((key, value) {
      switch (value.runtimeType) {
        case PPointer:
          fields[key] = ReferenceSchemaField(
            targetClass: (value as PPointer).targetClass,
            required: value.required,
            type: selectFieldType(value),
          );
          break;
        case PRelation:
          fields[key] = ReferenceSchemaField(
            targetClass: (value as PRelation).targetClass,
            required: value.required,
            type: selectFieldType(value),
          );
          break;
        default:
          fields[key] = ServerSchemaField(
            type: selectFieldType(value),
            required: value.required,
            defaultValue: value.defaultValue,
          );
          break;
      }
    });
    return fields;
  }

  static String selectFieldType(PField preceptField) {
    switch (preceptField.modelType) {
      case int:
        return 'Number';
      case String:
        return 'String';
      case DateTime:
        return 'Date';
      case JsonObject:
        return 'Object';
      case List:
        return 'Array';
      case GeoPoint:
        return 'GeoPoint';
      case GeoPolygon:
        return 'Polygon';
      case Pointer:
        return 'Pointer';
      case bool:
        return 'Boolean';
      case Relation:
        return 'Relation';
      case File:
        return 'File';
    }
    throw UnsupportedError(
        '${preceptField.modelType.toString()} is not supported');
  }

  void addField(PField pField) {}
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ServerSchemaField {
  final String type;
  final bool? required;
  final dynamic defaultValue;

  const ServerSchemaField(
      {required this.type, this.required, this.defaultValue});

  factory ServerSchemaField.fromJson(Map<String, dynamic> json) =>
      _$ServerSchemaFieldFromJson(json);

  Map<String, dynamic> toJson() => _$ServerSchemaFieldToJson(this);
}

/// A specific [ServerSchemaField] for use with fields which refer elsewhere, for example Pointers and Relations
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReferenceSchemaField extends ServerSchemaField {
  final String targetClass;

  ReferenceSchemaField({
    required this.targetClass,
    required bool required,
    required String type,
    dynamic defaultValue,
  }) : super(
          required: required,
          defaultValue: defaultValue,
          type: type,
        );

  factory ReferenceSchemaField.fromJson(Map<String, dynamic> json) =>
      _$ReferenceSchemaFieldFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ReferenceSchemaFieldToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SchemaClassLevelPermissions {
  final Map<String, dynamic> find;
  final Map<String, dynamic> get;
  final Map<String, dynamic> count;
  final Map<String, dynamic> create;
  final Map<String, dynamic> update;
  final Map<String, dynamic> delete;
  final Map<String, dynamic> addField;

  SchemaClassLevelPermissions.fromDocument(PDocument document)
      : get = buildPermissions(AccessMethod.get, document),
        find = buildPermissions(AccessMethod.find, document),
        count = buildPermissions(AccessMethod.count, document),
        create = buildPermissions(AccessMethod.create, document),
        update = buildPermissions(AccessMethod.update, document),
        delete = buildPermissions(AccessMethod.delete, document),
        addField = buildPermissions(AccessMethod.addField, document);

  const SchemaClassLevelPermissions({
    required this.find,
    required this.get,
    required this.count,
    required this.create,
    required this.update,
    required this.delete,
    required this.addField,
  });

  static Map<String, dynamic> buildPermissions(
      AccessMethod method, PDocument document) {
    final Map<String, dynamic> map = {};
    switch (method) {
      case AccessMethod.get:
        map['requiresAuthentication'] = (document.requiresGetAuthentication);
        _roleConstructor(map, document.permissions.getRoles);
        break;
      case AccessMethod.find:
        map['requiresAuthentication'] = (document.requiresFindAuthentication);
        _roleConstructor(map, document.permissions.findRoles);
        break;
      case AccessMethod.count:
        map['requiresAuthentication'] = (document.requiresCountAuthentication);
        _roleConstructor(map, document.permissions.countRoles);
        break;
      case AccessMethod.create:
        map['requiresAuthentication'] = (document.requiresCreateAuthentication);
        _roleConstructor(map, document.permissions.createRoles);
        break;
      case AccessMethod.update:
        map['requiresAuthentication'] = (document.requiresUpdateAuthentication);
        _roleConstructor(map, document.permissions.updateRoles);
        break;
      case AccessMethod.delete:
        map['requiresAuthentication'] = (document.requiresDeleteAuthentication);
        _roleConstructor(map, document.permissions.deleteRoles);
        break;
      case AccessMethod.addField:
        map['requiresAuthentication'] =
            (document.requiresAddFieldAuthentication);
        _roleConstructor(map, document.permissions.addFieldRoles);
        break;
      case AccessMethod.all:
      case AccessMethod.read:
      case AccessMethod.write:
        throw PreceptException(
            '\'$method\' is not appropriate in this context');
    }
    if (document.permissions.isPublic.contains(method)) {
      map['*'] = true;
    }
    return map;
  }

  static _roleConstructor(Map<String, dynamic> map, List<String> fromRoles) {
    for (var element in fromRoles) {
      map['role:$element'] = true;
    }
  }

  factory SchemaClassLevelPermissions.fromJson(Map<String, dynamic> json) =>
      _$SchemaClassLevelPermissionsFromJson(json);

  Map<String, dynamic> toJson() => _$SchemaClassLevelPermissionsToJson(this);
}

/// Observations on Class Level Permissions (not found in documentation, but deduced by experiment):
///
/// Each category only ever stores 'true' against a given permission.  For example:
/// - 'delete' may have 'requiresAuthentication->true'
/// - 'update' may have 'editor'->true if the editor role has permission to update
///
/// false values are not actually stored, they are just not there!
///
/// - '*' seems to equate to 'public'
///
/// It is possible to set both 'public' and 'authenticated' at the same time (in the console), which is odd
/// Don't know what the result of that would be - need to try it, but suspect 'public' would override other settings
// class SchemaClassLevelPermissions {
//   final Map<String, dynamic> data;
//
//   const SchemaClassLevelPermissions(this.data);
//
//   Map<String, dynamic> get find => data['find'];
//
//   Map<String, dynamic> get count => data['count'];
//
//   Map<String, dynamic> get get => data['get'];
//
//   Map<String, dynamic> get create => data['create'];
//
//   Map<String, dynamic> get update => data['update'];
//
//   Map<String, dynamic> get delete => data['delete'];
//
//   Map<String, dynamic> get addField => data['addField'];
//
// // protectedFields
// }

// @JsonSerializable(explicitToJson: true)
// class SchemaMethodPermissions {
//   SchemaMethodPermissions();
//
//   factory SchemaMethodPermissions.fromJson(Map<String, dynamic> json) =>
//       _$SchemaMethodPermissionsFromJson(json);
//
//   Map<String, dynamic> toJson() => _$SchemaMethodPermissionsToJson(this);
// }
