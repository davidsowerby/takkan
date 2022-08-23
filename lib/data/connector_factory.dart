import 'package:takkan_client/data/binding/binding.dart';
import 'package:takkan_client/data/binding/connector.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_schema/common/exception.dart';
import 'package:takkan_schema/common/log.dart';
import 'package:takkan_schema/schema/field/field.dart';
import 'package:takkan_schema/schema/field/integer.dart';
import 'package:takkan_schema/schema/field/list.dart';
import 'package:takkan_schema/schema/field/string.dart';
import 'package:takkan_script/data/converter/converter.dart';
import 'package:takkan_script/part/part.dart';
import 'package:takkan_schema/schema/schema.dart';

class ConnectorFactory {
  ModelConnector buildConnector(
      {required DataBinding parentBinding,
      required DataContext dataContext,
      required Part config,
      required Type viewDataType}) {
    if (dataContext is StaticDataContext) {
      return StaticConnector(config.staticData!);
    }

    final SchemaElement? fieldSchema =
        dataContext.documentSchema.fields[config.property];
    if (fieldSchema == null) {
      String msg =
          'No schema found for property ${config.property}, have you forgotten to add it to Schema?';
      logType(this.runtimeType).e(msg);
      throw TakkanException(msg);
    }
    final binding = _binding(
      parentBinding: parentBinding,
      fieldSchema: fieldSchema as Field,
      property: config.property!,
    );
    final converter =
        _converter(schema: fieldSchema, viewDataType: viewDataType);
    final connector = ModelConnector(
        binding: binding, converter: converter, fieldSchema: fieldSchema);
    return connector;
  }
}

Binding _binding(
    {required DataBinding parentBinding,
    required Field fieldSchema,
    required String property}) {
  switch (fieldSchema.runtimeType) {
    case FString:
      return parentBinding.modelBinding.stringBinding(property: property);
    case FList:
      return parentBinding.modelBinding.listBinding(property: property);
    case FInteger:
      return parentBinding.modelBinding.intBinding(property: property);
    default:
      throw UnimplementedError(
          "No defined binding for field data type ${fieldSchema.runtimeType.toString()}");
  }
}

ModelViewConverter _converter(
    {required Field schema, required Type viewDataType}) {
  if (schema.modelType == viewDataType) {
    return PassThroughConverter();
  }
  switch (schema.runtimeType) {
    case FInteger:
      return _intConverter(viewDataType);
    case FString:
      return _stringConverter(viewDataType);
    default:
      throw UnimplementedError(
          "No defined ModelViewConverter for field data type ${schema.runtimeType.toString()}");
  }
}

/// We won't get here if the [viewDataType] is the same as the model data type
ModelViewConverter _intConverter(Type viewDataType) {
  switch (viewDataType) {
    case String:
      return IntStringConverter();
    default:
      throw UnimplementedError(
          "No defined ModelViewConverter for field data type 'int' for Particle $viewDataType");
  }
}

/// We won't get here if the [viewDataType] is the same as the model data type
ModelViewConverter _stringConverter(Type viewDataType) {
  switch (viewDataType) {
    case String:
      return PassThroughConverter<String>();
    default:
      throw UnimplementedError(
          "No defined ModelViewConverter for field data type 'String' for Particle $viewDataType");
  }
}
