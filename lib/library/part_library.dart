import 'package:flutter/material.dart';
import 'package:takkan_client/binding/binding.dart';
import 'package:takkan_client/binding/connector.dart';
import 'package:takkan_client/common/component/email_sign_in.dart';
import 'package:takkan_client/common/component/nav/nav_button.dart';
import 'package:takkan_client/common/component/nav/nav_buttonset.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/part/part.dart';
import 'package:takkan_client/particle/list_view_particle.dart';
import 'package:takkan_client/particle/query_view_particle.dart';
import 'package:takkan_client/particle/text_box_particle.dart';
import 'package:takkan_client/particle/text_particle.dart';
import 'package:takkan_client/trait/email_signin.dart';
import 'package:takkan_client/trait/list.dart';
import 'package:takkan_client/trait/navigation.dart';
import 'package:takkan_client/trait/query.dart';
import 'package:takkan_client/trait/text.dart';
import 'package:takkan_client/trait/text_box.dart';
import 'package:takkan_client/trait/trait_library.dart';
import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/data/converter/converter.dart';
import 'package:takkan_script/part/list_view.dart' as ListViewConfig;
import 'package:takkan_script/part/navigation.dart';
import 'package:takkan_script/part/part.dart' as PartConfig;
import 'package:takkan_script/part/query_view.dart';
import 'package:takkan_script/schema/field/field.dart';
import 'package:takkan_script/schema/field/integer.dart';
import 'package:takkan_script/schema/field/list.dart';
import 'package:takkan_script/schema/field/string.dart';
import 'package:takkan_script/schema/schema.dart';
import 'package:takkan_script/signin/sign_in.dart';

PartLibrary _partLibrary = PartLibrary();

PartLibrary get partLibrary => _partLibrary;

class PartLibrary {
  final Map<Type, Widget Function(PartConfig.Part, ModelConnector)> entries =
      Map();

  PartLibrary();

  /// Builds and returns a [Part] from the current [partConfig].  Particle instances are created,
  /// and configured according to the [theme].  This allows the [Part] to be configured once on construction,
  /// rather than repeatedly as it would be if configuration were during the [Part.build] method.
  Widget partBuilder({
    required PartConfig.Part partConfig,
    required ThemeData theme,
    required DataContext dataContext,
    required DataBinding parentBinding,
    final Map<String, dynamic> pageArguments = const {},
  }) {
    final readTrait = traitLibrary.findParticleTrait(
      theme: theme,
      traitName: partConfig.readTraitName,
    );
    final Widget readParticle = (partConfig.isStatic)
        ? findStaticParticle(
      theme: theme,
            trait: readTrait,
            partConfig: partConfig,
            pageArguments: pageArguments,
            dataContext: dataContext,
          )
        : findParticle(
            parentBinding: parentBinding,
            theme: theme,
            dataContext: dataContext,
            trait: readTrait,
            partConfig: partConfig,
            pageArguments: pageArguments,
          );

    /// Either of these conditions mean we do not need an edit particle
    if (partConfig.readOnly == true || partConfig.isStatic) {
      return PartWidget(
        readParticle: readParticle,
        config: partConfig,
      );
    }

    /// TODO: editTraitName must be checked in config validation
    final editTrait = traitLibrary.findParticleTrait(
      theme: theme,
      traitName: partConfig.editTraitName!,
    );
    final editParticle = findParticle(
      theme: theme,
      dataContext: dataContext,
      parentBinding: parentBinding,
      trait: editTrait,
      partConfig: partConfig,
      pageArguments: pageArguments,
    );

    return Container(
      height: partConfig.height,
      child: PartWidget(
        readParticle: readParticle,
        editParticle: editParticle,
        config: partConfig,
      ),
    );
  }

  /// Loads library entries defined by the developer
  ///
  /// If there are duplicate keys, later additions will override earlier
  /// Defaults are loaded first, so to replace, define another with the key 'default'
  /// There should be no need to call this directly, init for all libraries is carried out in
  /// a call to [Takkan.init] which should be before your runApp statement
  init({Map<Type, Widget Function(PartConfig.Part, ModelConnector)>? entries}) {
    // TODO
  }

