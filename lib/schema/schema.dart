import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/schema/json/jsonConverter.dart';

part 'schema.g.dart';

/// This is how I would like to create a schema, but it does not play well with the [PreceptModel]
/// There needs to be a code generation step between this and [Schema] but that does not look possible using the standard Dart build_runner.
/// The problem is referencing an instance of this class from within the code generator

/// The root for a backend-agnostic definition of a data structure, including data types, validation
/// and relationships.
///
/// This is just a definition, which is used by Precept, and may or may not be used to create a backend schema.
/// If it is used that way, the interpretation of it is a matter for each [SchemaInterpreter} implementation.
///
///
/// The terminology used reflects the intention to keep this backend-agnostic - see:
///
/// How these translate to the structure in the backend will depend on the backend itself, and the user's
/// preferences.
///
/// Each level will contain [Hints], which can be used to guide a [SchemaInterpreter} implementation.
///
///
/// - In [documents], the map key is the document property / name.  For a top level document,
/// this may be interpreted as something like a Parse Server Class or a Firestore collection,
/// as determined by the `BackendDelegate` implementation. For a nested, sub-document, it is treated
/// as a property name within the parent document.
///
/// - The [name] must be unique for all schemas in an app, but has no other constraint.
///
@JsonSerializable(nullable: true, explicitToJson: true)
class PSchema extends PSchemaElement {
  final String name;
  final Map<String, PDocument> documents;

  PSchema({@required this.documents, @required this.name}) ;

  factory PSchema.fromJson(Map<String, dynamic> json) => _$PSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$PSchemaToJson(this);

  PSchemaElement get parent => null;

  init() {
    doInit(parent: this, name:name);
  }

  @override
  doInit({PSchemaElement parent, String name}) {
    _name=name;
    for (var entry in documents.entries) {
      final document = entry.value;
      document.doInit(parent: this, name: entry.key);
    }
  }
}

abstract class PSchemaElement {
  final Permissions permissions;

  @JsonKey(ignore: true)
  PSchemaElement _parent;
  @JsonKey(ignore: true)
  String _name;

  PSchemaElement({this.permissions});

  Map<String, dynamic> toJson();

  doInit({PSchemaElement parent, String name}){
    _parent=parent;
    _name=name;
  }

  PSchemaElement get parent => _parent;
}

@JsonSerializable(nullable: true, explicitToJson: true)
class Permissions  {

  final Map<String,String> readRoles;
  final Map<String,String> writeRoles;


  Permissions(Map<String,String> readRoles, Map<String,String> writeRoles) : readRoles= readRoles ?? Map(), writeRoles = writeRoles ?? writeRoles;

  factory Permissions.fromJson(Map<String, dynamic> json) =>
      _$PermissionsFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionsToJson(this);
}

/// - [readRequiresAuthentication] can be set to true if a user needs only to be authenticated to read this document.  
/// Does not need to be set if [permissions.readRoles] has at least one entry, as [readRequiresAuth] takes account of roles
/// - [writeRequiresAuthentication] can be set to true if a user needs only to be authenticated to write this document
/// Does not need to be set if [permissions.writeRoles] has at least one entry, as [writeRequiresAuth] takes account of roles
/// 
@JsonSerializable(nullable: true, explicitToJson: true)
@PSchemaElementMapConverter()
class PDocument extends PSchemaElement {

  final Map<String, PSchemaElement> fields;
  final bool readRequiresAuthentication;
  final bool writeRequiresAuthentication;

  PDocument({@required this.fields, Permissions permissions, this.readRequiresAuthentication=false, this.writeRequiresAuthentication=false}) : super(permissions:permissions);

  String get name => _name;

  PSchemaElement get parent => _parent;

  factory PDocument.fromJson(Map<String, dynamic> json) => _$PDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$PDocumentToJson(this);

  @override
  doInit({PSchemaElement parent, String name}) {
    _parent = parent;
    _name=name;
  }
  
  bool get readRequiresAuth => readRequiresAuthentication || (permissions !=null && permissions.readRoles.isNotEmpty);
  bool get writeRequiresAuth => writeRequiresAuthentication || (permissions !=null && permissions.writeRoles.isNotEmpty);
}
