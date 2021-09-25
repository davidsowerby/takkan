import 'package:precept_back4app_backend/backend/back4app/schema/serverCode/js/integerValidation.dart';
import 'package:precept_backend/backend/schema/serverCode/serverCode.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/validation/validator.dart';

/// A three step process to create and deploy Javascript Cloud Code in support of
/// a PSchema:
///
/// - Call [generate] to create a series of Javascript files for Back4App Cloud code
/// - [exportCode] to place the files in your b4a directory
/// - invoke 'b4a deploy' on your command line
///
/// Code is generated for:
/// - server side validation
/// - enforcing ACLs on save and update calls, to ensure no corruption on the client side
/// - automatic record 'count' retention, where required
/// - automatic aggregation where required
///
/// For clarity of structure, the cloud code 'main.js' contains only a series of
/// 'require' statements pointing to other .js files each relating to a specific
/// Back4App Class.
///
/// There are other more general files:
///
/// **Validation**
///
/// The code generated for validation deliberately fails at the first error.  IT
/// also does not attempt to return a meaningful message - every failure just
/// returns a "Validation Failed".  This is because validation at the client
/// has already been carried out using the same rules, and a failure at this stage
/// means either:
///
/// - client validation has been by-passed somehow, suggesting a potential hack
/// - an error in client code, allowing validation to be by-passed or incorrectly assessed
///
///
class Back4AppServerCodeGenerator implements ServerCodeGenerator {
  final Map<String, String> output = Map();

  @override
  bool generate({required PSchema schema}) {
    output.clear();
    schema.documents.forEach((key, value) {
      StringBuffer buf =
          StringBuffer('Parse.Cloud.beforeSave(\"$key\", (request) => {');
      _applyACL(document: value, buf: buf);
      _applyValidation(document: value, buf: buf);

      buf.writeln('});');
      output[value.name] = buf.toString();
    });

    return true;
  }

  @override
  Future<bool> exportCode({required String exportPath}) {
    throw UnimplementedError();
  }

  _applyValidation({required PDocument document, required StringBuffer buf}) {
    /// Apply validations for each field
    document.fields.forEach((key, field) {
      buf.writeln('const object = request.object;');
      field.validations.forEach((validation) {
        buf.writeln(_validation(key, validation));
      });
    });
  }

  _applyACL({required PDocument document, required StringBuffer buf}) {}

  _validation(String fieldName, ModelValidation validation) {
    switch (validation.runtimeType) {
      case IntegerValidation:
        return integerValidation(
          fieldName: fieldName,
          validation: validation as IntegerValidation,
        );
    }
  }
}

// Parse.Cloud.beforeSave("Review", (request) => {
// // do any additional beforeSave logic here
// },{
// fields: {
// stars : {
// required:true,
// options: stars => {
// return stars >= 1 && stars =< 5;
// },
// error: 'Your review must be between one and five stars'
// }
// }
// });

// Parse.Cloud.beforeSave("Review", (request) => {
// const comment = request.object.get("comment");
// if (comment.length > 140) {
// // Truncate and add a ...
// request.object.set("comment", comment.substring(0, 137) + "...");
// }
// });