  Widget _createParticle(
    ThemeData theme,
    Trait trait,
    ModelConnector connector,
    PartConfig.Part partConfig,
    final Map<String, dynamic> pageArguments,
    DataContext dataConnector,
  ) {
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
      case NavButtonTrait:
        return NavButtonWidget(
          trait: trait as NavButtonTrait,
          partConfig: partConfig as NavButton,
          connector: connector,
        );
      case NavButtonSetTrait:
        final String buttonTraitName =
            (trait as NavButtonSetTrait).buttonTraitName;
        final Trait buttonTrait = traitLibrary.findParticleTrait(
          theme: theme,
          traitName: buttonTraitName,
        );
        return NavButtonSetWidget(
            config: partConfig as NavButtonSet,
            buttonTrait: buttonTrait as NavButtonTrait,
            trait: trait,
            pageArguments: pageArguments);
      case EmailSignInTrait:
        return EmailSignInWidget(
            config: partConfig as EmailSignIn, dataContext: dataConnector);
      case QueryViewReadTrait:
        return QueryViewParticle(
          trait: trait as QueryViewTrait,
          config: partConfig as QueryView,
          connector: connector,
          readOnly: true,
          schema: dataConnector.documentSchema,
        );
      case QueryViewEditTrait:
        return QueryViewParticle(
          trait: trait as QueryViewTrait,
          config: partConfig as QueryView,
          connector: connector,
          readOnly: false,
          schema: dataConnector.documentSchema,
        );
      case ListViewReadTrait:
        return ListViewParticle(
          trait: trait as ListViewTrait,
          config: partConfig as ListViewConfig.ListView,
          connector: connector,
          readOnly: true,
          schema: dataConnector.documentSchema,
        );
      case ListViewEditTrait:
        return ListViewParticle(
          trait: trait as ListViewTrait,
          config: partConfig as ListViewConfig.ListView,
          connector: connector,
          readOnly: false,
          schema: dataConnector.documentSchema,
        );
    }
    String msg = "No entry is defined for $particleType in $runtimeType";
    logType(this.runtimeType).e(msg);
    throw TakkanException(msg);
  }

  Type viewDataTypeFor(Type particleType) {
    switch (particleType) {
      case TextTrait:
      case TextBoxTrait:
      case NavButtonTrait:
      case NavButtonSetTrait:
        return String;
      case EmailSignInTrait:
        return Object;
      case QueryViewReadTrait:
      case QueryViewEditTrait:
      case ListViewReadTrait:
      case ListViewEditTrait:
        return List;
    }
    String msg = "No entry is defined for $particleType in $runtimeType";
    logType(this.runtimeType).e(msg);
    throw TakkanException(msg);
  }

  Widget findParticle({
    required ThemeData theme,
    required Trait trait,
    required PartConfig.Part partConfig,
    required Map<String, dynamic> pageArguments,
    required DataContext dataContext,
    required DataBinding parentBinding,
  }) {
    Type particleType = trait.runtimeType;
    ConnectorFactory connectorFactory = ConnectorFactory();
    final connector = connectorFactory.buildConnector(
      viewDataType: viewDataTypeFor(particleType),
      config: partConfig,
      documentSchema: dataContext.documentSchema,
      parentBinding: parentBinding,
    );
    return _createParticle(
        theme, trait, connector, partConfig, pageArguments, dataContext);
  }

  Widget findStaticParticle({
    required ThemeData theme,
    required Trait trait,
    required PartConfig.Part partConfig,
    required Map<String, dynamic> pageArguments,
    required DataContext dataContext,
  }) {
    final connector = StaticConnector(partConfig.staticData!);
    return _createParticle(
        theme, trait, connector, partConfig, pageArguments, dataContext);
  }

// ParticleRecord _findParticleRecord(Part config, bool read){
//   final Type particleType = (read) ? config.read.runtimeType : config.edit.runtimeType;
//   switch (particleType) {
//     case PText:
//       return ParticleRecord(particleType,(part,read,connector)=>);
//   }
// }

}

// class ParticleRecord{
//   final Type particleDataType;
//   final Widget Function(Part, bool, ModelConnector) creator;
//
//   const ParticleRecord(this.particleDataType, this.creator);
//
// }

class ConnectorFactory {
  ModelConnector buildConnector(
      {required DataBinding parentBinding,
      required Document documentSchema,
      required PartConfig.Part config,
      required Type viewDataType}) {
    final SchemaElement? fieldSchema = documentSchema.fields[config.property];
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
