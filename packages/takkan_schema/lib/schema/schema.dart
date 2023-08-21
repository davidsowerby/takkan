// ignore_for_file: must_be_immutable
/// See comments on [TakkanElement]
import 'package:json_annotation/json_annotation.dart';

import '../common/constants.dart';
import '../common/exception.dart';
import '../common/log.dart';
import '../common/version.dart';
import '../takkan/takkan_element.dart';
import '../util/walker.dart';
import 'common/diff.dart';
import 'common/schema_element.dart';
import 'document/document.dart';
import 'field/field.dart';

part 'schema.g.dart';

/// A [SchemaSet] represents a set of [Schema] versions, and is primarily used
/// to support version control.  It is therefore not expected generally to be
/// used in a client application, unless the client needs to support multiple
/// versions
///
/// A [SchemaSet] is defined by a [baseVersion] with 0 or more [diffs] defining
/// subsequent versions.  All versions have a version index which must increment
/// by at least 1 for each new version.  See [Version] for more detail.
///
/// Each version has a [VersionStatus], which is used to inform both server
/// code and the client.  The status of a version can be changed by
/// [changeVersionStatus]. Takkan does not by default impose any rules on how
/// transitions from one status to another can be made.  You can change this by
/// passing your own implementation of [VersionStatusChangeRules] to specify your
/// own lifecycle
///
/// During [init] the [baseVersion] is initialised, and versions created (expanded)
/// for all [diffs] except those that have [VersionStatus.excluded].
///
/// [activeDiffs] returns only diffs which are not [VersionStatus.excluded]
///
/// [changeBaseVersion] changes the base version.
@JsonSerializable(explicitToJson: true)
class SchemaSet {
  SchemaSet({
    required this.baseVersion,
    List<SchemaDiff>? diffs,
    required this.schemaName,
    VersionStatusChangeRules? statusRules,
  })  : _diffs = diffs ?? [],
        statusRules = statusRules ?? const DefaultVersionStatusChangeRules();

  factory SchemaSet.fromJson(Map<String, dynamic> json) =>
      _$SchemaSetFromJson(json);
  Schema baseVersion;
  final List<SchemaDiff> _diffs;
  final String schemaName;
  final Map<int, Schema> _schemaVersions = <int, Schema>{};
  final VersionStatusChangeRules statusRules;

  /// Expands and creates all versions from [baseVersion] plus [diffs]
  /// The [baseVersion] is also the first version
  /// Initialises the [baseVersion]
  void init() {
    baseVersion.init(schemaName: schemaName);
    _expandVersions();
  }

  /// Return only those [Schema] instances where its status is
  /// [VersionStatusExtension.active]
  Set<Schema> get activeSchemas => _schemaVersions.values
      .where((element) => element.status.isActive)
      .toSet();

  /// Return only those [SchemaDiff] instances where its status is
  /// [VersionStatusExtension.active]
  Set<SchemaDiff> get activeDiffs =>
      _diffs.where((element) => element.status.isActive).toSet();

  /// If you want only those versions which have not been removed, use
  /// [validSchemaVersions]
  Map<int, Schema> get schemaVersions => Map.from(_schemaVersions);

  /// Returns only those versions which are not [VersionStatus.excluded]
  /// If you want all versions, use [schemaVersions]
  ///
  /// This relies on the versions being built from [validDiffs], using
  /// [_expandVersions], and access must therefore be preceded by a call to [init]
  Map<int, Schema> get validSchemaVersions {
    final result = Map<int, Schema>.from(_schemaVersions);
    result.removeWhere((key, value) => value.status == VersionStatus.excluded);
    return result;
  }

  /// Returns all diffs regardless of [VersionStatus]
  List<SchemaDiff> get diffs => List.from(_diffs);

  /// Returns all diffs except those that are [VersionStatus.excluded]
  List<SchemaDiff> get validDiffs =>
      _diffs.where((element) => element.status.isValid).toList();

  /// Expands the diffs and populates [_schemaVersions].  [validDiffs] are applied in
  /// turn to the [baseVersion], producing a new, full [Schema] instance at
  /// each version.  These instances are available at [schemaVersions]
  void _expandVersions() {
    diffs.sort((a, b) => a.versionIndex.compareTo(b.versionIndex));
    Schema latestSoFar = baseVersion;
    _schemaVersions[baseVersion.versionIndex] = baseVersion;

    // Step through valid diffs and apply to base version of schema, thus producing
    // a new version.  New version is added to _versions.
    for (final SchemaDiff diff in validDiffs) {
      final nextVersionOfSchema = diff.applyTo(latestSoFar);
      nextVersionOfSchema.init(schemaName: schemaName);
      _schemaVersions[nextVersionOfSchema.versionIndex] = nextVersionOfSchema;
      latestSoFar = nextVersionOfSchema;
    }
  }

