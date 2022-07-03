import 'package:takkan_script/data/select/data_selector.dart';

/// Generates Back4App cloud functions from appropriate [DataSelector] instances.
/// Two parts are generated, the 'API' part and the function itself. Example:
///
/// ''' javascript
///
/// '''
///
class CloudFunctionQueryGenerator {
  CloudFunction generate(DataSelector selector) {
    final String api = generateApi(selector);
    final String function = generateFunction(selector);
    return CloudFunction(api: api, function: function);
  }

  String generateApi(DataSelector selector) {
    final StringBuffer buf = StringBuffer();
    buf.writeln('Parse.Cloud.define("${selector.name}", async req => {');
    buf.write('??? call to function');
    buf.writeln('});');
    return buf.toString();
  }

  String generateFunction(DataSelector selector) {return '~~~~~~~~~~~~';}
}

/// Holds a Cloud function definition in 2 parts, API and function
class CloudFunction {

  const CloudFunction({required this.api, required this.function});
  final String api;
  final String function;
}



// const query = new Parse.Query("Employees");
// query.equalTo("name", req.params.name);
// query.include("hasThisPet")
// const results = await query.find();
// return results;
