
import 'package:precept_script/schema/field.dart';
import 'package:precept_script/schema/list.dart';
import 'package:precept_script/schema/schema.dart';
import 'package:precept_script/schema/select.dart';

final kitchenSinkSchema = PSchema(
  name: 'kitchenSink',
  documents:  {
    'Account': PDocument(
      fields: {
        'objectId': PString(),
        'recordDate': PDate(),
        'customer': PDocument(
          fields: {
            'firstName': PString(),
            'lastName': PString(),
            'age': PInteger(),
          },
        ),
        'address': PPointer(),
        'notifications': PSelectBoolean(),
        'linkedAccounts': PPointer(),
        'joinDate': PDate(),
        'average': PDouble(),
        'colourChoices' : PSelectString(),
        'successRate': PDouble(),
      },
    ),
    'Address': PDocument(
      fields: {
        'firstLine': PString(),
        'secondLine': PString(),
        'country': PSelectString(),
        'location':PGeoPosition(),
        'region': PGeoRegion(),
        'postCode': PPostCode(),
      },
    ),
  },
);
