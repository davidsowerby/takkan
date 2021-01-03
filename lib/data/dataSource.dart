import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_client/inject/inject.dart';
import 'package:precept_script/script/dataSource.dart';

/// The intersection point between application and data.
///
/// Retrieval of data is specified by [config], which specifies both the data required (effectively a Query) and the
/// [PBackend] to retrieve it from.
///
/// Holds a copy of the retrieved data in [_temporaryDocument], and notifies listeners
/// as the retrieval state changes.  The retrieval state mirrors that used by [FutureBuilder] and [StreamBuilder]
/// depending on whether [config] requires a Future or Stream in response.
///
/// [_temporaryDocument] records all changes in its [TemporaryDocument.changeList]
///
/// Once data has been retrieved, [_temporaryDocument.output] is connected to a [RootBinding],
/// for [DataBinding] instances to connect to.  In this way, [DataBindings] provide a connection chain
/// from the data source to the element which actually displays the data.
///
/// When [readMode] is true, the document and therefore pages using it, are read only.
/// When [canEdit] is true, [readMode] can be changed to false (thus allowing editing) by user action
///
/// Precept potentially creates a number of [Form] instances on one page, as each [Panel]
/// may have its own.  This class just holds the [GlobalKey] for each, so Form content can be pushed
/// to the [_temporaryDocument] prior to saving it.
///
class DataSource with ChangeNotifier {
  final DateTime timestamp;
  final PDataSource config;
  TemporaryDocument _temporaryDocument;
  bool _readOnlyMode = true;
  bool _canEdit;

  DataSource({bool canEdit = true, bool readOnlyMode = true, @required this.config})
      : timestamp = DateTime.now(),
        _readOnlyMode = readOnlyMode,
        _canEdit = canEdit {
    _temporaryDocument = inject<TemporaryDocument>();
  }

  RootBinding get rootBinding => _temporaryDocument.rootBinding;

  bool get readMode => _readOnlyMode;

  bool get canEdit => _canEdit;

  set readMode(bool value) {
    _readOnlyMode = value;
    notifyListeners();
  }

  updateData(Map<String, dynamic> data) {
    _temporaryDocument.updateFromSource(source: data);
  }




}
