import 'package:precept_script/schema/field/date.dart';
import 'package:precept_script/schema/field/double.dart';
import 'package:precept_script/schema/field/geoPosition.dart';
import 'package:precept_script/schema/field/pointer.dart';
import 'package:precept_script/schema/field/postCode.dart';
import 'package:precept_script/schema/field/relation.dart';
import 'package:precept_script/schema/field/string.dart';
import 'package:precept_script/schema/schema.dart';

final kitchenSinkSchema = PSchema(
  name: 'kitchenSink',
  documents: {
    'Account': PDocument(
      fields: {
        'objectId': PString(),
        'accountNumber': PString(defaultValue: 'unknown'),
        'category': PString(
          validations: [
            VString.longerThan(2),
            VString.shorterThan(5),
          ],
        ),
        'recordDate': PDate(),

        /// This should be a PPointer or a PObject (probably the former in this case
        // 'customer': PDocument(
        //   fields: {
        //     'firstName': PString(),
        //     'lastName': PString(),
        //     'age': PInteger(),
        //   },
        // ),
        'address': PPointer(targetClass: '_User'),
        // 'notifications': PSelectBoolean(),
        'linkedAccounts': PRelation(targetClass: '_User'),
        'joinDate': PDate(),
        'average': PDouble(defaultValue: 23.8),
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
  },
);
