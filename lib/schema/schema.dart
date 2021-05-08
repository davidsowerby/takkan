import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/preceptItem.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/schema/field/queryResult.dart';
import 'package:precept_script/schema/json/jsonConverter.dart';

part 'schema.g.dart';

/// The root for a backend-agnostic definition of a data structure, including data types, validation, permissions
/// and relationships.
///
/// A [PSchema] is associated with a [PDataProvider] instance.  The [name] must be unique
/// within a [PSchema] instance, but has no other constraint.
///
/// [PSchema] provides a definition for use by Precept, but could also be used to create a backend schema.
/// If it is used that way, the interpretation of it is a matter for a SchemaInterpreter implementation
/// within the backend-specific library.
///
///
/// The terminology used reflects the intention to keep this backend-agnostic, although there may be cases where
/// a backend does not support a particular data type.
///
/// How these translate to the structure in the backend will depend on the backend itself, and the user's
/// preferences.
///
/// Each level will contain [Hints], which can be used to guide a [SchemaInterpreter} implementation.
///
///
/// - In [documents], the map key is the document property / name.  For a top level document,
/// this may be interpreted as something like a Parse Server Class or a Firestore collection,
/// as determined by the backend implementation. For a nested, sub-document, it is treated
/// as a property name within the parent document.
///
/// - [queries] are instances of [ListSchema], but held separately, indexed by query name
///
///
@JsonSerializable(nullable: true, explicitToJson: true)
class PSchema extends PSchemaElement {
  final String name;
  final Map<String, PDocument> _documents;
  final Map<String, PQueryResult> queries;

  PSchema({@required Map<String, PDocument> documents, @required this.name, this.queries=const {}}):_documents=documents;

  factory PSchema.fromJson(Map<String, dynamic> json) => _$PSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$PSchemaToJson(this);

  @JsonKey(ignore: true)
  PSchemaElement get parent => null;

  init() {
    doInit(parent: this, name: name);
  }

  @override
  doInit({PSchemaElement parent, String name}) {
    _name = name;
    for (var entry in _documents.entries) {
      final document = entry.value;
      document.doInit(parent: this, name: entry.key);
    }
  }

  PDocument document(String key) {
    final doc = _documents[key];
    if (doc == null) {
      String msg = "There is no schema listed for '$key', have you forgotten to add it to your PSchema?";
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    return doc;
  }

  int get documentCount => _documents.length;
}

abstract class PSchemaElement {
  final PPermissions permissions;

  @JsonKey(ignore: true)
  PSchemaElement _parent;
  @JsonKey(ignore: true)
  String _name;

  PSchemaElement({this.permissions});

  Map<String, dynamic> toJson();

  doInit({PSchemaElement parent, String name}) {
    _parent = parent;
    _name = name;
  }

  PSchemaElement get parent => _parent;

}

@JsonSerializable(nullable: true, explicitToJson: true)
class PPermissions {
  final Map<String, String> readRoles;
  final Map<String, String> writeRoles;

  const PPermissions({this.readRoles=const {}, this.writeRoles=const {}});

  factory PPermissions.fromJson(Map<String, dynamic> json) => _$PPermissionsFromJson(json);

  Map<String, dynamic> toJson() => _$PPermissionsToJson(this);
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

  PDocument(
      {@required this.fields,
      PPermissions permissions,
      this.readRequiresAuthentication = false,
      this.writeRequiresAuthentication = false})
      : super(permissions: permissions);

  String get name => _name;

  PSchemaElement get parent => _parent;

  factory PDocument.fromJson(Map<String, dynamic> json) => _$PDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$PDocumentToJson(this);

  @override
  doInit({PSchemaElement parent, String name}) {
    _parent = parent;
    _name = name;
  }

  bool get readRequiresAuth =>
      readRequiresAuthentication || (permissions != null && permissions.readRoles.isNotEmpty);

  bool get writeRequiresAuth =>
      writeRequiresAuthentication || (permissions != null && permissions.writeRoles.isNotEmpty);
}

/// Defines where to retrieve a schema from.  It references the *precept.json* file used to configure
/// the application.
///
/// [segment] relates to the first level within *precept.json*
/// [instance] relates to the second level within *precept.json*
@JsonSerializable(nullable: true, explicitToJson: true)
class PSchemaSource extends PreceptItem {
  final String segment;
  final String instance;

  PSchemaSource({
    @required this.segment,
    @required this.instance,
    String id,
    int version = 0,
  }) : super(id: id, version: version);

  factory PSchemaSource.fromJson(Map<String, dynamic> json) => _$PSchemaSourceFromJson(json);

  Map<String, dynamic> toJson() => _$PSchemaSourceToJson(this);
}
