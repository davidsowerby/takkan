import 'package:takkan_client/part/trait.dart';

class ReadNavButtonTrait extends ReadTrait {
  const ReadNavButtonTrait({
    super.showCaption = true,
    required super.alignment,
  });
}

class EditNavButtonTrait extends EditTrait {
  EditNavButtonTrait({
    super.showCaption = true,
    required super.alignment,
  });
}

class NavButtonTrait extends Trait<ReadNavButtonTrait, EditNavButtonTrait> {
  final double width;
  final double height;

  const NavButtonTrait({
    required super.readTrait,
    super.editTrait,
    super.partName = 'NavButtonPart',
    this.width = 150,
    this.height = 50,
  });
}

class ReadNavButtonSetTrait extends ReadTrait {
  const ReadNavButtonSetTrait({
    super.showCaption = true,
    required super.alignment,
  });
}

class EditNavButtonSetTrait extends EditTrait {
  EditNavButtonSetTrait({
    super.showCaption = true,
    required super.alignment,
  });
}

class NavButtonSetTrait
    extends Trait<ReadNavButtonSetTrait, EditNavButtonSetTrait> {
  final double width;
  final double height;
  const NavButtonSetTrait(
      {required super.readTrait,
      this.width = 250,
      this.height = 200,
      super.editTrait,
      super.partName = 'NavButtonSetPart'});
}
