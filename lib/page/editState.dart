import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_common/common/log.dart';

/// [readMode] determines the display of [Part] elements - for example, [Text] if true, [TextField] if false
/// [canEdit] reflects whether the [readMode] status can be changed. If a [DocumentPageSection] is allowed to edit, this is
/// typically used to display an edit icon to the user
class EditState with ChangeNotifier {
  bool _canEdit;
  bool _readMode;

  EditState({bool canEdit = true, bool readMode = true})
      : _readMode = readMode,
        _canEdit = canEdit;


  bool get readMode {
    return _readMode;
  }

  bool get editMode {
    return !_readMode;
  }

  bool get canEdit {
    return _canEdit;
  }

  set readMode(bool value) {
    _readMode = value;
    logType(this.runtimeType).d("EditState changed to readMode: $value");
    notifyListeners();
  }

  set canEdit(bool value) {
    _canEdit = value;
    notifyListeners();
  }
}
