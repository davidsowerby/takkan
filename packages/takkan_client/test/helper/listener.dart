import 'package:takkan_schema/common/log.dart';

class ChangeListener {
  int changeCount = 0;

  listenToChange() {
    changeCount++;
    logType(this.runtimeType).d("change $changeCount received");
  }
}
