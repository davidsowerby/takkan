import 'package:precept_script/schema/field/date.dart';
import 'package:precept_script/schema/field/double.dart';
import 'package:precept_script/schema/field/geoPosition.dart';
import 'package:precept_script/schema/field/integer.dart';
import 'package:precept_script/schema/field/pointer.dart';
import 'package:precept_script/schema/field/postCode.dart';
import 'package:precept_script/schema/field/queryResult.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/schema.dart';

final back4appSchema = PSchema(
  name: 'kitchenSink',
  documents: {
    'Account': PDocument(
      fields: {
        'objectId': PString(),
        'accountNumber': PString(),
        'category': PString(
          validations: [
            StringValidation(method: ValidateString.isLongerThan, param: 2),
            StringValidation(method: ValidateString.isShorterThan, param: 5),
          ],
        ),
        'recordDate': PDate(),
        'customer': PDocument(
          fields: {
            'firstName': PString(),
            'lastName': PString(),
            'age': PInteger(),
          },
        ),
        'address': PPointer(),
        // 'notifications': PSelectBoolean(),
        'linkedAccounts': PPointer(),
        'joinDate': PDate(),
        'average': PDouble(),
        // 'colourChoices': PSelectString(),
        'successRate': PDouble(),
      },
    ),
    'Address': PDocument(
      fields: {
        'firstLine': PString(),
        'secondLine': PString(),
        // 'country': PSelectString(),
        'location': PGeoPosition(),
        // 'region': PGeoRegion(),
        'postCode': PPostCode(),
      },
    ),
    'Issue': PDocument(
      permissions:
      PPermissions(requiresAuthentication: [RequiresAuth.all], updateRoles: ['editor']),
      fields: {
        'title': PString(),
        'description': PString(),
        'number': PInteger(),
        'priority': PInteger(),
        'state': PString(),
      },
    ),
  },
  queries: {'openIssues': PQuerySchema(documentSchema: 'Issue')},
);
