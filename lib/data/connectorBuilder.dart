import 'package:precept_client/binding/binding.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/data/converter/converter.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/schema.dart';

mixin ConnectorBuilder {
  ModelConnector buildConnector(
      {required DataBinding dataBinding, required PPart config,required Type viewDataType}) {
    final ModelBinding parentBinding = dataBinding.binding;
    final PDocument schema = dataBinding.schema;
    final String? propertyName=config.property;
    if (propertyName==null){
      throw PreceptException('propertyName is required');
    }
    final PSchemaElement? fieldSchema = schema.fields[config.property];
    if (fieldSchema==null){
      throw PreceptException('fieldSchema must be defined');
    }
    final binding =
        _binding(parentBinding: parentBinding, schema: fieldSchema as PField, property: propertyName);
    final converter = _converter(schema: fieldSchema, viewDataType: viewDataType);
    final connector = ModelConnector(binding: binding, converter: converter,fieldSchema: fieldSchema);
    return connector;
  }

  Binding _binding({required ModelBinding parentBinding,required PField schema,required String property}) {
    switch (schema.runtimeType) {
      case PString:
        return parentBinding.stringBinding(property: property);
      default:
        throw UnimplementedError(
            "No defined binding for field data type ${schema.runtimeType.toString()}");
    }
  }

  ModelViewConverter _converter({required PField schema,required Type viewDataType}) {
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
