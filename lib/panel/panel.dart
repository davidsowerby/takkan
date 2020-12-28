import 'package:flutter/material.dart';
import 'package:precept_backend/backend/data.dart';
import 'package:precept_backend/backend/delegate.dart';
import 'package:precept_client/backend/backend.dart';
import 'package:precept_client/common/exceptions.dart';
import 'package:precept_client/data/dataBinding.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_client/library/themeLookup.dart';
import 'package:precept_client/page/editState.dart';
import 'package:precept_client/page/pageBuilder.dart';
import 'package:precept_script/script/dataSource.dart';
import 'package:precept_script/script/help.dart';
import 'package:precept_script/script/script.dart';
import 'package:provider/provider.dart';

class Panel extends StatelessWidget {
  final PPanel config;

  Panel({Key key, @required this.config});

  @override
  Widget build(BuildContext context) {
    final PanelState panelState = Provider.of<PanelState>(context);
    if (config.isStatic == IsStatic.yes) {
      return (panelState.expanded) ? _buildExpanded(context) : _buildHeader();
    } else {
      final DataSource dataSource = Provider.of<DataSource>(context);
      // final Backend backend = Provider.of<Backend>(context);
      final backend = Backend(config: config.backend);
      switch (dataSource.config.runtimeType) {
        case PDataGet:
          return futureBuilder(backend.get(config: dataSource.config), dataSource, panelState);
        case PDataStream:
          return streamBuilder(backend, dataSource, panelState);
        default:
          throw ConfigurationException(
              'Unrecognised data source type:  ${dataSource.config.runtimeType}');
      }
    }
  }

  Widget futureBuilder(Future<Data> future, DataSource dataSource, PanelState panelState) {
    return FutureBuilder<Data>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          dataSource.updateData(snapshot.data.data);
          return (panelState.expanded) ? _buildExpanded(context) : _buildHeader();
        } else if (snapshot.hasError) {
          final APIException error = snapshot.error;
          return Text('Error in Future ${error.message}');
        } else {
          return (panelState.expanded) ? _buildExpanded(context) : _buildHeader();
        }
      },
    );
  }

  Widget streamBuilder(Backend backend, DataSource dataSource, PanelState panelState) {
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
      children: [
        if (config.heading != null) _buildHeader(),
        PanelBuilder().buildContent(context: context, config: config),
      ],
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
        child: Text(config.parent.caption),
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
