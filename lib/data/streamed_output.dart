import 'dart:async';

import 'package:takkan_client/data/binding/map_binding.dart';
import 'package:takkan_client/data/mutable_document.dart';

/// Wraps a JSON map of data with a [StreamController], and fires a stream event
/// when data is changed
///
/// [close] MUST be called to avoid resource waste
class StreamedOutput {
  bool _streamIsActive = true;
  final Map<String, dynamic> _data = {};
  final MutableDocument? Function() getEditHost;
  late StreamController<Map<String, dynamic>> _streamController;
  late RootBinding _rootBinding;

  StreamedOutput({required this.getEditHost}) {
    _streamController = StreamController<Map<String, dynamic>>.broadcast(
      onCancel: () => {_streamIsActive = false},
      onListen: () => {_streamIsActive = true},
    );
    _rootBinding = RootBinding(data: _data, id: 'streamed output',getEditHost: getEditHost,);
  }

  Map<String, dynamic> get data => Map.from(_data);

  RootBinding get rootBinding => _rootBinding;

  Stream<Map<String, dynamic>> get stream => _streamController.stream;

  /// Updates [data] and invokes [_fireStreamEvent].  The call is ignored
  /// if stream is not active ([_streamIsActive]is false)
  ///
  bool update({
    required Map<String, dynamic> data,
  }) {
    if (_streamIsActive) {
      this._data.clear();
      this._data.addAll(data);
      _fireStreamEvent();
      return true;
    }
    return false;
  }

  bool get streamIsActive => _streamIsActive;

  /// Closes this instance, and closes the [_streamController].  Make sure you
  /// call this when done
  Future<bool> close() async {
    _streamIsActive = false;
    await _streamController.close();
    _data.clear();
    return true;
  }

  /// Sets value for a specific key and creates a stream event
  operator []=(String key, dynamic value) {
    _data[key] = value;
    _fireStreamEvent();
  }

  dynamic operator [](Object? key) {
    return _data[key];
  }

  Object remove(String key) {
    final removed = _data.remove(key);
    _fireStreamEvent();
    return removed;
  }

  /// We use [data] as it takes copy of [_data] to post onto the stream, because
  /// [_data] may change before the event is actioned
  _fireStreamEvent() {
    _streamController.add(data);
  }


}

