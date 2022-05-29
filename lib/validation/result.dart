/// The result of a data validation
///
/// [passed] true if validation successful
/// [patternKey] used to look up the I18N pattern for validation failure.  Is an Object because multiple enum types are used
/// [javaScript] the Javascript code for the equivalent validation, used by code generator for the backend
/// [params] parameters and values for interpolation with the pattern retrieved by the [patternKey]
class VResult {
  final bool passed;
  final VResultRef ref;

  Object get patternKey => ref.messageKey;

  String get javaScript => ref.javaScript;

  Map<String, dynamic> get params => ref.toJson;

  const VResult({
    required this.passed,
    required this.ref,
  });

  bool get failed => !passed;
}

/// see VResult
class VResultRef {
  final Object messageKey;
  final String javaScript;
  final Map<String, dynamic> toJson;

  const VResultRef(
      {required this.messageKey,
      required this.javaScript,
      required this.toJson});

  String get name => toJson['runtimeType'] as String;

  Map<String, dynamic> get params {
    Map<String, dynamic> copy = Map.from(toJson);
    copy.remove('runtimeType');
    return copy;
  }
}
