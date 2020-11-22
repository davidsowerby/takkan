import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/common/logger.dart';
import 'package:precept_client/precept/document/documentState.dart';


/// [readOnlyMode] determines the display of [Part] elements - for example, [Text] if true, [TextField] if false
/// [canEdit] reflects whether the [readOnlyMode] status can be changed. If a [DocumentPageSection] is allowed to edit, this is
/// typically used to display an edit icon to the user
class SectionState with ChangeNotifier {
  bool _canEdit;
  bool _readOnlyMode;

  SectionState({bool canEdit=true, bool readOnlyMode=true})
      : _readOnlyMode = readOnlyMode,
        _canEdit = canEdit;

  SectionState.fromDocument(DocumentState documentEditState)
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
    getLogger(this.runtimeType).d("SectionEditState changed to readOnly: $readOnly");
    notifyListeners();
  }

  set canEdit(bool value) {
    _canEdit = value;
    notifyListeners();
  }
}
