import 'package:equatable/equatable.dart';
import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/schema/field/field.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/script/version.dart';

/// Generate a diff between [previous] and [current].  If [previous] is null,
/// the diff represents the whole of [current]
///
/// The does rely on accurate configuration for [Equatable], so any errors
/// in setting up the  [Equatable.props] getters could cause an issue
SchemaDiff generateDiff2({Schema? previous, required Schema current}) {
  if (previous != null) {
    if (current.version.number == previous.version.number) {
      throw const TakkanException(
          'To create a diff, two different versions are required');
    }
    if (current.name != previous.name) {
      throw UnsupportedError('Schema name change is not supported');
    }
    if (current.version.number < previous.version.number) {
      throw const TakkanException(
          'Previous version must precede current version');
    }
  }

  /// replace null previous with 'empty' schema
  final p = (previous == null)
      ? Schema(
    name: current.name,
    version: const Version(number: -1),
  )
      : previous;
  return SchemaDiff(previous: p, current: current);
}

mixin Differ {
  /// This relies on the correct implementation of [Equatable.props]
  DiffNames<T> _identifyChanges<T extends Equatable>({
    required Map<String, T> previous,
    required Map<String, T> current,
  }) {
    final p = previous.keys.toSet();
    final c = current.keys.toSet();

    // find the document level changes first
    final deleted = p.difference(c);
    final added = c.difference(p);

    // candidate update entries are those which are in both the current set,
    // and the previous set.
    final candidateUpdates = p.intersection(c);

    // Now remove update candidates where they are the same in current and previous.
    // This relies on the use of Equatable
    candidateUpdates.removeWhere((name) => previous[name] == current[name]);

    return DiffNames<T>(
        created: added, deleted: deleted, updated: candidateUpdates);
  }
}

class DiffNames<T extends Equatable> {
  const DiffNames({
    required this.created,
    required this.deleted,
    required this.updated,
  });

  final Set<String> created;
  final Set<String> deleted;
  final Set<String> updated;
}

class DocumentDiff with Differ {
  DocumentDiff({
    required this.name,
    required this.previous,
    required this.current,
  }) {
    fieldNamesDiff = _identifyChanges<Field<dynamic>>(
        previous: previous.fields, current: current.fields);
  }

  final Document previous;
  final Document current;
  final String name;
  late DiffNames<Field<dynamic>> fieldNamesDiff;

  Map<String, Field<dynamic>> get create =>
      Map.fromEntries(current.fields.entries
          .where((entry) => fieldNamesDiff.created.contains(entry.key)));

  Map<String, Field<dynamic>> get delete =>
      Map.fromEntries(current.fields.entries
          .where((entry) => fieldNamesDiff.deleted.contains(entry.key)));

  Map<String, FieldChange> get update =>
      Map.fromEntries(current.fields.entries
          .where((entry) => fieldNamesDiff.updated.contains(entry.key))).map(
            (key, value) =>
            MapEntry<String, FieldChange>(
              key,
              FieldChange(
                  previous: previous.fields[key]!,
                  current: current.fields[key]!),
            ),
      );

  /// Supports schema generation, as that does not process field updates
  bool get fieldUpdatesOnly => create.isEmpty && delete.isEmpty;
}

class FieldChange {
  const FieldChange({required this.previous, required this.current});

  final Field<dynamic> previous;
  final Field<dynamic> current;
}

class SchemaDiff with Differ {
  SchemaDiff({
    required this.previous,
    required this.current,
  }) {
    /// Removing User and Role is a temporary fix until all the necessary
    /// data types have been covered see https://gitlab.com/takkan/takkan_design/-/issues/34
    /// Certainly need pointers and relations
    final p = Map<String, Document>.from(previous.documents);
    p.remove('User');
    p.remove('Role');
    final c = Map<String, Document>.from(current.documents);
    c.remove('User');
    c.remove('Role');

    documentNamesDiff = _identifyChanges<Document>(previous: p, current: c);
  }

  final Schema previous;
  final Schema current;
  late DiffNames<Document> documentNamesDiff;

  Map<String, Document> get create =>
      Map.fromEntries(current.documents.entries
          .where((entry) => documentNamesDiff.created.contains(entry.key)));

  Map<String, Document> get delete =>
      Map.fromEntries(current.documents.entries
          .where((entry) => documentNamesDiff.deleted.contains(entry.key)));

  Map<String, DocumentDiff> get update =>
      Map.fromEntries(current.documents.entries
          .where((entry) => documentNamesDiff.updated.contains(entry.key))).map(
            (key, value) =>
            MapEntry<String, DocumentDiff>(
              key,
              DocumentDiff(
                  previous: previous.documents[key]!,
                  current: current.documents[key]!,
                  name: key),
            ),
      );
}

class DocumentChange {
  const DocumentChange({required this.previous, required this.current});

  final Document previous;
  final Document current;
}
