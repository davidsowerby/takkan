import 'dart:io';

import 'package:precept_back4app_client/backend/back4app/provider/data_provider.dart';
import 'package:precept_back4app_client/backend/back4app/provider/pback4app_data_provider.dart';
import 'package:precept_backend/backend/app/app_config.dart';
import 'package:precept_server_code_generator/generator/back4app/back4app_schema_generator.dart';
import 'package:precept_server_code_generator/generator/back4app/schema_converter.dart';


import 'package:precept_script/data/provider/data_provider.dart';
import 'package:precept_script/data/provider/delegate.dart';
import 'package:precept_script/schema/schema.dart';

/// It is expected that eventually this function will only be available in a
/// "Precept Developer" app or similar.  Some of the functionality it uses (for
/// example generating validation code) probably could (and maybe even should)
/// be server-side - but I much prefer writing Dart to Javascript!
///
/// Prepares the backend for the specific version of [pSchema].  This includes:
/// - generating / copying code for deployment using the [Back4App CLI](https://www.back4app.com/docs/platform/parse-cli),
/// - generating the server schema and passing to Back4App for storage and later release
/// - adding new roles
///
/// - The Back4App App is identified by [providerConfig], which is also used
/// to look up the necessary keys from *precept.json*
///
/// - The output directory is identified by a combination of [targetBaseDirectory]
/// and the instance identified by the [PConfigSource] in [providerConfig], and
/// must exist on your local workstation.  It must also be prepared as required
/// by the [Back4App CLI](https://www.back4app.com/docs/platform/parse-cli)
///
/// - Validation code is generated from the [pSchema], and placed in the
/// output directory.
///
/// - The [pSchema] is persisted in the ***PreceptSchema*** Class, and its version
/// number incremented by a code function. Some elements are generated from
/// the schema and persisted as additional attributes of ***PreceptSchema***, for
/// ease of selection. These are described below.
///
/// - All roles are extracted from the [pSchema] and persisted in the ***PreceptSchema***
/// entry. A code cloud function creates any new roles required as part of the
/// release mechanism.  Unused roles are NOT automatically deleted.
///
/// - code code (that is, the cloud functions required by Precept itself),
/// is generated or copied to the output directory.
///
/// - [pSchema] is used to generate a Back4App server schema.  This is
/// persisted in the ***ServerSchema*** class.  This is held separately because
/// a [PSchema] may change in a way which does not impact the server schema.
/// The server schema would then be released by an authorised user at a later date.
/// The release mechanism is one of the cloud code functions provided by the
/// code code.
///
/// - Your own cloud code should be placed in the output directory.
///
/// - All the code can then be deployed at the appropriate time, using the
/// *b4a deploy* command, probably in conjunction with releasing the server schema,
///
/// Returns the output directory.
// Future<Directory> deployToBack4App({
//   required AppConfig appConfig,
//   required PBack4AppDataProvider providerConfig,
//   required Directory targetBaseDirectory,
// }) async {
//   final outputDirectory = Directory(
//       '${targetBaseDirectory.path}/${providerConfig.configSource.instance}');
//
//   if (!outputDirectory.existsSync()) {
//     outputDirectory.createSync();
//   }
//   final Map<String, dynamic> pSchemaObject = {};
//
//   /// Send schemas to be persisted
//   /// PSchema
//   /// Version is set by Cloud Function
//   final pSchema = providerConfig.schema;
//
//   /// json conversion does not like a Set
//   if (pSchema.allRoles.isNotEmpty) {
//     pSchemaObject['roles'] = pSchema.allRoles.toList();
//   }
//   pSchemaObject['schema'] = pSchema.toJson();
//
//   /// Server schema
//   /// Version is set by Cloud Function
//   Map<String, dynamic> serverSchemaObject = {};
//   serverSchemaObject['schema'] = _serverSchema(pSchema);
//
//   final provider = Back4AppDataProvider(config: providerConfig);
//   provider.init(appConfig);
//
//   await provider.createDocument(
//     path: 'PSchema',
//     data: pSchemaObject,
//     useDelegate: Delegate.rest,
//   );
//   await provider.createDocument(
//     path: 'ServerSchema',
//     data: serverSchemaObject,
//     useDelegate: Delegate.rest,
//   );
//
//   /// Generate / copy cloud function files into local directory:
//   /// validation, code
//   /// TODO: user cloud code files
//   Back4AppSchemaGenerator generator = Back4AppSchemaGenerator();
//   generator.generateCode(schema: pSchema, previous: null);
//   await generator.writeFiles(outputDirectory);
//
//   return outputDirectory;
// }
//
// Map<String, Map<String, dynamic>> _serverSchema(PSchema pSchema) {
//   final Map<String, Map<String, dynamic>> serverClassSchemas = {};
//   pSchema.documents.forEach((key, value) {
//     final ServerSchemaClass schemaClass = ServerSchemaClass.fromPrecept(value);
//     final json = schemaClass.toJson();
//     serverClassSchemas[key] = json;
//   });
//   return serverClassSchemas;
// }
