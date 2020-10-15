import 'package:precept/common/logger.dart';

class ChangeListener {
  int changeCount = 0;

  listenToChange() {
    changeCount++;
    getLogger(this.runtimeType).d("change $changeCount received");
  }
}
