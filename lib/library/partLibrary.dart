import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/binding/binding.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_client/common/component/nav/navButton.dart';
import 'package:precept_client/common/component/nav/navButtonSet.dart';
import 'package:precept_client/common/content/contentState.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/part/part.dart';
import 'package:precept_client/particle/listViewParticle.dart';
import 'package:precept_client/particle/queryViewParticle.dart';
import 'package:precept_client/particle/textBoxParticle.dart';
import 'package:precept_client/particle/textParticle.dart';
import 'package:precept_client/trait/list.dart';
import 'package:precept_client/trait/navigation.dart';
import 'package:precept_client/trait/query.dart';
import 'package:precept_client/trait/text.dart';
import 'package:precept_client/trait/textBox.dart';
import 'package:precept_client/trait/traitLibrary.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/common/script/common.dart';
import 'package:precept_script/data/converter/converter.dart';
import 'package:precept_script/part/listView.dart';
import 'package:precept_script/part/navigation.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/part/queryView.dart';
import 'package:precept_script/schema/field/field.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/field/list.dart';
import 'package:precept_script/schema/field/queryResult.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/schema.dart';

PartLibrary _partLibrary = PartLibrary();

PartLibrary get partLibrary => _partLibrary;

class PartLibrary {
  final Map<Type, Widget Function(PPart, ModelConnector)> entries = Map();

  PartLibrary();

  /// Builds and returns a [Part] from the current [partConfig].  Particle instances are created,
  /// and configured according to the [theme].  This allows the [Part] to be configured once on construction,
  /// rather than repeatedly as it would be if configuration were during the [Part.build] method.
  Part partBuilder({
    required PPart partConfig,
    required ThemeData theme,
    required ContentBindings contentBindings,
    final Map<String, dynamic> pageArguments = const {},
  }) {
    final readTrait = traitLibrary.findParticleTrait(
      theme: theme,
      traitName: partConfig.readTraitName,
      partConfig: partConfig,
    );
    final Widget readParticle = (partConfig.isStatic == IsStatic.yes)
        ? findStaticParticle(theme, readTrait, partConfig, pageArguments )
        : findParticle(theme, contentBindings.dataBinding, readTrait, partConfig, pageArguments );

    /// Either of these conditions mean we do not need an edit particle
    if (partConfig.readOnly == true || partConfig.isStatic == IsStatic.yes) {
      return Part(
        readParticle: readParticle,
        config: partConfig,
        pageArguments: pageArguments,
        parentBinding: contentBindings.dataBinding,
      );
    }

    /// TODO: editTraitName must be checked in config validation
    final editTrait = traitLibrary.findParticleTrait(
      theme: theme,
      traitName: partConfig.editTraitName!,
      partConfig: partConfig,
    );
    final editParticle =
    findParticle(theme, contentBindings.dataBinding, editTrait, partConfig, pageArguments );

    return Part(
      readParticle: readParticle,
      editParticle: editParticle,
      config: partConfig,
      pageArguments: pageArguments,
      parentBinding: contentBindings.dataBinding,
    );
  }

  /// Loads library entries defined by the developer
  ///
  /// If there are duplicate keys, later additions will override earlier
  /// Defaults are loaded first, so to replace, define another with the key 'default'
  /// There should be no need to call this directly, init for all libraries is carried out in
  /// a call to [Precept.init] which should be before your runApp statement
  init({Map<Type, Widget Function(PPart, ModelConnector)>? entries}) {
    // TODO
  }

  Widget _createParticle(ThemeData theme,
      Trait trait,
      ModelConnector connector,
      PPart partConfig,
      final Map<String, dynamic> pageArguments,) {
    final particleType = trait.runtimeType;
    switch (particleType) {
      case TextTrait:
        return TextParticle(
          trait: trait as TextTrait,
          connector: connector,
          partConfig: partConfig,
        );
      case TextBoxTrait:
        return TextBoxParticle(
          trait: trait as TextBoxTrait,
          connector: connector,
          partConfig: partConfig,
        );
      case NavigationButtonTrait:
        return NavigationButton(
          trait: trait as NavigationButtonTrait,
          partConfig: partConfig as PNavButton,
          connector: connector,
        );
      case NavigationButtonSetTrait:
        final String buttonTraitName = (trait as NavigationButtonSetTrait).buttonTraitName;
        final Trait buttonTrait = traitLibrary.findParticleTrait(
            theme: theme, traitName: buttonTraitName, partConfig: partConfig);
        return NavigationButtonSet(
            config: partConfig as PNavButtonSet,
            buttonTrait: buttonTrait as NavigationButtonTrait,
            trait: trait,
            pageArguments: pageArguments );
      case QueryViewReadTrait:
        return QueryViewParticle(trait: trait as QueryViewTrait, config: partConfig as PQueryView, connector: connector, readOnly: true);
      case QueryViewEditTrait:
        return QueryViewParticle(trait: trait as QueryViewTrait, config: partConfig as PQueryView, connector: connector, readOnly: false);
      case ListViewReadTrait:
        return ListViewParticle(trait: trait as ListViewTrait, config: partConfig as PListView, connector: connector, readOnly: true);
      case ListViewEditTrait:
        return ListViewParticle(trait: trait as ListViewTrait, config: partConfig as PListView, connector: connector, readOnly: false);
    }
    String msg = "No entry is defined for $particleType in $runtimeType";
    logType(this.runtimeType).e(msg);
    throw PreceptException(msg);
  }

  Widget findParticle(ThemeData theme, DataBinding dataBinding, Trait trait, PPart partConfig,
      final Map<String, dynamic> pageArguments) {
    Type viewDataType = trait.viewDataType;
    final connector = ConnectorFactory()
        .buildConnector(viewDataType: viewDataType, config: partConfig, dataBinding: dataBinding);
    return _createParticle(theme, trait, connector, partConfig, pageArguments );
  }

  Widget findStaticParticle(ThemeData theme, Trait trait, PPart partConfig,
      final Map<String, dynamic> pageArguments) {
    final connector = StaticConnector(partConfig.staticData);
    return _createParticle(theme, trait, connector, partConfig, pageArguments );
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
      {required DataBinding dataBinding, required PPart config, required Type viewDataType}) {
    final ModelBinding parentBinding = dataBinding.binding;

    final PSchemaElement? fieldSchema = (config is PQueryView)
        ? dataBinding.activeDataSource.dataProvider.config.schema?.queries[config.property]
        : dataBinding.schema.fields[config.property];
    if (fieldSchema == null) {
      String msg =
          'No schema found for property ${config
          .property}, have you forgotten to add it to PSchema?';
      logType(this.runtimeType).e(msg);
      throw PreceptException(msg);
    }
    final binding =
    _binding(dataBinding: dataBinding,
      parentBinding: parentBinding,
      schema: fieldSchema as PField,
      property: config.property,);
    final converter = _converter(schema: fieldSchema, viewDataType: viewDataType);
    final connector =
    ModelConnector(binding: binding, converter: converter, fieldSchema: fieldSchema);
    return connector;
  }
}

Binding _binding(
    {required DataBinding dataBinding,required  ModelBinding parentBinding, required PField schema,required  String property}) {
  switch (schema.runtimeType) {
    case PString:
      return parentBinding.stringBinding(property: property);
    case PList:
      return parentBinding.listBinding(property: property);
    case PQueryResult:
      return dataBinding.activeDataSource.temporaryDocument.queryRootBinding.listBinding(property: property);
    default:
      throw UnimplementedError(
          "No defined binding for field data type ${schema.runtimeType.toString()}");
  }
}

ModelViewConverter _converter({required PField schema, required Type viewDataType}) {
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
