import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/data/select/expression.dart';
import 'package:takkan_script/script/common.dart';
import 'package:takkan_script/script/takkan_item.dart';
import 'package:takkan_script/util/visitor.dart';
import 'package:takkan_script/data/provider/data_provider.dart';
import 'package:takkan_script/page/page.dart';
import 'package:takkan_script/schema/field/field.dart';
import 'package:takkan_script/schema/json/json_converter.dart';
import 'package:takkan_script/script/version.dart';

part 'schema.g.dart';

/// The root for a backend-agnostic definition of a data structure, including data types, validation, permissions
/// and relationships.
///
/// A [Schema] is associated with a [DataProvider] instance.  The [name] must be unique
/// within a [Schema] instance, but has no other constraint.
///
/// [Schema] provides a definition for use by Takkan, but could also be used to create a backend schema.
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
/// - In [documents], the map key is the document name.  This is, for example, a
/// Back4App Class or a Firestore collection, as determined by the backend implementation.
///
/// - [namedQueries] is a place to put queries that may be used in different
/// places in the app without having to specify them every time.
///
///
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Schema extends SchemaElement {
  Schema({Map<String, Document> documents = const {},
    bool readOnly = false,
    required this.name,
    required this.version,
    this.namedQueries = const {}})
      : _documents = documents,
        super(readOnly: readOnly ? IsReadOnly.yes : IsReadOnly.no);

  factory Schema.fromJson(Map<String, dynamic> json) => _$SchemaFromJson(json);
  @override
  final String name;
  final Map<String, Document> _documents;
  final Map<String, Query> namedQueries;
  final Version version;

  @override
  Map<String, dynamic> toJson() => _$SchemaToJson(this);

  @override
  @JsonKey(ignore: true)
  SchemaElement get parent => NullSchemaElement();

  Map<String, Document> get documents => _documents;

  @JsonKey(ignore: true)
  IsReadOnly get isReadOnly => _isReadOnly;

  @override
  List<Object> get subElements => [_documents, namedQueries];

  @override
  doInit(InitWalkerParams params) {
    _name = name;
    super.doInit(params);
  }

  @override
  walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    documents.forEach((key, value) {
      value.walk(visitors);
    });
  }

  Document document(String key) {
    final doc = _documents[key];
    if (doc == null) {
      final String msg =
          "There is no schema listed for '$key', have you forgotten to add it to your PSchema?";
      logType(runtimeType).e(msg);
      throw TakkanException(msg);
    }
    return doc;
  }

  Query query(String documentName,List<Condition> Function(QueryBuilder) fConditions) {
    return QueryBuilder(document(documentName)).build(fConditions);
  }

  int get documentCount => _documents.length;

  Set<String> get allRoles {
    final counter = RoleVisitor();
    walk([counter]);
    return counter.roles;
  }
}

class QueryBuilder {

  QueryBuilder(this.document) ;

  final Document document;

  Query build(List<Condition> Function(QueryBuilder) fConditions) {
    final List<Condition> conditions = fConditions(this);
    return Query(document, conditions);
  }

  ConditionBuilder operator [](String fieldName) {
    final Field<dynamic, dynamic>? f = document.fields[fieldName];
    if (f != null) {
      return ConditionBuilder(document, fieldName, f);
    }
    final String msg = '$fieldName is not a valid field name';
    logType(runtimeType).e(msg);
    throw TakkanException(msg);
  }
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
abstract class SchemaElement extends TakkanItem {
  SchemaElement({IsReadOnly readOnly = IsReadOnly.inherited})
      : _isReadOnly = readOnly;
  String? _name;

  final IsReadOnly _isReadOnly;

  @override
  Map<String, dynamic> toJson();

  @override
  void doInit(InitWalkerParams params) {
    _name = params.name;
    super.doInit(params);
  }

  @JsonKey(ignore: true)
  bool get readOnly => _readOnlyState() == IsReadOnly.yes;

  String get name => _name!;

  @override
  @JsonKey(ignore: true)
  SchemaElement get parent => super.parent as SchemaElement;

  IsReadOnly _readOnlyState() {
    return (_isReadOnly == IsReadOnly.inherited)
        ? parent._isReadOnly
        : _isReadOnly;
  }

  @override
  String get idAlternative => name;
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
/// If no authentication is required, simply leave all properties empty.
///
/// A method can be explicitly defined as public by adding it to [isPublic], and this will overrule any other settings
///
///
@JsonSerializable(explicitToJson: true)
class Permissions with WalkTarget {
  const Permissions({
    this.isPublic = const [],
    List<AccessMethod> requiresAuthentication = const [],
    this.readRoles = const [],
    this.writeRoles = const [],
    List<String> updateRoles = const [],
    List<String> createRoles = const [],
    List<String> deleteRoles = const [],
    this.addFieldRoles = const [],
    List<String> getRoles = const [],
    List<String> findRoles = const [],
    List<String> countRoles = const [],
  })
      : _requiresAuthentication = requiresAuthentication,
        _updateRoles = updateRoles,
        _createRoles = createRoles,
        _deleteRoles = deleteRoles,
        _getRoles = getRoles,
        _findRoles = findRoles,
        _countRoles = countRoles;

