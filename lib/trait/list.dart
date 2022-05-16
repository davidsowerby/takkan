import 'package:flutter/widgets.dart';
import 'package:takkan_client/trait/trait_library.dart';

class ListViewTrait extends Trait {
  const ListViewTrait({
    required AlignmentGeometry alignment,
  }) : super(alignment: alignment);
}

class ListViewReadTrait extends ListViewTrait {
  const ListViewReadTrait({
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
  }) : super(alignment: alignment);
}

class ListViewEditTrait extends ListViewTrait {
  const ListViewEditTrait({
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
  }) : super(alignment: alignment);
}

class ListItemReadTrait extends Trait {
  const ListItemReadTrait({
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
  }) : super(alignment: alignment);
}

class ListItemEditTrait extends Trait {
  const ListItemEditTrait({
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
  }) : super(alignment: alignment);
}
