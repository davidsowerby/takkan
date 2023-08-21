// ignore_for_file: must_be_immutable

import 'package:json_annotation/json_annotation.dart';

import '../../common/constants.dart';
import '../../common/serial.dart';
import '../../takkan/takkan_element.dart';
import '../../util/walker.dart';

/// By default [readOnly] is inherited from [parent], but can be set individually via the constructor
///
/// [_name] is not set directly, but through [init].  This is to simplify the declaration of schema elements, by allowing a map key to become the name of the schema element.
///
/// The declaration of elements then becomes something like:
///
/// PDocument(fields: {'title':PString()}), rather than:
/// PDocument(fields: [PString(name: 'title')])
///
/// which for longer declarations is a bit more readable
abstract class SchemaElement extends TakkanElement implements Serializable {
  SchemaElement({this.isReadOnly = IsReadOnly.inherited});

  String? _name;

  final IsReadOnly isReadOnly;

  @override
  Map<String, dynamic> toJson();

  @override
  void doInit(InitWalkerParams params) {
    _name = params.name;
    super.doInit(params);
  }

  @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  List<Object?> get props => [...super.props, isReadOnly, _name];

  @JsonKey(includeToJson: false, includeFromJson: false)
  bool get readOnly => _readOnlyState() == IsReadOnly.yes;

  String get name => _name!;

  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  SchemaElement get parent => super.parent as SchemaElement;

  IsReadOnly _readOnlyState() {
    return (isReadOnly == IsReadOnly.inherited)
        ? parent.isReadOnly
        : isReadOnly;
  }

  @override
  String get idAlternative => name;
}