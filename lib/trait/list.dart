import 'package:precept_client/trait/traitLibrary.dart';

class ListViewTrait extends Trait {
  const ListViewTrait();

  @override
  Type get viewDataType => List;
}

class ListViewReadTrait extends ListViewTrait {
  const ListViewReadTrait();
}

class ListViewEditTrait extends ListViewTrait {
  const ListViewEditTrait();


}

class ListItemReadTrait extends Trait {
  const ListItemReadTrait();

  @override
  Type get viewDataType => Object;
}

class ListItemEditTrait extends Trait {
  const ListItemEditTrait();

  @override
  Type get viewDataType => Object;
}
