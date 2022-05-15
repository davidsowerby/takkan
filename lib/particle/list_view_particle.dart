import 'package:flutter/material.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/common/component/nav/nav_tile.dart';
import 'package:precept_client/page/edit_state.dart';
import 'package:precept_client/trait/list.dart';
import 'package:precept_script/part/abstract_list_view.dart';
import 'package:precept_script/part/list_view.dart' as ListViewConfig;
import 'package:precept_script/schema/schema.dart';
import 'package:provider/provider.dart';

mixin ListViewParticleBuilder {
  Widget modelBuilder(BuildContext context, AbstractListView config, int index,
      List<Map<String, dynamic>> data, Document documentSchema) {
    final dataItem = data[index];
    return _navTileBuilder(dataItem, config, documentSchema);
  }

  Widget _listTileBuilder(Map<String, dynamic> entry, AbstractListView config) {
    return ListTile(
      title: Text(entry[config.titleProperty]),
      subtitle: Text(
        entry[config.subtitleProperty] ?? '',
      ),
    );
  }

  Widget _navTileBuilder(Map<String, dynamic> entry, AbstractListView config,
      Document documentSchema) {
// TODO: this Back4App specific
    final String path = documentSchema.name;
    final String objectId = entry['objectId']!;
    return NavigationTile(
      route: '$path/$objectId',
      arguments: {},
      title: Text(entry[config.titleProperty]),
      subtitle: Text(
        entry[config.subtitleProperty] ?? '',
      ),
    );
  }

// Widget _panelBuilder(Map<String, dynamic> entry, PAbstractListView config){
//   return Panel(config: ,);
// }

}

/// A [ListViewParticle] is used for both read and edit mode, as opposed
/// for example, to a [TextParticle] which uses a Text and TextBox respectively.
class ListViewParticle extends StatelessWidget with ListViewParticleBuilder {
  final ListViewTrait trait;
  final ListViewConfig.ListView config;
  final ModelConnector connector;
  final bool readOnly;
  final Document schema;

  const ListViewParticle({
    required this.trait,
    required this.config,
    required this.connector,
    required this.readOnly,
    required this.schema,
  });

  @override
  Widget build(BuildContext context) {
    final bool readMode =
        (readOnly) ? true : Provider.of<EditState>(context).readMode;
    final List<Map<String, dynamic>> data = connector.readFromModel();
    final ListView listView = ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) =>
            modelBuilder(context, config, index, data, schema));
    if (readMode) {
      final ListViewReadTrait modeTrait = trait as ListViewReadTrait;
    } else {
      final ListViewEditTrait modeTrait = trait as ListViewEditTrait;
    }
    // return Container(color: Colors.amberAccent, height: 500, child: ListView.builder());

    return Container(
      alignment: trait.alignment,
      width: 250,
      height: 250,
      color: Colors.amberAccent,
      child: listView,
    );
  }
}

// List<Widget> _createChildren(ModelConnector connector,
//     Widget Function(Map<String, dynamic>, ListItemTrait) itemBuilder,
//     ListItemTrait itemTrait,) {
//   final data = connector.readFromModel();
//   final List<Widget> children = List.empty(growable: true);
//   for (Map<String, dynamic> entry in data) {
//     final Widget tile = itemBuilder(entry, itemTrait);
//     children.add(Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: tile,
//     ));
//   }
//   return children;
// }
