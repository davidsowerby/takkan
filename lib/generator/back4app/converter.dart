import 'package:takkan_script/schema/schema.dart';

/// Converts between [Schema] a [DataProviderSchema] implementation specific to
/// a data provider
abstract class SchemaConverter<S extends DataProviderSchema> {
  S convertToBackend({required Schema takkanSchema});

  Schema convertFromBackend({required S backendSchema});

  /// Gets the schema from the backend, as a backend specific object
  /// In practice, usually just decodes a call to [getRawBackendSchema]
  Future<S> getBackendSchema();

  /// Gets the schema as JSON, from the backend.  See also [getBackendSchema]
  Future<Map<String, dynamic>> getRawBackendSchema();

  void putBackendSchema({required S backendSchema});
}

/// Primarily for type safety
abstract class DataProviderSchema {}
