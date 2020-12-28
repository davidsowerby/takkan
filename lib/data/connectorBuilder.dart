import 'package:precept_client/binding/binding.dart';
import 'package:precept_client/binding/converter.dart';
import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/particle/particle.dart';
import 'package:precept_script/schema/field.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/pPart.dart';

mixin ConnectorBuilder {
  ModelConnector buildConnector(
      {Particle particle, DataBinding dataBinding, PPart config, Type viewDataType}) {
    final ModelBinding parentBinding = dataBinding.binding;
    final PDocument schema = dataBinding.schema;
    final PSchemaElement fieldSchema = schema.fields[config.property];
    final binding =
        _binding(parentBinding: parentBinding, schema: fieldSchema, property: config.property);
    final converter = _converter(schema: fieldSchema, particle: particle);
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

  ModelViewConverter _converter({PField schema, Particle particle}) {
    switch (schema.runtimeType) {
      case PInteger:
        return _intConverter(particle);
      case PString:
        return _stringConverter(particle);
      default:
        throw UnimplementedError(
            "No defined ModelViewConverter for field data type ${schema.runtimeType.toString()}");
    }
  }

  ModelViewConverter _intConverter(Particle particle) {
    switch (particle.viewDataType) {
      case int:
        return PassThroughConverter<int>();
      case String:
        return IntStringConverter();
      default:
        throw UnimplementedError(
            "No defined ModelViewConverter for field data type 'int' for Particle ${particle.runtimeType.toString()}");
    }
  }

  ModelViewConverter _stringConverter(Particle particle) {
    switch (particle.viewDataType) {
      case String:
        return PassThroughConverter<String>();
      default:
        throw UnimplementedError(
            "No defined ModelViewConverter for field data type 'String' for Particle ${particle.runtimeType.toString()}");
    }
  }
}
