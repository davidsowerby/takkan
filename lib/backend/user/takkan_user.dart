class TakkanUser {
  final Map<String, dynamic> data;

  TakkanUser.fromJson(this.data) {
    data['unknown'] = false;
  }

  TakkanUser.unknownUser() : data = const {} {
    unknown = true;
  }

  set firstName(value) => data['firstName'] = value;

  String get firstName => data['firstName'] ?? '';

  set knownAs(value) => data['knownAs'] = value;

  String get knownAs => data['knownAs'] ?? '';

  set lastName(value) => data['lastName'] = value;

  String get lastName => data['lastName'] ?? '';

  set email(value) => data['email'] = value;

  String get email => data['email'] ?? '';

  set userName(value) => data['userName'] = value;

  String get userName => data['userName'] ?? '';

  set objectId(value) => data['objectId'] = value;

  String get objectId => data['objectId'] ?? '';

  set sessionToken(value) => data['sessionToken'] = value;

  String? get sessionToken => data['sessionToken'];

  set unknown(bool value) => data['unknown'] = value;

  bool get unknown => data['unknown'] ?? false;
}
