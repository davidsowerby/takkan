import 'package:flutter/material.dart';
import 'package:takkan_client/binding/connector.dart';
import 'package:takkan_client/page/edit_state.dart';
import 'package:takkan_client/particle/list_view_particle.dart';
import 'package:takkan_client/trait/query.dart';
import 'package:provider/provider.dart';
import 'package:takkan_script/part/query_view.dart';
import 'package:takkan_script/schema/schema.dart';

class QueryViewParticle extends StatelessWidget with ListViewParticleBuilder {
  final QueryViewTrait trait;
  final QueryView config;
  final ModelConnector connector;
  final bool readOnly;
  final Document schema;

  const QueryViewParticle({
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
      final QueryViewReadTrait modeTrait = trait as QueryViewReadTrait;
    } else {
      final QueryViewEditTrait modeTrait = trait as QueryViewEditTrait;
    }
    // return Container(color: Colors.amberAccent, height: 500, child: ListView.builder());

    return Container(
      alignment: trait.alignment,
      height: 500,
      color: Colors.amberAccent,
      child: listView,
    );
  }
}

// Query<Widget> _createChildren(ModelConnector connector,
//     Widget Function(Map<String, dynamic>, QueryItemTrait) itemBuilder,
//     QueryItemTrait itemTrait,) {
//   final data = connector.readFromModel();
//   final Query<Widget> children = Query.empty(growable: true);
//   for (Map<String, dynamic> entry in data) {
//     final Widget tile = itemBuilder(entry, itemTrait);
//     children.add(Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: tile,
//     ));
//   }
//   return children;
// }
