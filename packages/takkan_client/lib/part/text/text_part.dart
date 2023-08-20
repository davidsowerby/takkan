import 'package:flutter/material.dart';
import 'package:takkan_client/data/binding/connector.dart';
import 'package:takkan_client/common/on_color.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/connector_factory.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/part/part.dart';
import 'package:takkan_client/part/text/text_particle.dart';
import 'package:takkan_client/part/trait.dart';
import 'package:takkan_script/part/part.dart';

import '../../library/trait_library.dart';

class TextPart extends StatelessWidget {
  final ModelConnector modelConnector;
  final Part config;
  final TextParticle readParticle;
  final TextBoxParticle? editParticle;

  const TextPart({
    Key? key,
    required this.config,
    required this.modelConnector,
    required this.readParticle,
    required this.editParticle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ParticleSwitch(
      readParticle: readParticle,
      editParticle: editParticle,
      singleParticle: false,
      config: config,
    );
  }
}

class TextPartBuilder implements PartBuilder<Part, TextPart> {
  TextPart createPart({
    required Part config,
    required ThemeData theme,
    required DataContext dataContext,
    required DataBinding parentDataBinding,
    OnColor onColor = OnColor.surface,
  }) {
    final Trait trait = traitLibrary.find(config: config, theme: theme);

    ConnectorFactory connectorFactory = ConnectorFactory();
    final connector = connectorFactory.buildConnector(
      viewDataType: String,
      config: config,
      dataContext: dataContext,
      parentBinding: parentDataBinding,
    );

    return TextPart(
      config: config,
      readParticle: TextParticle(
        trait: trait.readTrait as ReadTextTrait,
        connector: connector,
        partConfig: config,
        interpolator: ParticleInterpolator(
          partConfig: config,
          connector: connector,
          dataContext: dataContext,
        ),
      ),
      editParticle: TextBoxParticle(
        connector: connector,
        partConfig: config,
        trait: trait.editTrait as EditTextTrait,
      ),
      modelConnector: connector,
    );
  }
}

class ReadTextTrait extends ReadTrait {
  final TextStyle textStyle;
  final TextAlign textAlign;
  final TextTheme textTheme;

  const ReadTextTrait({
    required this.textStyle,
    required this.textAlign,
    required this.textTheme,
    super.showCaption = true,
    required super.alignment,
  });
}

class EditTextTrait extends EditTrait {
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final TextTheme? textTheme;

  EditTextTrait({
    this.textStyle,
    this.textAlign,
    this.textTheme,
    super.showCaption = true,
    required super.alignment,
  });
}

class TextTrait extends Trait<ReadTextTrait, EditTextTrait> {
  TextTrait(
      {required super.readTrait, super.editTrait, required super.partName});
}
