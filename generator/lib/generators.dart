import 'package:build/build.dart';
import 'package:generator/src/generator/schema_generator.dart';
import 'package:source_gen/source_gen.dart';


Builder schemaGeneratorBuilder(BuilderOptions options) =>
    SharedPartBuilder([SchemaGenerator()], 'schema');
