import 'package:flutter/material.dart';
import 'package:precept_client/backend/backendHandler.dart';
import 'package:precept_client/backend/data.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/precept/builder/commonBuilder.dart';
import 'package:precept_client/precept/mutable/sectionState.dart';
import 'package:precept_client/precept/script/help.dart';
import 'package:precept_client/precept/script/script.dart';
import 'package:precept_client/precept/script/themeLookup.dart';
import 'package:provider/provider.dart';

class Panel extends StatelessWidget {
  final PPanel config;

  Panel({Key key, @required this.config});

  @override
  Widget build(BuildContext context) {
    final PanelState panelState = Provider.of<PanelState>(context);
    if (config.isStatic == Triple.yes) {
      return (panelState.expanded) ? _buildExpanded(context) : _buildHeader();
    } else {
      final DataSource dataSource = Provider.of<DataSource>(context);
      final BackendHandler backend = Provider.of<BackendHandler>(context);
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
                return activeBuilder(context, dataSource, snapshot.data, panelState);
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
  Widget activeBuilder(
      BuildContext context, DataSource dataSource, Data update, PanelState panelState) {
    final dataBinding = Provider.of<DataBinding>(context, listen: false);
    dataSource.updateData(update.data);
    return (panelState.expanded) ? _buildExpanded(context) : _buildHeader();
  }

  Widget _buildExpanded(BuildContext context) {
    return Column(
      children: [_buildHeader(), PanelBuilder().buildContent(config: config)],
    );
  }

  Widget _buildHeader() {
    return PanelHeading(config: config.heading);
  }
}

class PanelState with ChangeNotifier {
  bool _expanded;
  final PPanel config;

  PanelState({@required this.config}) : _expanded = config.style.openExpanded;

  bool get expanded => _expanded;

  set expanded(value) {
    _expanded = value;
    notifyListeners();
  }
}

class PanelHeading extends StatelessWidget {
  final PPanelHeading config;
  final PHelp help;

  const PanelHeading({
    Key key,
    @required this.config,
    this.help,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ThemeLookup themeLookup = inject<ThemeLookup>();
    return Container(
        child: Text(config.title),
        color: themeLookup.color(theme: theme, pColor: config.style.background));
  }

  edit(BuildContext context) {
    final EditState sectionState = Provider.of<EditState>(context, listen: false);
    sectionState.readOnlyMode = false;
  }

  save(BuildContext context) {
    final EditState sectionState = Provider.of<EditState>(context, listen: false);
    sectionState.readOnlyMode = true;
  }
}
