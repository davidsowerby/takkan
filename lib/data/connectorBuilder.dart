import 'package:precept_client/binding/binding.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_script/data/converter/converter.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/schema.dart';

mixin ConnectorBuilder {
  ModelConnector buildConnector(
      { DataBinding dataBinding, PPart config, Type viewDataType}) {
    final ModelBinding parentBinding = dataBinding.binding;
    final PDocument schema = dataBinding.schema;
    final PSchemaElement fieldSchema = schema.fields[config.property];
    final binding =
        _binding(parentBinding: parentBinding, schema: fieldSchema, property: config.property);
    final converter = _converter(schema: fieldSchema, viewDataType: viewDataType);
    final connector = ModelConnector(binding: binding, converter: converter);
    return connector;
  }

  Binding _binding({ModelBinding parentBinding, PField schema, String property}) {
    switch (schema.runtimeType) {
      case PString:
        return parentBinding.stringBinding(property: property);
      default:
        throw UnimplementedError(
            "No defined binding for field data type ${schema.runtimeType.toString()}");
    }
  }

  ModelViewConverter _converter({PField schema, Type viewDataType}) {
    switch (schema.runtimeType) {
      case PInteger:
        return _intConverter(viewDataType);
      case PString:
        return _stringConverter(viewDataType);
      default:
        throw UnimplementedError(
            "No defined ModelViewConverter for field data type ${schema.runtimeType.toString()}");
    }
  }

  ModelViewConverter _intConverter(Type viewDataType) {
    switch (viewDataType) {
      case int:
        return PassThroughConverter<int>();
      case String:
        return IntStringConverter();
      default:
        throw UnimplementedError(
            "No defined ModelViewConverter for field data type 'int' for Particle ${viewDataType.toString()}");
    }
  }

  ModelViewConverter _stringConverter(Type viewDataType) {
    switch (viewDataType) {
      case String:
        return PassThroughConverter<String>();
      default:
        throw UnimplementedError(
            "No defined ModelViewConverter for field data type 'String' for Particle ${viewDataType.toString()}");
    }
  }
}
