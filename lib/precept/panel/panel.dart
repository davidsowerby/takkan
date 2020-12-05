import 'package:flutter/material.dart';
import 'package:precept_client/assembler/pageAssembler.dart';
import 'package:precept_client/backend/backend.dart';
import 'package:precept_client/backend/data.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_client/precept/binding/mapBinding.dart';
import 'package:precept_client/precept/script/script.dart';
import 'package:provider/provider.dart';

class Panel extends StatelessWidget {
  final Backend backend;
  final PPage pageConfig;
  final RootBinding rootBinding;

  Panel({Key key, @required this.pageConfig, @required this.rootBinding})
      : backend = Backend(config: pageConfig.backend); // Make sure we get the one furthest down the tree

  @override
  Widget build(BuildContext context) {
    final DataSource dataSource = Provider.of<DataSource>(context);
    return StreamBuilder<Data>(
        stream: backend.getStream(documentId: null),
        initialData: Data(data : {}),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: Text('No connection'),
              );
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
              return activeBuilder(context, dataSource, snapshot.data);
            case ConnectionState.done:
              return Center(
                child: Text("Connection closed"),
              );
            default:
              return null; // unreachable
          }
        });
  }

  /// Updates [documentState] (which is in the Widget tree above this Widget) so that bindings
  /// reflect the new data. Then builds using [assembleSections]
  activeBuilder(BuildContext context, DataSource documentState, Data update) {
    documentState.updateData(update.data);
    return assembleSections(rootBinding: rootBinding, pPage: pageConfig);
  }
}
