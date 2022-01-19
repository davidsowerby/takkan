class PreceptState {
  final Map<String, dynamic> state;

  const PreceptState(this.state);

  String get artifact => state['artifact'];

  int get currentVersion => state['currentVersion'];

  int get nextVersion => state['nextVersion'];

  int get maxVersion => state['maxVersion'];

  DateTime? get nextActivation => state['nextActivation'];
}

class PreceptStateHistory extends PreceptState {
  const PreceptStateHistory(Map<String, dynamic> state) : super(state);
}
