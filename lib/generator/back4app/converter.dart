import 'package:precept_script/schema/schema.dart';

/// Converts between [PSchema] a [DataProviderSchema] implementation specific to
/// a data provider
abstract class SchemaConverter<S extends DataProviderSchema> {
  S convertToBackend({required PSchema preceptSchema});

  PSchema convertFromBackend({required S backendSchema});

  /// Gets the schema from the backend, as a backend specific object
  /// In practice, usually just decodes a call to [getRawBackendSchema]
  Future<S> getBackendSchema();

  /// Gets the schema as JSON, from the backend.  See also [getBackendSchema]
  Future<Map<String, dynamic>> getRawBackendSchema();

  putBackendSchema({required S backendSchema});
}

/// Primarily for type safety
abstract class DataProviderSchema {}
