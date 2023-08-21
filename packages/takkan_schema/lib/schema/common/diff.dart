import 'package:takkan_schema/schema/common/schema_element.dart';

import '../schema.dart';

mixin DiffUpdate {
  Map<String, T> updateSubElements<T extends SchemaElement>({
    required Map<String, T> baseSubElements,
    required List<String> removeSubElements,
    required Map<String, Diff<T>> amendSubElements,
    required Map<String, T> addSubElements,
  }) {
    final Map<String, T> updatedSubElements = Map.from(baseSubElements);
    // amend
    for (final String subElementName in amendSubElements.keys) {
      final originalSubElement = baseSubElements[subElementName]!;
      final diff = amendSubElements[subElementName]!;
      updatedSubElements[subElementName] = diff.applyTo(originalSubElement);
    }

    // remove
    for (final String docName in removeSubElements) {
      updatedSubElements.remove(docName);
    }

    //add
    updatedSubElements.addAll(addSubElements);
    return updatedSubElements;
  }
}

abstract class Diff<T extends SchemaElement> {
  T applyTo(T base);
}
