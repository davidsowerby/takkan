class TakkanState {
  final Map<String, dynamic> state;

  const TakkanState(this.state);

  String get artifact => state['artifact'];

  int get currentVersion => state['currentVersion'];

  int get nextVersion => state['nextVersion'];

  int get maxVersion => state['maxVersion'];

  DateTime? get nextActivation => state['nextActivation'];
}

class TakkanStateHistory extends TakkanState {
  const TakkanStateHistory(Map<String, dynamic> state) : super(state);
}
