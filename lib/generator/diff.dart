import 'dart:convert';

import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/schema/field/field.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/validation/validate.dart';

/// Creates a diff between 2 versions of a Schema
///
///
SchemaDiff generateDiff({Schema? previous, required Schema current}) {
  if (previous != null) {
    if (current.version.number - previous.version.number == 0) {
      throw TakkanException(
          'To create a diff, two different versions are required');
    }
    if (current.version.number < previous.version.number) {
      throw TakkanException('Previous version must precede current version');
    }
  }

  final Map<String, Document> create = {};
  final Map<String, Document> delete = {};
  final Map<String, DocumentDiff> update = {};
  if (previous == null) {
    create.addAll(current.documents);
  } else {
    for (String doc in current.documents.keys) {
      if (!previous.documents.containsKey(doc)) {
        create[doc] = (current.documents[doc]!);
      } else {
        update[doc] = (diffDocument(
          previous: previous.documents[doc]!,
          current: current.documents[doc]!,
        ));
      }
    }
    for (String doc in previous.documents.keys) {
      if (!current.documents.containsKey(doc)) {
        delete[doc] = current.documents[doc]!;
      }
    }
  }
  return SchemaDiff(create: create, update: update, delete: delete);
}

/// Updating a field is actually just replacing old with new, except that changing field type is not
/// possible.  Trying to will throw a PreceptException
DocumentDiff diffDocument(
    {required Document previous, required Document current}) {
  final Map<String, Field> create = {};
  final Map<String, Field> delete = {};
  final Map<String, Field> update = {};

  for (String field in current.fields.keys) {
    final currentField = current.fields[field]!;
    if (!previous.fields.containsKey(field)) {
      create[field] = currentField;
    } else {
      final previousField = previous.fields[field]!;
      if (!fieldUnchanged(previous: previousField, current: currentField)) {
        update[field] = currentField;
      }
    }
  }
  for (String field in previous.fields.keys) {
    if (!current.fields.containsKey(field)) {
      delete[field] = current.fields[field]!;
    }
  }

  return DocumentDiff(
      name: current.name, create: create, update: update, delete: delete);
}

class DocumentDiff {
  final String name;
  final Map<String, Field> create;
  final Map<String, Field> delete;
  final Map<String, Field> update;

  const DocumentDiff({
    required this.name,
    required this.create,
    required this.delete,
    required this.update,
  });
}

class SchemaDiff {
  final Map<String, Document> create;
  final Map<String, DocumentDiff> update;
  final Map<String, Document> delete;

  const SchemaDiff({
    required this.create,
    required this.delete,
    required this.update,
  });
}

// final List<VAL> validations;
// final bool required;
// @JsonKey(includeIfNull: false)
// final MODEL? defaultValue;
bool fieldUnchanged({required Field previous, required Field current}) {
  if (current.modelType != previous.modelType) {
    throw TakkanException('A field data type cannot be changed');
  }
  if (previous.defaultValue != current.defaultValue) {
    return false;
  }
  if (previous.required != current.required) {
    return false;
  }
  if (previous.validations.length != current.validations.length) {
    return false;
  }
  final List<V> previousV = previous.validations as List<V>;
  final List<V> currentV = current.validations as List<V>;
  final List<String> previousJson =
      previousV.map((e) => json.encode(e.toJson())).toList();
  final List<String> currentJson =
      currentV.map((e) => json.encode(e.toJson())).toList();
  for (final s in previousJson) {
    if (!currentJson.contains(s)) {
      return false;
    }
  }
  for (final s in currentJson) {
    if (!previousJson.contains(s)) {
      return false;
    }
  }
  return true;
}
