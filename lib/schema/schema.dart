import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/common/script/preceptItem.dart';
import 'package:precept_script/data/provider/dataProvider.dart';
import 'package:precept_script/schema/field/field.dart';
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
@JsonSerializable(explicitToJson: true)
class PSchema extends PSchemaElement {
  final String name;
  final Map<String, PDocument> _documents;
  final Map<String, PQuerySchema> queries;

  PSchema(
      {Map<String, PDocument> documents = const {},
      bool readOnly = false,
      required this.name,
      this.queries = const {}})
      : _documents = documents,
        super(readOnly: (readOnly) ? IsReadOnly.yes : IsReadOnly.no);

  factory PSchema.fromJson(Map<String, dynamic> json) =>
      _$PSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$PSchemaToJson(this);

  @JsonKey(ignore: true)
  PSchemaElement? get parent => null;

  Map<String, PDocument> get documents => _documents;

  @JsonKey(ignore: true)
  IsReadOnly get isReadOnly => _isReadOnly;

  init() {
    doInit(parent: this, name: name);
  }

  @override
  doInit({required PSchemaElement parent, required String name}) {
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

/// By default [readOnly] is inherited from [parent], but can be set individually via the constructor
///
/// [_name] is not set directly, but through [init].  This is to simplify the declaration of schema elements, by allowing a map key to become the name of the schema element.
///
/// The declaration of elements then becomes something like:
///
/// PDocument(fields: {'title':PString()}), rather than:
/// PDocument(fields: [PString(name: 'title')])
///
/// which for longer declarations is a bit more readable
abstract class PSchemaElement {
  @JsonKey(ignore: true)
  PSchemaElement? _parent;
  @JsonKey(ignore: true)
  late String _name;

  final IsReadOnly _isReadOnly;

  PSchemaElement({IsReadOnly readOnly = IsReadOnly.inherited})
      : _isReadOnly = readOnly;

  Map<String, dynamic> toJson();

  /// see [PSchemaElement] for explanation of why name is set here
  doInit({required PSchemaElement parent, required String name}) {
    _parent = parent;
    _name = name;
  }

  @JsonKey(ignore: true)
  bool get readOnly => _readOnlyState() == IsReadOnly.yes;

  PSchemaElement? get parent => _parent;

  IsReadOnly _readOnlyState() {
    if (parent == null) {
      String msg = "'parent' must be set before invoking";
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    } else {
      return (_isReadOnly == IsReadOnly.inherited)
          ? parent!._isReadOnly
          : _isReadOnly;
    }
  }
}

/// Permissions were designed very much with Back4App in mind, so there is a
/// direct mapping between this class and Back4App Class Level Permissions.
///
/// If a CRUD action only requires that the user is authenticated, specify it in [requiresAuthentication].
///
/// If a CRUD action requires that the user has a specific role, specify that role in the appropriate
/// role list, for example [updateRoles], [createRoles], [deleteRoles].  A user with any of the specified roles
/// will have appropriate access.
///
/// If a role is specified - for example in [updateRoles] - there is no need to
/// also specify 'update' in [requiresAuthentication], provided you use
/// [requiresFindAuthentication]
///
/// Roles specified in [readRoles] are added to [getRoles], [findRoles] and [countRoles]
/// Roles specified in [writeRoles] are added to [createRoles],[updateRoles] and [deleteRoles]
///
/// If no authentication is required, simply leave all properties empty
///
///
@JsonSerializable(explicitToJson: true)
class PPermissions {
  final List<RequiresAuth> _requiresAuthentication;

  final List<String> readRoles;
  final List<String> writeRoles;

  final List<String> _getRoles;
  final List<String> _findRoles;
  final List<String> _countRoles;

  final List<String> _createRoles;
  final List<String> _updateRoles;
  final List<String> _deleteRoles;

  final List<String> addFieldRoles;

  const PPermissions({
    List<RequiresAuth> requiresAuthentication = const [],
    this.readRoles = const [],
    this.writeRoles = const [],
    List<String> updateRoles = const [],
    List<String> createRoles = const [],
    List<String> deleteRoles = const [],
    this.addFieldRoles = const [],
    List<String> getRoles = const [],
    List<String> findRoles = const [],
    List<String> countRoles = const [],
  })  : _requiresAuthentication = requiresAuthentication,
        _updateRoles = updateRoles,
        _createRoles = createRoles,
        _deleteRoles = deleteRoles,
        _getRoles = getRoles,
        _findRoles = findRoles,
        _countRoles = countRoles;

  List<String> get updateRoles {
    final list = List<String>.from(_updateRoles, growable: true);
    list.addAll(writeRoles);
    return list;
  }

  List<String> get createRoles {
    final list = List<String>.from(_createRoles, growable: true);
    list.addAll(writeRoles);
    return list;
  }

  List<String> get deleteRoles {
    final list = List<String>.from(_deleteRoles, growable: true);
    list.addAll(writeRoles);
    return list;
  }

  List<String> get getRoles {
    final list = List<String>.from(_getRoles, growable: true);
    list.addAll(readRoles);
    return list;
  }

  List<String> get findRoles {
    final list = List<String>.from(_findRoles, growable: true);
    list.addAll(readRoles);
    return list;
  }

  List<String> get countRoles {
    final list = List<String>.from(_countRoles, growable: true);
    list.addAll(readRoles);
    return list;
  }

  factory PPermissions.fromJson(Map<String, dynamic> json) =>
      _$PPermissionsFromJson(json);

  Map<String, dynamic> toJson() => _$PPermissionsToJson(this);

  bool get requiresGetAuthentication =>
      _requiresAuthentication.contains(RequiresAuth.all) ||
      _requiresAuthentication.contains(RequiresAuth.get) ||
      getRoles.isNotEmpty;

  bool get requiresFindAuthentication =>
      _requiresAuthentication.contains(RequiresAuth.all) ||
      _requiresAuthentication.contains(RequiresAuth.find) ||
      findRoles.isNotEmpty;

  bool get requiresCountAuthentication =>
      _requiresAuthentication.contains(RequiresAuth.all) ||
      _requiresAuthentication.contains(RequiresAuth.count) ||
      countRoles.isNotEmpty;

  bool get requiresCreateAuthentication =>
      _requiresAuthentication.contains(RequiresAuth.all) ||
      _requiresAuthentication.contains(RequiresAuth.create) ||
      createRoles.isNotEmpty;

  bool get requiresUpdateAuthentication =>
      _requiresAuthentication.contains(RequiresAuth.all) ||
      _requiresAuthentication.contains(RequiresAuth.update) ||
      updateRoles.isNotEmpty;

  bool get requiresDeleteAuthentication =>
      _requiresAuthentication.contains(RequiresAuth.all) ||
      _requiresAuthentication.contains(RequiresAuth.delete) ||
      deleteRoles.isNotEmpty;

  bool get requiresAddFieldAuthentication =>
      _requiresAuthentication.contains(RequiresAuth.all) ||
      _requiresAuthentication.contains(RequiresAuth.addField) ||
      addFieldRoles.isNotEmpty;
}

enum RequiresAuth {
  all,
  read,
  get,
  find,
  count,
  write,
  create,
  update,
  delete,
  addField
}

/// A [standard] document has no special attributes.
/// A [versioned] document has a simple integer version number, incremented each time
/// it is saved by the user.  This is separate from any auto-save functionality that may be added
/// later
///
/// Implementation of these rules is managed by [DataProvider]
enum PDocumentType { standard, versioned }

/// Schema for a 'Class' in Back4App, 'Document' in Firebase
@JsonSerializable(explicitToJson: true)
@PSchemaFieldMapConverter()
class PDocument extends PSchemaElement {
  final PPermissions permissions;
  final PDocumentType documentType;
  final Map<String, PField> fields;

  PDocument({
    required this.fields,
    this.documentType = PDocumentType.standard,
    this.permissions = const PPermissions(),
  }) : super();

  String get name => _name;

  @JsonKey(ignore: true)
  PSchemaElement? get parent => _parent;

  factory PDocument.fromJson(Map<String, dynamic> json) =>
      _$PDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$PDocumentToJson(this);

  @override
  doInit({required PSchemaElement parent, required String name}) {
    _parent = parent;
    _name = name;
  }

  bool get requiresCreateAuthentication =>
      permissions.requiresCreateAuthentication;

  bool get requiresFindAuthentication => permissions.requiresFindAuthentication;

  bool get requiresGetAuthentication => permissions.requiresGetAuthentication;

  bool get requiresCountAuthentication =>
      permissions.requiresCountAuthentication;

  bool get requiresUpdateAuthentication =>
      permissions.requiresUpdateAuthentication;

  bool get requiresDeleteAuthentication =>
      permissions.requiresDeleteAuthentication;

  bool get requiresAddFieldAuthentication =>
      permissions.requiresAddFieldAuthentication;
}

/// Defines where to retrieve a schema from.  It references the *precept.json* file used to configure
/// the application.
///
/// [segment] relates to the first level within *precept.json*
/// [instance] relates to the second level within *precept.json*
@JsonSerializable(explicitToJson: true)
class PSchemaSource extends PreceptItem {
  final String segment;
  final String instance;

  PSchemaSource({
    required this.segment,
    required this.instance,
    String? id,
    int version = 0,
  }) : super(id: id, version: version);

  factory PSchemaSource.fromJson(Map<String, dynamic> json) =>
      _$PSchemaSourceFromJson(json);

  Map<String, dynamic> toJson() => _$PSchemaSourceToJson(this);
}
