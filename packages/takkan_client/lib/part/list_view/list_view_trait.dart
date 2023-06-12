import 'package:takkan_client/part/trait.dart';

import 'list_view_part.dart';

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
  final TileBuilder tileBuilder;
  ListViewTrait({
    required super.readTrait,
    super.editTrait,
    super.partName = 'ListViewPart',
    required this.tileBuilder,
  });
}
