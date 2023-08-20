import 'package:flutter/material.dart';
import 'package:takkan_client/common/on_color.dart';
import 'package:takkan_client/data/binding/connector.dart';
import 'package:takkan_client/data/binding/list_binding.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/connector_factory.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/part/list_view/nav_tile.dart';
import 'package:takkan_client/part/part.dart';
import 'package:takkan_client/part/text/text_particle.dart';
import 'package:takkan_client/part/list_view/list_view_trait.dart';
import 'package:takkan_script/part/list_view.dart' as ListViewConfig;

import '../../library/trait_library.dart';
import '../text/text_part.dart';

/// A [ListViewPart] has little difference between read and edit modes, except that when
/// editing is enabled, and if the user has permissions,create and delete item options are available
class ListViewPart extends StatelessWidget {
  final ListViewTrait trait;
  final ListViewConfig.ListView config;
  final ModelConnector connector;
  final DataContext dataContext;

  const ListViewPart({
    required this.trait,
    required this.config,
    required this.connector,
    required this.dataContext,
  });

  @override
  Widget build(BuildContext context) {
    ListBinding<dynamic> binding = connector.binding as ListBinding<dynamic>;
    return Container(
      width: 250,
      height: 250,
      color: Colors.amberAccent,
      child: ListView.builder(
        itemBuilder: (context, index) => trait.tileBuilder.build(
          binding: binding,
          index: index,
          dataContext: dataContext,
          config: config,
        ),
      ),
    );
  }

// return Container(color: Colors.amberAccent, height: 500, child: ListView.builder());
}

class ListViewPartBuilder
    implements PartBuilder<ListViewConfig.ListView, ListViewPart> {
  @override
  ListViewPart createPart(
      {required ListViewConfig.ListView config,
      required ThemeData theme,
      required DataContext dataContext,
      required DataBinding parentDataBinding,
      OnColor onColor = OnColor.surface}) {
    final trait =
        traitLibrary.find(config: config, theme: theme) as ListViewTrait;

    final connectorFactory = ConnectorFactory();
    final connector = connectorFactory.buildConnector(
        parentBinding: parentDataBinding,
        dataContext: dataContext,
        config: config,
        viewDataType: List);
    return ListViewPart(
      trait: trait,
      config: config,
      connector: connector,
      dataContext: dataContext,
    );
  }
}

abstract class TileBuilder<TILE extends Widget> {
  TILE build({
    required ListViewConfig.ListView config,
    required ListBinding binding,
    required int index,
    required DataContext dataContext,
  });
}

class NavigationTileBuilder implements TileBuilder<NavigationTile> {
  final ReadTextTrait titleTrait;
  final ReadTextTrait subtitleTrait;
  final ConnectorFactory connectorFactory;
  final ParticleInterpolator interpolator;

  const NavigationTileBuilder({
    required this.titleTrait,
    required this.subtitleTrait,
    required this.connectorFactory,
    required this.interpolator,
  });

  @override
  NavigationTile build({
    required ListViewConfig.ListView config,
    required ListBinding binding,
    required DataContext dataContext,
    required int index,
  }) {
    final entryBinding = binding.modelBinding(index: index);
    final entryDataBinding = DefaultDataBinding(entryBinding);
    final entry = entryBinding.read()!;

    final String docClass = dataContext.documentSchema.name;
    final String objectId = entry[dataContext.documentIdKey]!;
    return NavigationTile(
      route: 'documents/$docClass/#$objectId',
      arguments: {},
      title: TextParticle(
        partConfig: config,
        trait: titleTrait,
        interpolator: interpolator,
        connector: connectorFactory.buildConnector(
            parentBinding: entryDataBinding,
            dataContext: dataContext,
            config: config,
            viewDataType: String),
      ),
      subtitle: Text(
        entry[config.subtitleProperty] ?? '',
      ),
    );
  }
}

class ListTileBuilder implements TileBuilder<ListTile> {
  final ReadTextTrait titleTrait;
  final ReadTextTrait subtitleTrait;
  final ConnectorFactory connectorFactory;
  final ParticleInterpolator interpolator;

  const ListTileBuilder({
    required this.titleTrait,
    required this.subtitleTrait,
    required this.connectorFactory,
    required this.interpolator,
  });

  @override
  ListTile build({
    required ListViewConfig.ListView config,
    required ListBinding binding,
    required DataContext dataContext,
    required int index,
  }) {
    final entryBinding = binding.modelBinding(index: index);
    final entryDataBinding = DefaultDataBinding(entryBinding);
    final entry = entryBinding.read()!;

    return ListTile(
      title: TextParticle(
        partConfig: config,
        trait: titleTrait,
        interpolator: interpolator,
        connector: connectorFactory.buildConnector(
            parentBinding: entryDataBinding,
            dataContext: dataContext,
            config: config,
            viewDataType: String),
      ),
      subtitle: Text(
        entry[config.subtitleProperty] ?? '',
      ),
    );
  }
}
