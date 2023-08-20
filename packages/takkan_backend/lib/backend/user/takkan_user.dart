class TakkanUser {
  TakkanUser.fromJson(this.data) {
    data['unknown'] = false;
  }

  TakkanUser.unknownUser() : data = const {} {
    unknown = true;
  }
  final Map<String, dynamic> data;

  set firstName(value) => data['firstName'] = value;

  String get firstName => data['firstName'] as String? ?? '';

  set knownAs(value) => data['knownAs'] = value;

  String get knownAs => data['knownAs'] as String? ?? '';

  set lastName(value) => data['lastName'] = value;

  String get lastName => data['lastName'] as String? ?? '';

  set email(value) => data['email'] = value;

  String get email => data['email'] as String? ?? '';

  set userName(value) => data['userName'] = value;

  String get userName => data['userName'] as String? ?? '';

  set objectId(value) => data['objectId'] = value;

  String get objectId => data['objectId'] as String? ?? '';

  set sessionToken(value) => data['sessionToken'] = value;

  String? get sessionToken => data['sessionToken'] as String?;

  set unknown(bool value) => data['unknown'] = value;

  bool get unknown => data['unknown'] as bool? ?? false;
}
