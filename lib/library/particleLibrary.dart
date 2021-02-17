import 'package:flutter/widgets.dart';
import 'package:precept_client/binding/binding.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/particle/textBoxParticle.dart';
import 'package:precept_client/particle/textParticle.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/data/converter/converter.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/particle/pText.dart';
import 'package:precept_script/script/particle/pTextBox.dart';

ParticleLibrary _particleLibrary = ParticleLibrary();

ParticleLibrary get particleLibrary => _particleLibrary;

class ParticleLibrary {
  final Map<Type, Widget Function(PPart, ModelConnector)> entries = Map();

  ParticleLibrary();

  /// Finds an entry in the library matching [key], and returns an instance of it with [config]
  /// Throws a [PreceptException] if not found
  Widget find(Type key, PPart config, ModelConnector connector) {
    logType(this.runtimeType).d("Finding $key in $runtimeType");
    final func = entries[key];
    if (func == null) {
      String msg = "No entry is defined for ${key.toString()} in $runtimeType";
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    return (func == null) ? null : func(config, connector);
  }

  /// Loads library entries defined by the developer
  ///
  /// If there are duplicate keys, later additions will override earlier
  /// Defaults are loaded first, so to replace, define another with the key 'default'
  /// There should be no need to call this directly, init for all libraries is carried out in
  /// a call to [Precept.init] which should be before your runApp statement
  init({Map<Type, Widget Function(PPart, ModelConnector)> entries}) {}

  Widget _createParticle(PPart config, bool read, ModelConnector connector) {
    final Type particleType = (read) ? config.read.runtimeType : config.edit.runtimeType;
    switch (particleType) {
      case PText:
        return TextParticle(
          config: config,
          connector: connector,
        );
      case PTextBox:
        return TextBoxParticle(
          config: config,
          connector: connector,
        );
    }
    String msg = "No entry is defined for $particleType in $runtimeType";
    logType(this.runtimeType).e(msg);
    throw PreceptException(msg);
  }

  Widget findParticle(DataBinding dataBinding, PPart config, bool read) {
    Type particleDataType = _findViewDataType(config, read);
    final connector = ConnectorFactory().buildConnector(
        viewDataType: particleDataType, config: config, dataBinding: dataBinding);
    return _createParticle(config, read, connector);
  }

  Widget findStaticParticle(PPart config) {
    final connector = StaticConnector(config.staticData);
    return _createParticle(config, true, connector);
  }

  Type _findViewDataType(PPart config, bool read) {
    final Type particleType = (read) ? config.read.runtimeType : config.edit.runtimeType;
    switch (particleType) {
      case PText:
      case PTextBox:
        return String;
    }
    String msg = "No Particle is defined for $particleType in $runtimeType";
    logType(this.runtimeType).e(msg);
    throw PreceptException(msg);
  }

// ParticleRecord _findParticleRecord(PPart config, bool read){
//   final Type particleType = (read) ? config.read.runtimeType : config.edit.runtimeType;
//   switch (particleType) {
//     case PText:
//       return ParticleRecord(particleType,(part,read,connector)=>);
//   }
// }


}

// class ParticleRecord{
//   final Type particleDataType;
//   final Widget Function(PPart, bool, ModelConnector) creator;
//
//   const ParticleRecord(this.particleDataType, this.creator);
//
// }


class ConnectorFactory {
  ModelConnector buildConnector({@required DataBinding dataBinding,
    @required PPart config,
    @required Type viewDataType}) {
    final ModelBinding parentBinding = dataBinding.binding;
    final PDocument schema = dataBinding.schema;
    final PSchemaElement fieldSchema = schema.fields[config.property];
    assert(fieldSchema != null, "No schema found for property ${config.property}");
    final binding =
        _binding(parentBinding: parentBinding, schema: fieldSchema, property: config.property);
    final converter = _converter(schema: fieldSchema, particleDataType: viewDataType);
    final connector = ModelConnector(binding: binding, converter: converter, fieldSchema: fieldSchema);
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

  ModelViewConverter _converter({PField schema, Type particleDataType}) {
    switch (schema.runtimeType) {
      case PInteger:
        return _intConverter(particleDataType);
      case PString:
        return _stringConverter(particleDataType);
      default:
        throw UnimplementedError(
            "No defined ModelViewConverter for field data type ${schema.runtimeType.toString()}");
    }
  }

  ModelViewConverter _intConverter(Type particleDataType) {
    switch (particleDataType) {
      case int:
        return PassThroughConverter<int>();
      case String:
        return IntStringConverter();
      default:
        throw UnimplementedError(
            "No defined ModelViewConverter for field data type 'int' for Particle $particleDataType");
    }
  }

  ModelViewConverter _stringConverter(Type particleDataType) {
    switch (particleDataType) {
      case String:
        return PassThroughConverter<String>();
      default:
        throw UnimplementedError(
            "No defined ModelViewConverter for field data type 'String' for Particle $particleDataType");
    }
  }
}
