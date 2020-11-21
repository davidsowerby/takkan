import 'package:generator/src/annotation/annotation.dart';
import 'package:precept/precept/schema/schemaMap.dart';

part 'schema.g.dart';

@SchemaGen()
final schema2 = const SModel(components: {
  "core": SComponent(documents: const [SDocument()]),
});
