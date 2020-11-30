import 'package:precept_client/common/logger.dart';
import 'package:precept_client/precept/script/document.dart';

/// Retrieves documents from the [Repository] layer, and manages current instances.
/// This allows the system to work with multiple documents concurrently
class DocumentController {
  final streamCreator = StreamCreator();

  Stream<Map<String,dynamic>> getDocument(PDocumentSelector selector) {
    return _repo(selector);
  }

  List<Map<String, dynamic>> getDocumentList(PDocumentSelector selector) {}

  // TODO replace with injectable Repository
  Stream<Map<String, dynamic>> _repo(PDocumentSelector selector) {
    return streamCreator.start(
        interval: Duration(seconds: 1), maxCount: 10, keepOpen: Duration(days: 60));
  }


}

class StreamCreator {
  final snapshots = [
    {
      "text": {"stringPart": "Text in a StringPart", "staticText": "A static text widget, cannot be edited"}
    },
    {
      "text": {"stringPart": "added age", "staticText": "b", "age": 41}
    },
    {
      "text": {"stringPart": "temporary data", "staticText": "r", "age": 66}
    },
    {
      "text": {"stringPart": "changed data", "staticText": "rerw", "age": 66}
    },
    {
      "text": {"stringPart": "changed data", "staticText": "gdgfdfgd", "age": 66}
    },
    {
      "text": {"stringPart": "changed data", "staticText": "xvxcv", "age": 66}
    },
    {
      "text": {"stringPart": "revised data", "staticText": "sssss", "age": 10}
    },
    {
      "text": {"stringPart": "revised data", "staticText": "sdfsf", "age": 10}
    },
    {
      "text": {"stringPart": "revised data", "staticText": "sssssssssss", "age": 12}
    },
    {
      "text": {"stringPart": "revised data", "staticText": "cccccc", "age": 13}
    },
    {
      "text": {"stringPart": "Text in a StringPart", "staticText": "A static text widget, cannot be edited"},
      "section2": {"name": "squiggly", "preference":"blue"}
    },
  ];

  Stream<Map<String, dynamic>> start(
      {Duration interval = const Duration(seconds: 1),
      Duration keepOpen = const Duration(seconds: 30),
      int maxCount = 10}) async* {
    int i = 0;
    while (true) {
      await Future.delayed(interval);
      yield snapshots[i];
      if (i == maxCount) break;
      logType(this.runtimeType).d("Release snapshot $i");
      i++;
    }
    await Future.delayed(keepOpen);
  }

  Stream<int> timedCounter(Duration interval, [int maxCount]) async* {
    int i = 0;
    while (true) {
      await Future.delayed(interval);
      yield i++;
      if (i == maxCount) break;
    }
  }
}
