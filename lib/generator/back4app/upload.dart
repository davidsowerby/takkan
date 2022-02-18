import 'package:takkan_script/schema/schema.dart';

/// Uploads the SERVER schema - converted from a [Document] - to a [DataProvider]
/// The DataProvider instance is identified by API keys.  An implementation of
/// this is not expected to be used in a standard Precept client - it is more
/// likely to be in an admin app.
///
/// Use with EXTREME care.  Depending on the implementation, it is entirely
/// possible that a change of schema will delete data.
///

abstract class ServerSchemaHandler {
  /// Each [Document] type must be updated independently, and is identified by [documentName]
  /// within the [takkanSchema]
  ///
  /// The [headers] usually contain API keys as required by the specific implementation.
  Future<bool> createServerSchema({
    required Schema takkanSchema,
    required String documentName,
    required Map<String, String> headers,
    required int version,
  });

  Future<bool> updateServerSchema({
    required Schema takkanSchema,
    required String documentName,
    required Map<String, String> headers,
    required int version,
  });

  /// Adds the specified [roles] to the instance identified by [headers]
  Future<bool> addRoles({
    required List<String> roles,
    required Map<String, String> headers,
  });
}
