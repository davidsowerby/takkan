import 'package:json_annotation/json_annotation.dart';
import '../../schema/schema.dart';

part 'field_selector.g.dart';

/// Used to define the fields required from a GraphQL data-select
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
@JsonSerializable(explicitToJson: true)
class FieldSelector {

  const FieldSelector({
    this.fields = const [],
    this.allFields = false,
    this.includeMetaFields = false,
    this.metaFields = const ['createdAt', 'updatedAt'],
    this.excludeFields = const [],
  });

  factory FieldSelector.fromJson(Map<String, dynamic> json) =>
      _$FieldSelectorFromJson(json);
  final List<String> metaFields;
  final List<String> fields;
  final bool allFields;
  final bool includeMetaFields;
  final List<String> excludeFields;

  List<String> selection(Document schema) {
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
    // ignore: prefer_foreach
    for (final String field in excludeFields) {
      s.remove(field);
    }
    return s;
  }

  Map<String, dynamic> toJson() => _$FieldSelectorToJson(this);
}
