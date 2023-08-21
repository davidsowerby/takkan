// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../common/constants.dart';
import '../common/exception.dart';
import '../common/log.dart';
import '../common/version.dart';
import '../data/select/condition/condition.dart';
import '../takkan/takkan_element.dart';
import '../util/walker.dart';
import 'field/boolean.dart';
import 'field/field.dart';
import 'field/string.dart';
import 'json/json_converter.dart';
import 'query/query.dart';

part 'schema.g.dart';

/// A backend-agnostic definition of a data structure, including data types, validation, permissions
/// and relationships.
///
/// A [Schema] is associated with a [DataProvider] instance.  The [name] must be unique
/// within the scope of an application, but has no other constraint.
///
/// [Schema] provides a definition for use by Takkan, and is also be used to create a backend schema.
///
/// The terminology used reflects the intention to keep this backend-agnostic, although there may be cases where
/// a backend does not support a particular data type.
///
/// How these translate to the structure in the backend will depend on the backend itself, and the user's
/// preferences.
///
///
/// - In [documents], the map key is the document name.  This is, for example, a
/// Back4App Class or a Firestore collection, as determined by the backend implementation.
///
///
///
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Schema extends SchemaElement {
  Schema({
    Map<String, Document> documents = const {},
    bool readOnly = false,
    required this.name,
    required this.version,
  })  : _documents = Map.from(documents),
        super(isReadOnly: readOnly ? IsReadOnly.yes : IsReadOnly.no);

  factory Schema.fromJson(Map<String, dynamic> json) => _$SchemaFromJson(json);
  static const String supportedVersions = 'supportedSchemaVersions';
  static const String documentClassName = 'TakkanSchema';
  @override
  final String name;
  final Map<String, Document> _documents;
  final Version version;

  @override
  Map<String, dynamic> toJson() => _$SchemaToJson(this);

  @override
  bool get hasParent => false;

 @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  List<Object?> get props => [
        ...super.props,
        version,
        name,
        _documents,
      ];

  @override
 @JsonKey(includeToJson: false, includeFromJson: false)
  SchemaElement get parent => NullSchemaElement();

  Map<String, Document> get documents => _documents;

  @override
  List<Object> get subElements => [_documents];

  @override
  void doInit(InitWalkerParams params) {
    _name = name;
    super.doInit(params);
  }

  /// If 'User' or 'Role' [Document] instances are not defined by the developer,
  /// default definitions are added here, as they may be needed by the client.
  ///
  /// The default definitions are currently the same as the Back4App defaults,
  /// but that may change.
  @override
  void setDefaults() {
    if (!documents.containsKey('User')) {
      documents['User'] = defaultUserDocument;
    }
    if (!documents.containsKey('Role')) {
      documents['Role'] = defaultRoleDocument;
    }
  }

  @override
  void walk(List<ScriptVisitor> visitors) {
    super.walk(visitors);
    documents.forEach((key, value) {
      value.walk(visitors);
    });
  }

  Document document(String key) {
    final doc = _documents[key];
    if (doc == null) {
      final String msg =
          "There is no Document listed for '$key', have you forgotten to add it to your Schema?";
      logType(runtimeType).e(msg);
      throw TakkanException(msg);
    }
    return doc;
  }

  int get documentCount => _documents.length;

  Set<String> get allRoles {
    final counter = RoleVisitor();
    walk([counter]);
    return counter.roles;
  }

  // TODO: needs other fields https://gitlab.com/takkan/takkan_script/-/issues/51
  // Note: ACL would only be used by schema generator, see https://gitlab.com/takkan/takkan_script/-/issues/50
  Document get defaultUserDocument => Document(fields: {
        'email': FString(),
        'username': FString(),
        'emailVerified': FBoolean(),
      });

  // TODO: needs other fields https://gitlab.com/takkan/takkan_script/-/issues/51
  // Note: ACL would only be used by schema generator, see https://gitlab.com/takkan/takkan_script/-/issues/50
  Document get defaultRoleDocument => Document(fields: {'name': FString()});

  void init() {
    final parentWalker = SetParentWalker();
    final parentParams = SetParentWalkerParams(
      parent: NullSchemaElement(),
    );
    parentWalker.walk(this, parentParams);

    final initWalker = InitWalker();
    const params = InitWalkerParams(
      useCaptionsAsIds: false,
    );
    initWalker.walk(this, params);
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
abstract class SchemaElement extends TakkanElement {
  SchemaElement({this.isReadOnly = IsReadOnly.inherited});

  String? _name;

  final IsReadOnly isReadOnly;

  @override
  Map<String, dynamic> toJson();

  @override
  void doInit(InitWalkerParams params) {
    _name = params.name;
    super.doInit(params);
  }

 @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  List<Object?> get props => [...super.props, isReadOnly, _name];

 @JsonKey(includeToJson: false, includeFromJson: false)
  bool get readOnly => _readOnlyState() == IsReadOnly.yes;

  String get name => _name!;

  @override
 @JsonKey(includeToJson: false, includeFromJson: false)
  SchemaElement get parent => super.parent as SchemaElement;

  IsReadOnly _readOnlyState() {
    return (isReadOnly == IsReadOnly.inherited)
        ? parent.isReadOnly
        : isReadOnly;
  }

  @override
  String get idAlternative => name;
}

/// Permissions were designed very much with Back4App in mind, so there is a
/// direct mapping between this class and Back4App Class Level Permissions.
///
/// The default settings create a fully public [Document] (equivalent to a
/// Back4App Class)
///
/// If a CRUD action only requires that the user is authenticated, specify it
/// in [requiresAuthentication].
///
/// If a CRUD action requires that the user has a specific role, specify that
/// role in the appropriate role list, for example [updateRoles], [createRoles],
/// [deleteRoles].  A user with any of the specified roles will have appropriate
/// access.
///
/// If a role is specified - for example in [updateRoles] - there is no need to
/// also specify 'update' in [_requiresAuthentication], provided you use
/// [requiresFindAuthentication]
///
/// To simplify specification:
///
/// - Roles specified in [readRoles] are added to [getRoles], [findRoles] and
/// [countRoles]
/// - Roles specified in [writeRoles] are added to [createRoles],[updateRoles]
/// and [deleteRoles]
///
/// If no authentication is required, simply leave all properties empty.
///
/// A method can be explicitly defined as public by adding it to [isPublic], and
/// this will overrule any other settings
///
@JsonSerializable(explicitToJson: true)
class Permissions extends Equatable with WalkTarget {
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
  })  : _requiresAuthentication = requiresAuthentication,
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
    final list = List<String>.from(_updateRoles);
    list.addAll(writeRoles);
    return list;
  }

  List<String> get createRoles {
    final list = List<String>.from(_createRoles);
    list.addAll(writeRoles);
    return list;
  }

  List<String> get deleteRoles {
    final list = List<String>.from(_deleteRoles);
    list.addAll(writeRoles);
    return list;
  }

  List<String> get getRoles {
    final list = List<String>.from(_getRoles);
    list.addAll(readRoles);
    return list;
  }

  List<String> get findRoles {
    final list = List<String>.from(_findRoles);
    list.addAll(readRoles);
    return list;
  }

  List<String> get countRoles {
    final list = List<String>.from(_countRoles);
    list.addAll(readRoles);
    return list;
  }

  /// A list of all the roles used
  Set<String> get allRoles {
    final Set<String> list = {};
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

  @override
  List<Object?> get props => [
        createRoles,
        readRoles,
        deleteRoles,
        updateRoles,
        getRoles,
        findRoles,
        countRoles
      ];
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

/// This defines a schema for a 'Class' in Back4App
///
/// A [Document] definition is used by client to control what is displayed to the
/// user, limiting what is presented according to its [Permissions].
///
/// [fields] are used by the client, along with data bindings and conversion
/// to connect the presentation layer to the data layer.  [fields] also define
/// validation rules, which are used by the client, but also by the schema generator
/// to generate server side validation.  That way, even if your client-side validation
/// is hacked, server side validation will still be present.
///
/// [permissions] provide role based access control
///
/// [queries] relate to this specific document type (Back4App Class)
///
/// An ACL is used only be the schema generator but does need to be defined,
/// with appropriate default. https://gitlab.com/takkan/takkan_script/-/issues/50
@JsonSerializable(explicitToJson: true, includeIfNull: false)
@SchemaFieldMapConverter()
class Document extends SchemaElement {
  Document({
    required this.fields,
    this.documentType = DocumentType.standard,
    this.permissions = const Permissions(),
    this.queries = const {},
  });

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);

  final Map<String, Query> queries;

 @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  List<Object?> get props =>
      [...super.props, permissions, documentType, fields, queries];

  final Permissions permissions;
  final DocumentType documentType;
  final Map<String, Field<dynamic, Condition<dynamic>>> fields;

  bool get hasValidation {
    for (final Field f in fields.values) {
      if (f.hasValidation) {
        return true;
      }
    }
    return false;
  }

  @override
  Map<String, dynamic> toJson() => _$DocumentToJson(this);

  @override
  List<Object> get subElements => [fields, queries];

  @override
  void doInit(InitWalkerParams params) {
    super.doInit(params);
    _name = params.name;
  }

  Field<dynamic, Condition<dynamic>> field(String fieldName) {
    final f = fields[fieldName];
    if (f == null) {
      final f1 = reservedField(fieldName);
      if (f1 == null) {
        final String msg = 'Field $fieldName does not exist in document $name';
        logType(runtimeType).e(msg);
        throw TakkanException(msg);
      }
      return f1;
    }
    return f;
  }

  /// see https://gitlab.com/takkan/takkan_script/-/issues/45
  Field<dynamic, Condition<dynamic>>? reservedField(fieldName) {
    switch (fieldName) {
      case 'objectId':
        return FString(isReadOnly: IsReadOnly.yes);
    }
    return null;
  }

  Query query(String queryName) {
    final q = queries[queryName];
    if (q == null) {
      final String msg = 'Unknown query with name $queryName';
      logType(runtimeType).e(msg);
      throw TakkanException(msg);
    }
    return q;
  }

  C operator [](String fieldName) {
    final Field<dynamic, Condition<dynamic>>? f = fields[fieldName];
    if (f != null) {
      return C(fieldName);
    }
    final String msg = '$fieldName is not a valid field name';
    logType(runtimeType).e(msg);
    throw TakkanException(msg);
  }

  @override
  void walk(List<ScriptVisitor> visitors) {
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
class SchemaSource extends TakkanElement {
  SchemaSource({
    required this.group,
    required this.instance,
    super.id,
  });

  factory SchemaSource.fromJson(Map<String, dynamic> json) =>
      _$SchemaSourceFromJson(json);
  final String group;
  final String instance;

 @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  List<Object?> get props => [...super.props, group, instance];

  @override
  Map<String, dynamic> toJson() => _$SchemaSourceToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SchemaStatus {
  const SchemaStatus(
      {required this.activeVersion, required this.deprecatedVersions});

  factory SchemaStatus.fromJson(Map<String, dynamic> json) =>
      _$SchemaStatusFromJson(json);

  final int activeVersion;
  final List<int> deprecatedVersions;

  Map<String, dynamic> toJson() => _$SchemaStatusToJson(this);
}

class NullSchemaElement extends SchemaElement {
  NullSchemaElement() : super();

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}

abstract class TakkanSchemaLoader {
  Future<Schema> load(SchemaSource source);
}
