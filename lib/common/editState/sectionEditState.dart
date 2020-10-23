import 'package:flutter/widgets.dart';
import 'package:precept/common/logger.dart';

/// [canEdit] reflects whether the [readMode] status can be changed. If a [DocumentPageSection] is allowed to edit, this is
/// typically used to display an edit icon to the user
/// [readMode] determines the display of [Part] elements - for example, [Text] if true, [TextField] if false

class SectionEditState with ChangeNotifier {
  bool _canEdit;
  bool _readMode;

  SectionEditState({@required bool canChangeEdit, @required bool readOnly})
      : _readMode = readOnly,
        _canEdit = canChangeEdit;

  bool get readMode {
    return _readMode;
  }

  bool get canEdit {
    return _canEdit;
  }

  set readMode(bool readOnly) {
    _readMode = readOnly;
    getLogger(this.runtimeType)
        .d("SectionEditState changed to readOnly: $readOnly");
    notifyListeners();
  }

  set canEdit(bool value) {
    _canEdit = value;
    notifyListeners();
  }
}
