import 'package:precept_client/trait/traitLibrary.dart';

class QueryViewTrait extends Trait {
  const QueryViewTrait();

  @override
  Type get viewDataType => List;
}

class QueryViewReadTrait extends QueryViewTrait {
  const QueryViewReadTrait();
}

class QueryViewEditTrait extends QueryViewTrait {
  const QueryViewEditTrait();


}

class QueryItemReadTrait extends Trait {
  const QueryItemReadTrait();

  @override
  Type get viewDataType => Object;
}

class QueryItemEditTrait extends Trait {
  const QueryItemEditTrait();

  @override
  Type get viewDataType => Object;
}