  factory Permissions.fromJson(Map<String, dynamic> json) =>
      _$PermissionsFromJson(json);
  final List<AccessMethod> _requiresAuthentication;
  final List<AccessMethod> isPublic;

  final List<String> readRoles;
  final List<String> writeRoles;

  final List<String> _getRoles;
  final List<String> _findRoles;
  final List<String> _countRoles;

  final List<String> _createRoles;
  final List<String> _updateRoles;
  final List<String> _deleteRoles;

  final List<String> addFieldRoles;

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

  /// A list of all the roles used
  Set<String> get allRoles {
    final Set<String> list = Set();
    list.addAll(updateRoles);
    list.addAll(createRoles);
    list.addAll(deleteRoles);
    list.addAll(getRoles);
    list.addAll(findRoles);
    list.addAll(countRoles);
    return list;
  }

  Map<String, dynamic> toJson() => _$PermissionsToJson(this);

  bool get requiresGetAuthentication =>
      _requiresAuthentication.contains(AccessMethod.all) ||
          _requiresAuthentication.contains(AccessMethod.get) ||
          getRoles.isNotEmpty;

  bool get requiresFindAuthentication =>
      _requiresAuthentication.contains(AccessMethod.all) ||
          _requiresAuthentication.contains(AccessMethod.find) ||
          findRoles.isNotEmpty;

  bool get requiresCountAuthentication =>
      _requiresAuthentication.contains(AccessMethod.all) ||
          _requiresAuthentication.contains(AccessMethod.count) ||
          countRoles.isNotEmpty;

  bool get requiresCreateAuthentication =>
      _requiresAuthentication.contains(AccessMethod.all) ||
          _requiresAuthentication.contains(AccessMethod.create) ||
          createRoles.isNotEmpty;

  bool get requiresUpdateAuthentication =>
      _requiresAuthentication.contains(AccessMethod.all) ||
          _requiresAuthentication.contains(AccessMethod.update) ||
          updateRoles.isNotEmpty;

  bool get requiresDeleteAuthentication =>
      _requiresAuthentication.contains(AccessMethod.all) ||
          _requiresAuthentication.contains(AccessMethod.delete) ||
          deleteRoles.isNotEmpty;

  bool get requiresAddFieldAuthentication =>
      _requiresAuthentication.contains(AccessMethod.all) ||
          _requiresAuthentication.contains(AccessMethod.addField) ||
          addFieldRoles.isNotEmpty;

  bool methodIsPublic(AccessMethod method) {
    return isPublic.contains(method) || isPublic.contains(AccessMethod.all);
  }
}

enum AccessMethod {
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
enum DocumentType { standard, versioned }

/// Schema for a 'Class' in Back4App, 'Document' in Firebase
@JsonSerializable(explicitToJson: true, includeIfNull: false)
@SchemaFieldMapConverter()
class Document extends SchemaElement {
  Document({
    required this.fields,
    this.documentType = DocumentType.standard,
    this.permissions = const Permissions(),
  }) : super();

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);
  final Permissions permissions;
  final DocumentType documentType;
  final Map<String, Field> fields;

  @override
  Map<String, dynamic> toJson() => _$DocumentToJson(this);

  @override
  doInit(InitWalkerParams params) {
    super.doInit(params);
    _name = params.name!;
  }

  ConditionBuilder operator [](String fieldName) {
    final Field<dynamic, dynamic>? f = fields[fieldName];
    if (f != null) {
      return ConditionBuilder(this, fieldName, f);
    }
    final String msg = '$fieldName is not a valid field name';
    logType(runtimeType).e(msg);
    throw TakkanException(msg);
  }

  @override
  walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    permissions.walk(visitors);
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

  bool methodIsPublic(AccessMethod method) =>
      permissions.methodIsPublic(method);
}

/// Defines where to retrieve a schema from.  It references the *takkan.json* file used to configure
/// the application.
///
/// [group] relates to the first level within *takkan.json*
/// [instance] relates to the second level within *takkan.json*
@JsonSerializable(explicitToJson: true)
class SchemaSource extends TakkanItem {
  SchemaSource({
    required this.group,
    required this.instance,
    super.id,
  });

  factory SchemaSource.fromJson(Map<String, dynamic> json) =>
      _$SchemaSourceFromJson(json);
  final String group;
  final String instance;

  @override
  Map<String, dynamic> toJson() => _$SchemaSourceToJson(this);
}
