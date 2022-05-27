import 'package:takkan_client/data/binding/binding.dart';
import 'package:takkan_client/data/mutable_document.dart';
import 'package:takkan_script/script/constants.dart';

class StringBinding extends Binding<String> {
  const StringBinding.private(
      {required CollectionBinding parent,
        String property=notSet,
        int index=Binding.noValue,
      required String firstLevelKey,
      MutableDocument? editHost})
      : super.private(
            parent: parent,
            property: property,
            index: index,
            firstLevelKey: firstLevelKey,
            editHost: editHost);

  @override
  String emptyValue() {
    return "";
  }
}
