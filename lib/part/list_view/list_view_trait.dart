import 'package:takkan_client/part/trait.dart';

class ReadListViewTrait extends ReadTrait {

  const ReadListViewTrait({
    super.showCaption = true,
    required super.alignment,
  });
}

class EditListViewTrait extends EditTrait {

  EditListViewTrait({
    super.showCaption = true,
    required super.alignment,
  });
}

class ListViewTrait extends Trait<ReadListViewTrait, EditListViewTrait> {
  ListViewTrait({required super.readTrait, super.editTrait, required super.partName}) ;
}
