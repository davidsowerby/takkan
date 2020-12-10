import 'package:flutter/material.dart';
import 'package:precept_client/backend/backend.dart';
import 'package:precept_client/backend/data.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_client/precept/builder/commonBuilder.dart';
import 'package:precept_client/precept/script/script.dart';
import 'package:provider/provider.dart';

class Panel extends StatelessWidget {
  final PPanel config;

  Panel({Key key, @required this.config});

  @override
  Widget build(BuildContext context) {
    if (config.isStatic == Triple.yes) {
      return PanelBuilder().buildContent(config: config);
    } else {
      final DataSource dataSource = Provider.of<DataSource>(context);
      final Backend backend = Provider.of<Backend>(context);
      return StreamBuilder<Data>(
          stream: backend.getStream(documentId: null),
          initialData: Data(data: {}),
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
  }

  /// Called when the Stream is active.
  /// Updates [dataSource] (which is in the Widget tree above this Widget) so that bindings
  /// reflect the new data. Then builds using [PanelBuilder]
  activeBuilder(BuildContext context, DataSource dataSource, Data update) {
    final dataBinding = Provider.of<DataBinding>(context, listen: false);
    dataSource.updateData(update.data);
    return PanelBuilder().buildContent(config: config);
  }
}
