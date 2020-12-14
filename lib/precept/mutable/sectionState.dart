import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_script/common/logger.dart';


/// [readOnlyMode] determines the display of [Part] elements - for example, [Text] if true, [TextField] if false
/// [canEdit] reflects whether the [readOnlyMode] status can be changed. If a [DocumentPageSection] is allowed to edit, this is
/// typically used to display an edit icon to the user
class EditState with ChangeNotifier {
  bool _canEdit;
  bool _readOnlyMode;

  EditState({bool canEdit=true, bool readOnlyMode=true})
      : _readOnlyMode = readOnlyMode,
        _canEdit = canEdit;

  EditState.fromDocument(DataSource documentEditState)
      : _canEdit = documentEditState.canEdit,
        _readOnlyMode = documentEditState.readOnlyMode;

  bool get readOnlyMode {
    return _readOnlyMode;
  }

  bool get canEdit {
    return _canEdit;
  }

  set readOnlyMode(bool readOnly) {
    _readOnlyMode = readOnly;
    logType(this.runtimeType).d("SectionEditState changed to readOnly: $readOnly");
    notifyListeners();
  }

  set canEdit(bool value) {
    _canEdit = value;
    notifyListeners();
  }
}
