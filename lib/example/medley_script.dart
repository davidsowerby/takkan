import 'package:precept_script/script/script.dart';
import 'package:precept_script/script/version.dart';

import 'medley_schema.dart';

final List<PScript> medleyScript = [medleyScript0];

final PScript medleyScript0 = PScript(
  name: 'Medley',
  version: PVersion(number: 0, label: '0.0.0-draft'),
  schema: medleySchema[0],
  routes: {'person': PPage(title: 'Person')},
);