  Map<String, dynamic> toJson() => _$SchemaSetToJson(this);

  /// This relies on the versions being built from [validDiffs], using
  /// [_expandVersions], and must therefore/ be preceded by a call to [init]
  Schema schemaVersion(int versionIndex) {
    final v = _schemaVersions[versionIndex];
    if (v == null) {
      throw TakkanException('Schema version $versionIndex not found');
    }
    return v;
  }

  SchemaDiff diffVersion(int versionIndex) {
    final diff =
        diffs.firstWhere((element) => element.versionIndex == versionIndex);
    if (diff == null) {
      throw TakkanException('SchemaDiff version $versionIndex not found');
    }
    return diff;
  }

  /// This relies on the versions being built from [diffs], using [_expandVersions],
  /// and must therefore/ be preceded by a call to [init]
  bool containsSchemaVersion(int versionIndex) {
    return _schemaVersions.containsKey(versionIndex);
  }

  bool containsDiffVersion(int versionIndex) {
    return diffs.any((element) => element.versionIndex == versionIndex);
  }

  /// Make a change to the status of the version identified by its [versionIndex].
  /// A change is only made if the [statusRules] are met.
  ///
  /// The change is applied to [schemaVersions] and [diffs], except when the
  /// change is applied to the [baseVersion] as there will be no diff for that.
  void changeVersionStatus(int versionIndex, VersionStatus newStatus) {
    // This will throw an exception if versionIndex not valid
    final versionToChange = schemaVersion(versionIndex);
    final currentStatus = versionToChange.status;

    if (currentStatus == newStatus) {
      logType(runtimeType).i(
          'Version at index $versionIndex is already at $newStatus, no change made');
      return;
    }

    final isBaseVersion = versionIndex == baseVersion.versionIndex;
    // Check the rules.  Rules may also throw an exception
    final ruleCheck=statusRules.checkRules(currentStatus: currentStatus, newStatus: newStatus, isBaseVersion: isBaseVersion);

    // Do nothing if we failed to pass the rules
    if (!ruleCheck){
      return;
    }
    // if we are moved to released state and we want to maintain a unique release,
    // we need to deprecate currently released version, if there is one. Do
    // before changing to newStatus, so we don't forget which is which
    if (newStatus==VersionStatus.released){
      if (statusRules.maintainUniqueReleasedVersion){
        // We will check for more than one just in case the rule has changed
        final currentlyReleased=schemaVersions.values.where((element) => element.status==VersionStatus.released);
        for (final v in currentlyReleased){
          changeVersionStatus(v.versionIndex, VersionStatus.deprecated);
        }
      }
    }
    // apply the version change
    _doChangeVersionStatus(versionToChange, newStatus);
  }

  void _doChangeVersionStatus(Schema versionToChange, VersionStatus newStatus) {
    // create a new version instance with new status
    final newVersionInstance = versionToChange.version.withStatus(newStatus);

    // change status in Schema
    versionToChange.version = newVersionInstance;
    final int versionIndex = versionToChange.versionIndex;
    // change diff as well, if there is one (only time there would not be is if
    // we are changing the base version)
    if (versionIndex != baseVersion.versionIndex) {
      final diff =
          diffs.firstWhere((element) => element.versionIndex == versionIndex);
      if (diff == null) {
        // This should not happen - diffs should not have been be removed unless
        // expanded schema is removed as well
        throw TakkanException('There is no SchemaDiff for $versionIndex');
      }
      diff.version = newVersionInstance;
    }
  }

  /// throws TakkanException if the version requested is the base version;
  void _checkNotBaseVersion(int versionIndex, String action, String reason) {
    if (versionIndex == baseVersion.versionIndex) {
      throw TakkanException('Cannot $action base version $reason');
    }
  }

  /// Adds a new version by specifying it as a[SchemaDiff].  Its status is
  /// determined by the [SchemaDiff.version].  If the [Version.versionIndex]] already
  /// exists, a TakkanException is thrown.
  ///
  /// The versionIndex of [diff] must be greater than any existing versionIndex,
  /// but does not need to be contiguous.
  ///
  /// The newly added entry in [diffs] is expanded into [_schemaVersions]
  void addVersion(SchemaDiff diff) {
    // Reject if the versionIndex of diff is not greater than those already in diffs
    if (diffs.any((element) => element.versionIndex >= diff.versionIndex)) {
      throw const TakkanException(
          'An added version must have a versionIndex greater than any existing '
          'versionIndex');
    }
    _diffs.add(diff);
    _schemaVersions.clear();
    _expandVersions();
  }

