import 'package:json_annotation/json_annotation.dart';

import '../../common/constants.dart';
import '../../common/exception.dart';
import '../../common/log.dart';
import '../../data/select/condition/condition.dart';
import '../../util/walker.dart';
import '../common/diff.dart';
import '../common/schema_element.dart';
import '../field/field.dart';
import '../json/json_converter.dart';
import '../query/query.dart';
import '../schema.dart';
import 'permissions.dart';

part 'document.g.dart';

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
/// An ACL is used only by the schema generator but does need to be defined,
/// with appropriate default. https://gitlab.com/takkan/takkan_script/-/issues/50
@JsonSerializable(explicitToJson: true, includeIfNull: false)
@FieldMapConverter()
// ignore: must_be_immutable
class Document extends SchemaElement {
  Document({
    required this.fields,
    this.documentType = DocumentType.standard,
    Permissions? permissions,
    this.queries = const {},
  }) : permissions = permissions ?? Permissions();

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);

  final Map<String, Query> queries;

  @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  List<Object?> get props =>
      [...super.props, permissions, documentType, fields, queries];

  final Permissions permissions;
  final DocumentType documentType;
  final Map<String, Field<dynamic>> fields;

  bool get hasValidation {
    for (final Field<dynamic> f in fields.values) {
      if (f.hasValidation) {
        return true;
      }
    }
    return false;
  }

  @override
  Map<String, dynamic> toJson() => _$DocumentToJson(this);

  /// There is currently no need to include [permissions], as a [Permissions]
  /// object does not require initialisation.
  @override
  List<Object> get subElements => [fields, queries];

  Field<dynamic> field(String fieldName) {
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
  Field<dynamic>? reservedField(fieldName) {
    switch (fieldName) {
      case 'objectId':
        return Field<String>(isReadOnly: IsReadOnly.yes);
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

  Q operator [](String fieldName) {
    final Field<dynamic>? f = fields[fieldName];
    if (f != null) {
      return Q(fieldName);
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

  bool requiresAuthentication(AccessMethod method) {
    return permissions.requiresAuthentication(method);
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
  addField,
}

extension AccessMethodExtension on AccessMethod {
  static Set<AccessMethod> basicMethods = {
    AccessMethod.count,
    AccessMethod.create,
    AccessMethod.delete,
    AccessMethod.find,
    AccessMethod.get,
    AccessMethod.update,
    AccessMethod.addField,
  };
  static Set<AccessMethod> readMethods = {
    AccessMethod.count,
    AccessMethod.find,
    AccessMethod.get,
  };
  static Set<AccessMethod> writeMethods = {
    AccessMethod.create,
    AccessMethod.delete,
    AccessMethod.update,
    AccessMethod.addField,
  };

  bool get isBasicMethod => basicMethods.contains(this);

  bool get isNotBasicMethod => !isBasicMethod;

  Set<AccessMethod> get groupMembers {
    switch (this) {
      case AccessMethod.all:
        return AccessMethodExtension.basicMethods;
      case AccessMethod.read:
        return AccessMethodExtension.readMethods;
      case AccessMethod.write:
        return AccessMethodExtension.writeMethods;
      case AccessMethod.get:
      case AccessMethod.find:
      case AccessMethod.count:
      case AccessMethod.create:
      case AccessMethod.update:
      case AccessMethod.delete:
      case AccessMethod.addField:
        return {this};
    }
  }
}

class FieldMapConverter
    implements
        JsonConverter<Map<String, Field<dynamic>>, Map<String, dynamic>> {
  const FieldMapConverter();

  @override
  Map<String, Field<dynamic>> fromJson(Map<String, dynamic> json) {
    final Map<String, Field<dynamic>> outputMap = {};
    for (final entry in json.entries) {
      if (entry.key != jsonClassKey) {
        outputMap[entry.key] = const FieldConverter()
            .fromJson(entry.value as Map<String, dynamic>);
      }
    }
    return outputMap;
  }

  @override
  Map<String, dynamic> toJson(Map<String, Field<dynamic>> partMap) {
    final outputMap = <String, dynamic>{};
    for (final entry in partMap.entries) {
      outputMap[entry.key] = const FieldConverter().toJson(entry.value);
    }
    return outputMap;
  }
}

@JsonSerializable(explicitToJson: true)
@FieldMapConverter()
class DocumentDiff with DiffUpdate implements Diff<Document> {
  const DocumentDiff({
    this.addFields = const {},
    this.removeFields = const [],
    this.amendFields = const {},
    this.permissions,
    this.addQueries = const {},
    this.removeQueries = const [],
    this.amendQueries = const {},
  });

  factory DocumentDiff.fromJson(Map<String, dynamic> json) =>
      _$DocumentDiffFromJson(json);

  final PermissionsDiff? permissions;

  final Map<String, Query> addQueries;
  final Map<String, Field<dynamic>> addFields;
  final List<String> removeFields;
  final List<String> removeQueries;
  final Map<String, FieldDiff<dynamic>> amendFields;
  final Map<String, QueryDiff> amendQueries;

  Map<String, dynamic> toJson() => _$DocumentDiffToJson(this);

  /// Returns a new [Document] with the given [documentDiff] applied.
  ///
  /// Changes to fields are applied in this order:
  ///  - amend
  ///  - remove
  ///  - add
  ///
  /// This means that it is possible, with a poorly defined [base], to remove a
  /// field and add it back in, or to amend a field and then remove it,
  /// all within one [base].
  ///
  /// Changes to [permissions] are always amendments
  @override
  Document applyTo(Document base) {
    return Document(
      fields: _updatedFields(base),
      queries: _updatedQueries(base),
      permissions: (permissions == null)
          ? base.permissions
          : permissions!.applyTo(base.permissions),
    );
  }

  Map<String, Query> _updatedQueries(Document base) {
    return updateSubElements(
      baseSubElements: base.queries,
      removeSubElements: removeQueries,
      amendSubElements: amendQueries,
      addSubElements: addQueries,
    );
  }

  Map<String, Field<dynamic>> _updatedFields(Document base) {
    return updateSubElements(
      baseSubElements: base.fields,
      removeSubElements: removeFields,
      amendSubElements: amendFields,
      addSubElements: addFields,
    );
  }
}
