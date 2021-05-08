import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/common/component/nav/navTile.dart';
import 'package:precept_client/common/content/contentState.dart';
import 'package:precept_client/page/editState.dart';
import 'package:precept_client/trait/list.dart';
import 'package:precept_script/part/abstractListView.dart';
import 'package:precept_script/part/listView.dart';
import 'package:provider/provider.dart';

mixin ListViewParticleBuilder {
  Widget modelBuilder(
      BuildContext context, PAbstractListView config, int index, List<Map<String, dynamic>> data) {
    final dataItem = data[index];
    return _navTileBuilder(dataItem, config);
  }

  Widget _listTileBuilder(Map<String, dynamic> entry, PAbstractListView config) {
    return ListTile(
      title: Text(entry[config.titleProperty]),
      subtitle: Text(
        entry[config.subtitleProperty] ?? '',
      ),
    );
  }

  Widget _navTileBuilder(Map<String, dynamic> entry, PAbstractListView config) {


    return NavigationTile(
      route: "${entry['__typename']}",// TODO: this Back4App specific
      arguments: {ContentState.preloadDataKey:entry},
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
  final PListView config;
  final ModelConnector connector;
  final bool readOnly;

  const ListViewParticle({
    @required this.trait,
    @required this.config,
    @required this.connector,
    @required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    final bool readMode = (readOnly) ? true : Provider.of<EditState>(context).readMode;
    final List<Map<String, dynamic>> data = connector.readFromModel();
    final ListView listView = ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) => modelBuilder(context, config, index, data));
    if (readMode) {
      final ListViewReadTrait modeTrait = trait as ListViewReadTrait;
    } else {
      final ListViewEditTrait modeTrait = trait as ListViewEditTrait;
    }
    // return Container(color: Colors.amberAccent, height: 500, child: ListView.builder());

    return Container(
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
