import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/preceptItem.dart';
import 'package:precept_script/data/provider/dataProviderBase.dart';
import 'package:precept_script/schema/field/queryResult.dart';
import 'package:precept_script/schema/json/jsonConverter.dart';

part 'schema.g.dart';

/// The root for a backend-agnostic definition of a data structure, including data types, validation, permissions
/// and relationships.
///
/// A [PSchema] is associated with a [PDataProviderBase] instance.  The [name] must be unique
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
@JsonSerializable( explicitToJson: true)
class PSchema extends PSchemaElement {
  final String name;
  final Map<String, PDocument> _documents;
  final Map<String, PQuerySchema> queries;

  PSchema(
      {Map<String, PDocument> documents = const {}, required this.name, this.queries = const {}})
      : _documents = documents;

  factory PSchema.fromJson(Map<String, dynamic> json) => _$PSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$PSchemaToJson(this);

  @JsonKey(ignore: true)
  PSchemaElement? get parent => null;
  Map<String, PDocument> get documents=> _documents;

  init() {
    doInit(parent: this, name: name);
  }

  @override
  doInit({required PSchemaElement parent,required String name}) {
    _name = name;
    for (var entry in _documents.entries) {
      final document = entry.value;
      document.doInit(parent: this, name: entry.key);
    }
  }

  PDocument document(String key) {
    final doc = _documents[key];
    if (doc == null) {
      String msg =
          "There is no schema listed for '$key', have you forgotten to add it to your PSchema?";
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    return doc;
  }

  int get documentCount => _documents.length;
}

abstract class PSchemaElement {
  @JsonKey(ignore: true)
  PSchemaElement? _parent;
  @JsonKey(ignore: true)
  String? _name;

  PSchemaElement();

  Map<String, dynamic> toJson();

  doInit({required PSchemaElement parent,required String name}) {
    _parent = parent;
    _name = name;
  }

  PSchemaElement? get parent => _parent;
}

/// If a CRUD action only requires that the user is authenticated, specify it in [requiresAuthentication].
///
/// If a CRUD action requires that the user has a specific role, specify that role in the appropriate
/// role list,  [readRoles], [updateRoles], [createRoles], [deleteRoles]
///
/// If a role is specified - for example in [readRoles] - there is no need to also specify 'read' in
/// [requiresAuthentication], provided you use [requiresReadAuthentication]
@JsonSerializable( explicitToJson: true)
class PPermissions {
  final List<RequiresAuth> _requiresAuthentication;
  final List<String> readRoles;
  final List<String> updateRoles;
  final List<String> createRoles;
  final List<String> deleteRoles;

  const PPermissions({
    List<RequiresAuth> requiresAuthentication = const [],
    this.readRoles = const [],
    this.updateRoles = const [],
    this.createRoles = const [],
    this.deleteRoles = const [],
  }) : _requiresAuthentication = requiresAuthentication;

  factory PPermissions.fromJson(Map<String, dynamic> json) => _$PPermissionsFromJson(json);

  Map<String, dynamic> toJson() => _$PPermissionsToJson(this);

  bool get requiresCreateAuthentication =>
      _requiresAuthentication.contains(RequiresAuth.all) ||
      _requiresAuthentication.contains(RequiresAuth.create) ||
      createRoles.isNotEmpty;

  bool get requiresReadAuthentication =>
      _requiresAuthentication.contains(RequiresAuth.all) ||
      _requiresAuthentication.contains(RequiresAuth.read) ||
      readRoles.isNotEmpty;

  bool get requiresUpdateAuthentication =>
      _requiresAuthentication.contains(RequiresAuth.all) ||
      _requiresAuthentication.contains(RequiresAuth.update) ||
      updateRoles.isNotEmpty;

  bool get requiresDeleteAuthentication =>
      _requiresAuthentication.contains(RequiresAuth.all) ||
      _requiresAuthentication.contains(RequiresAuth.delete) ||
      deleteRoles.isNotEmpty;
}

enum RequiresAuth { all, create, read, update, delete }

/// Schema for a 'Class' in Back4App, 'Document' in Firebase
@JsonSerializable( explicitToJson: true)
@PSchemaElementMapConverter()
class PDocument extends PSchemaElement {
  final PPermissions permissions;
  final Map<String, PSchemaElement> fields;

  PDocument({
    required this.fields,
    this.permissions = const PPermissions(),
  }) : super();

  String? get name => _name;

  @JsonKey(ignore: true)
  PSchemaElement? get parent => _parent;

  factory PDocument.fromJson(Map<String, dynamic> json) => _$PDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$PDocumentToJson(this);

  @override
  doInit({required PSchemaElement parent,required String name}) {
    _parent = parent;
    _name = name;
  }

  bool get requiresCreateAuthentication => permissions.requiresCreateAuthentication;

  bool get requiresReadAuthentication => permissions.requiresReadAuthentication;

  bool get requiresUpdateAuthentication => permissions.requiresUpdateAuthentication;

  bool get requiresDeleteAuthentication => permissions.requiresDeleteAuthentication;
}

/// Defines where to retrieve a schema from.  It references the *precept.json* file used to configure
/// the application.
///
/// [segment] relates to the first level within *precept.json*
/// [instance] relates to the second level within *precept.json*
@JsonSerializable( explicitToJson: true)
class PSchemaSource extends PreceptItem {
  final String segment;
  final String instance;

  PSchemaSource({
    required this.segment,
    required this.instance,
    String? id,
    int version = 0,
  }) : super(id: id, version: version);

  factory PSchemaSource.fromJson(Map<String, dynamic> json) => _$PSchemaSourceFromJson(json);

  Map<String, dynamic> toJson() => _$PSchemaSourceToJson(this);
}
