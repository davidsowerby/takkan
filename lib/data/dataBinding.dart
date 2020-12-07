import 'package:flutter/widgets.dart';
import 'package:precept_client/precept/binding/mapBinding.dart';

class DataBinding with ChangeNotifier{
  final ModelBinding binding;

  DataBinding({@required this.binding});
}