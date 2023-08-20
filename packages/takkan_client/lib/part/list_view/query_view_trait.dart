import 'package:takkan_client/part/trait.dart';

class ReadQueryViewTrait extends ReadTrait {
  const ReadQueryViewTrait({
    super.showCaption = true,
    required super.alignment,
  });
}

class EditQueryViewTrait extends EditTrait {
  EditQueryViewTrait({
    super.showCaption = true,
    required super.alignment,
  });
}

class QueryViewTrait extends Trait<ReadQueryViewTrait, EditQueryViewTrait> {
  QueryViewTrait(
      {required super.readTrait, super.editTrait, required super.partName});
}
