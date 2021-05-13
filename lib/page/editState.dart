import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_script/common/log.dart';

/// [readMode] determines the display of [Part] elements - for example, [Text] if true, [TextField] if false
/// [canEdit] reflects whether the [readMode] status can be changed, and typically enables / disables the display of an 'edit' icon
class EditState with ChangeNotifier {
  bool _canEdit;
  bool _readMode;

  EditState({bool canEdit = true, bool readMode = true})
      : _readMode = readMode,
        _canEdit = canEdit;


  /// If you want to be sure that you use editMode correctly, do not invert this.  See [editMode]
  bool get readMode {
    return _readMode;
  }

  /// returns true only if not in read mode AND canEdit is true, thus not directly the inverse of
  /// [readMode]
  bool get editMode {
    return (!_readMode) && (canEdit);
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
