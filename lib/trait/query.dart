import 'package:flutter/widgets.dart';
import 'package:precept_client/trait/traitLibrary.dart';

class QueryViewTrait extends Trait {
  const QueryViewTrait({
   required AlignmentGeometry alignment,
  }):super(alignment: alignment);


}

class QueryViewReadTrait extends QueryViewTrait {
  const QueryViewReadTrait({
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
  }):super(alignment: alignment);
}

class QueryViewEditTrait extends QueryViewTrait {
  const QueryViewEditTrait({
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
  }):super(alignment: alignment);


}

class QueryItemReadTrait extends Trait {
  const QueryItemReadTrait({
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
  }):super(alignment: alignment);


}

class QueryItemEditTrait extends Trait {
  const QueryItemEditTrait({
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
  }):super(alignment: alignment);


}
