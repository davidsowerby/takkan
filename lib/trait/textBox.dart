import 'package:precept_client/trait/traitLibrary.dart';

class TextBoxTrait extends Trait{

  TextBoxTrait({bool showCaption=true, String? caption}): super(showCaption: showCaption);

  @override
  Type get viewDataType => String;
}