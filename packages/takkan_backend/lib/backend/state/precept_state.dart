class TakkanState {

  const TakkanState(this.state);
  final Map<String, dynamic> state;

  String get artifact => state['artifact'] as String;

  int get currentVersion => state['currentVersion'] as int;

  int get nextVersion => state['nextVersion'] as int;

  int get maxVersion => state['maxVersion'] as int;

  DateTime? get nextActivation => state['nextActivation'] as DateTime?;
}

class TakkanStateHistory extends TakkanState {
  const TakkanStateHistory(super.state);
}