  /// Changes the current base version to the specified [versionIndex]. All
  /// versions prior to this have their status set to [VersionStatus.expired]
  /// unless they have been previously [VersionStatus.excluded].
  void changeBaseVersion(int versionIndex) {
    _checkNotBaseVersion(
        versionIndex, 'change base ', ' as base already at $versionIndex');
    final oldBaseIndex = baseVersion.versionIndex;
    final newBase = schemaVersion(versionIndex);
    // expire all versions prior to this new base version
    for (int i = oldBaseIndex; i < versionIndex; i++) {
      if (containsSchemaVersion(i)) {
        if (schemaVersion(i).status != VersionStatus.excluded) {
          changeVersionStatus(i, VersionStatus.expired);
        }
      }
    }
    baseVersion = newBase;
  }
}

@JsonSerializable(explicitToJson: true)
class SchemaDiff with DiffUpdate implements Diff<Schema> {
  SchemaDiff({
    this.addDocuments = const {},
    this.removeDocuments = const [],
    this.amendDocuments = const {},
    this.readOnly,
    required this.version,
  });

  factory SchemaDiff.fromJson(Map<String, dynamic> json) =>
      _$SchemaDiffFromJson(json);
  final Map<String, Document> addDocuments;
  final List<String> removeDocuments;
  final Map<String, DocumentDiff> amendDocuments;
  Version version;
  final bool? readOnly;

  VersionStatus get status => version.status;

  Map<String, dynamic> toJson() => _$SchemaDiffToJson(this);

  /// Returns a new [Schema] instance with this [SchemaDiff] applied.
  ///
  /// Changes are applied in this order:
  ///  - amend
  ///  - remove
  ///  - add
  ///
  /// This means that it is possible, with a poorly defined [diff], to remove a
  /// document and add it back in, or to amend a document and then remove it,
  /// all within one [diff].
  @override
  Schema applyTo(Schema base) {
    return Schema(
      readOnly: readOnly ?? base.readOnly,
      version: version,
      documents: _updatedDocuments(base),
    );
  }

  Map<String, Document> _updatedDocuments(Schema base) {
    return updateSubElements(
      baseSubElements: base.documents,
      amendSubElements: amendDocuments,
      removeSubElements: removeDocuments,
      addSubElements: addDocuments,
    );
  }

  int get versionIndex => version.versionIndex;
}

/// [Schema] is a definition of a data structure, including data types, validation,
/// permissions and relationships.  It provides a common definition for use by
/// the client and server side code.
///
/// The [name] is provided by the parent [SchemaSet] during the [init] call, and
/// must be unique within the scope of an application, but has no other constraint.
///
/// The terminology used reflects the intention to keep this backend-agnostic,
/// although there may be cases where a backend does not support a particular
/// data type.
///
/// How these translate to the structure in the backend will depend on the
/// backend itself, and the user's preferences.
///
///
/// - In [documents], the map key is the document name.  This is, for example, a
/// Back4App Class or a Firestore collection, as determined by the backend
/// implementation.  During the init() process, the name of the [Document] is set
/// to match the key
///
/// A [Schema] also forms part of a [SchemaSet] to provide support for multiple
/// [Schema] versions
///
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Schema extends SchemaElement {
  Schema({
    Map<String, Document> documents = const {},
    bool readOnly = false,
    required this.version,
  })  : _documents = Map.from(documents),
        super(isReadOnly: readOnly ? IsReadOnly.yes : IsReadOnly.no);

  factory Schema.fromJson(Map<String, dynamic> json) => _$SchemaFromJson(json);
  static const String supportedVersions = 'supportedSchemaVersions';
  static const String documentClassName = 'TakkanSchema';
  final Map<String, Document> _documents;
  Version version;

  @override
  Map<String, dynamic> toJson() => _$SchemaToJson(this);

  VersionStatus get status => version.status;

  int get versionIndex => version.versionIndex;

  @override
  bool get hasParent => false;

  @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  List<Object?> get props => [
        ...super.props,
        version,
        _documents,
      ];

  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  SchemaElement get parent => NullSchemaElement();

  Map<String, Document> get documents => _documents;

  @override
  List<Object> get subElements => [_documents];

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
        'email': Field<String>(),
        'username': Field<String>(),
        'emailVerified': Field<bool>(),
      });

  // TODO: needs other fields https://gitlab.com/takkan/takkan_script/-/issues/51
  // Note: ACL would only be used by schema generator, see https://gitlab.com/takkan/takkan_script/-/issues/50
  Document get defaultRoleDocument =>
      Document(fields: {'name': Field<String>()});

  void init({required String schemaName}) {
    final parentWalker = SetParentWalker();
    final parentParams = SetParentWalkerParams(
      parent: NullSchemaElement(),
    );
    parentWalker.walk(this, parentParams);

    final initWalker = InitWalker();
    final params = InitWalkerParams(
      useCaptionsAsIds: false,
      name: schemaName,
    );
    initWalker.walk(this, params);
  }
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

class NullSchemaElement extends SchemaElement {
  NullSchemaElement() : super();

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}

abstract class TakkanSchemaLoader {
  Future<Schema> load(SchemaSource source);
}
