import 'package:precept_client/binding/binding.dart';
import 'package:precept_client/data/temporaryDocument.dart';
import 'package:precept_script/common/script/constants.dart';
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
