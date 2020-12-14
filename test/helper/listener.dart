import 'package:precept_script/common/logger.dart';

class ChangeListener {
  int changeCount = 0;

  listenToChange() {
    changeCount++;
    logType(this.runtimeType).d("change $changeCount received");
  }
}
