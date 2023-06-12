import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// [partName] is used by the [Library] to select the appropriate Widget to
/// represent the part. [readTrait] is used to configure the Widget used
/// to represent the read state, while [editTrait] configures the Widget used to
/// represent the edit state.
abstract class Trait<R extends ReadTrait, E extends EditTrait> {
  final String partName;
  final R readTrait;

  final E? editTrait;

  const Trait({required this.readTrait, this.editTrait, required this.partName});
}

class ReadTrait {
  final bool showCaption;
  final AlignmentGeometry alignment;

  const ReadTrait({required this.showCaption, required this.alignment});
}

class EditTrait {
  final bool showCaption;
  final AlignmentGeometry alignment;

  const EditTrait({required this.showCaption, required this.alignment});
}


