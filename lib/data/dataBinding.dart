import 'package:flutter/widgets.dart';
import 'package:precept_client/binding/mapBinding.dart';
import 'package:precept_script/schema/schema.dart';

class DataBinding with ChangeNotifier {
  final ModelBinding binding;
  final PDocument schema;

  DataBinding({@required this.binding, @required this.schema});
}
