/// This should be in a utils package somewhere, it is used in precept_server_code_generator and precept_dev_app
class Args {
  final Map<String, String> mappedArgs = {};
  final List<String> missingKeys = List.empty(growable: true);

  Args({required List<String> args, List<String> requiredKeys = const []}) {
    for (String element in args) {
      final a = element.split('=');
      mappedArgs[a[0]] = a[1];
    }
    validatePresent(keys: requiredKeys);
  }

  List<String> validatePresent({required List<String> keys}) {
    for (String key in keys) {
      if (!mappedArgs.containsKey(key)) {
        missingKeys.add(key);
      }
    }
    return missingKeys;
  }
}
