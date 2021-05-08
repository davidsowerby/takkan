import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/page/editState.dart';
import 'package:precept_client/particle/listViewParticle.dart';
import 'package:precept_client/trait/query.dart';
import 'package:precept_script/part/queryView.dart';
import 'package:provider/provider.dart';


class QueryViewParticle extends StatelessWidget with ListViewParticleBuilder {
  final QueryViewTrait trait;
  final PQueryView config;
  final ModelConnector connector;
  final bool readOnly;

  const QueryViewParticle({@required this.trait,@required this.config,@required this.connector, @required this.readOnly});

  @override
  Widget build(BuildContext context) {
    final bool readMode = (readOnly) ? true : Provider
        .of<EditState>(context)
        .readMode;
    final List<Map<String,dynamic>> data = connector.readFromModel();
    final ListView listView = ListView.builder(itemCount: data.length,itemBuilder: (context, index) => modelBuilder(context,config, index,data));
    if (readMode) {
      final QueryViewReadTrait modeTrait = trait as QueryViewReadTrait;
    } else {
      final QueryViewEditTrait modeTrait = trait as QueryViewEditTrait;
    }
    // return Container(color: Colors.amberAccent, height: 500, child: ListView.builder());

    return Container(
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
