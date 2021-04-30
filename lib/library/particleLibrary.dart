import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/binding/binding.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_client/common/component/nav/navButton.dart';
import 'package:precept_client/common/component/nav/navButtonSet.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/particle/textBoxParticle.dart';
import 'package:precept_client/particle/textParticle.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/data/converter/converter.dart';
import 'package:precept_script/part/list.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/particle/navigation.dart';
import 'package:precept_script/particle/text.dart';
import 'package:precept_script/particle/textBox.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/schema.dart';

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

  Widget _createParticle(ThemeData theme, PPart partConfig, bool read, ModelConnector connector) {
    final Type particleType = (read) ? partConfig.read.runtimeType : partConfig.edit.runtimeType;
    switch (particleType) {
      case PText:
        return TextParticle(
          config: partConfig,
          connector: connector,
        );
      case PTextBox:
        return TextBoxParticle(
          config: partConfig,
          connector: connector,
        );
      case PNavParticle:
        return NavigationButton(
          partConfig: partConfig,
          connector: connector,
        );
      case PNavButtonSetParticle:
        return NavigationButtonSet(config: partConfig);

      // case PListView:
      //   // final particleConfig = partConfig.read;
      //   // final ListViewReadTrait trait =
      //   //     traitLibrary.listTrait(theme: theme, traitName: particleConfig.traitName);
      //   // return ListViewPart(
      //   //   config: partConfig,
      //   //   connector: connector,
      //   //   trait: trait,
      //   // );
    }
    String msg = "No entry is defined for $particleType in $runtimeType";
    logType(this.runtimeType).e(msg);
    throw PreceptException(msg);
  }

  Widget findParticle(ThemeData theme, DataBinding dataBinding, PPart config, bool read) {
    Type viewDataType = (read) ? config.read.viewDataType : config.edit.viewDataType;
    final connector = ConnectorFactory()
        .buildConnector(viewDataType: viewDataType, config: config, dataBinding: dataBinding);
    return _createParticle(theme, config, read, connector);
  }

  Widget findStaticParticle(ThemeData theme,PPart config) {
    final connector = StaticConnector(config.staticData);
    return _createParticle(theme,config, true, connector);
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
  ModelConnector buildConnector(
      {@required DataBinding dataBinding, @required PPart config, @required Type viewDataType}) {
    final ModelBinding parentBinding = dataBinding.binding;

    /// If this is a list, we need to lookup the schema from schema.lists, otherwise schema.documents
    /// We won't actually know the model data type until we look up the schema, but assume that if
    /// viewDataType is a list, the model type must be as well
    final PSchemaElement fieldSchema = (viewDataType == List)
        ? dataBinding.schema.root.lists[config.property]
        : dataBinding.schema.fields[config.property];
    if (fieldSchema == null) {
      String msg =
          'No schema found for property ${config.property}, have you forgotten to add it to PSchema?';
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    final binding =
        _binding(parentBinding: parentBinding, schema: fieldSchema, property: config.property);
    final converter = _converter(schema: fieldSchema, viewDataType: viewDataType);
    final connector =
        ModelConnector(binding: binding, converter: converter, fieldSchema: fieldSchema);
    return connector;
  }
}

Binding _binding({ModelBinding parentBinding, PField schema, String property}) {
  switch (schema.runtimeType) {
    case PString:
      return parentBinding.stringBinding(property: property);
    case PList:
      return parentBinding.listBinding(property: property);
    default:
      throw UnimplementedError(
          "No defined binding for field data type ${schema.runtimeType.toString()}");
  }
}

ModelViewConverter _converter({PField schema, Type viewDataType}) {
  if (schema.modelType == viewDataType) {
    return PassThroughConverter();
  }
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
