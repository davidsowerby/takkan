import 'package:precept/common/logger.dart';
import 'package:precept/common/repository.dart';
import 'package:precept/precept/document/documentState.dart';
import 'package:precept/precept/model/modelDocument.dart';

/// Retrieves documents from the [Repository] layer, and manages current instances.
/// This allows the system to work with multiple documents concurrently
class DocumentController {
  final streamCreator=StreamCreator();
  Stream<DocumentState> getDocument(PDocumentSelector selector) {
    return _repo(selector).map<DocumentState>((d) => transformSnapshot(d));
  }

  List<Map<String, dynamic>> getDocumentList(PDocumentSelector selector) {}

  // TODO replace with injectable Repository
  Stream<Map<String, dynamic>> _repo(PDocumentSelector selector) {
    return streamCreator.start(Duration(seconds: 1), 10);
  }

  DocumentState transformSnapshot(Map<String, dynamic> data) {
    final ds = DocumentState();
    ds.updateData(data);
    return ds;
  }


}

class StreamCreator{
  final snapshots = [
    {"title": "temporary data", "value": "skip"},
    {"title": "added age", "value": "b", "age":41},
    {"title": "temporary data", "value": "r", "age":66},
    {"title": "changed data", "value": "rerw", "age":66},
    {"title": "changed data", "value": "gdgfdfgd", "age":66},
    {"title": "changed data", "value": "xvxcv", "age":66},
    {"title": "revised data", "value": "sssss", "age":10},
    {"title": "revised data", "value": "sdfsf", "age":10},
    {"title": "revised data", "value": "sssssssssss", "age":12},
    {"title": "revised data", "value": "cccccc", "age":13},
    {"title": "last data", "value": "ddddddddd", "age":14},
  ];

  Stream<Map<String, dynamic>> start(Duration interval,
      [int maxCount]) async* {

    int i = 0;
    while (true) {
      await Future.delayed(interval);
      yield snapshots[i];
      if (i == maxCount) break;
      getLogger(this.runtimeType).d("Release snapshot $i");
      i++;
    }

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