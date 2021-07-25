import 'package:precept_script/schema/schema.dart';

/// Used to define the fields required from a GraphQL query
///
/// [fields] are the document fields, excluding meta fields.  Setting [allFields]
/// to true extracts the document fields from the [schema].  Setting [allFields]
/// with [excludeFields] is an alternative way to specify when most but not all
/// fields are required.  You can specify [metaFields] in [excludeFields].
///
/// If [allFields] is true, [fields] is ignored.
///
/// [metaFields] are backend specific.  This default implementation supplies
/// defaults for Back4App.  If using a different provider, you may need to sub class
/// this, or provide other [metaFields] on construction
class FieldSelector {
  final List<String> metaFields;
  final List<String> fields;
  final bool allFields;
  final bool includeMetaFields;
  final List<String> excludeFields;

  const FieldSelector({
    this.fields = const ['objectId'],
    this.allFields = false,
    this.includeMetaFields = false,
    this.metaFields = const ['createdAt', 'updatedAt'],
    this.excludeFields = const [],
  });

  List<String> selection(PDocument schema) {
    final List<String> s = List.empty(growable: true);
    if (allFields) {
      s.addAll(schema.fields.keys);
      s.add('objectId');
    } else {
      s.addAll(fields);
    }
    if (includeMetaFields) {
      s.addAll(metaFields);
    }
    for (String field in excludeFields) {
      s.remove(field);
    }
    return s;
  }
}
