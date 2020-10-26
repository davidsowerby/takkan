import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept/common/locale.dart';
import 'package:precept/precept/binding/binding.dart';
import 'package:precept/precept/binding/mapBinding.dart';
import 'package:precept/precept/model/sectionModel.dart';
import 'package:precept/precept/part/stringPart.dart';
import 'package:precept/section/base/sectionBinding.dart';
import 'package:provider/provider.dart';

enum AddressPattern { title, numberStreet, postCode }

class AddressPatterns {
  Map<dynamic, String> get patterns => {
        AddressPattern.numberStreet: "House number/name and street",
        AddressPattern.postCode: "Post code",
      };
}

/// [firstLineKey] and [postCodeKey] enable the use of different captions for those elements
class AddressWidget extends StatelessWidget {
  final Interpolator interpolator;
  final bool showLine2;
  final bool showLine3;
  final bool showLine4;
  final dynamic firstLineKey;
  final dynamic postCodeKey;
  final CrossAxisAlignment crossAxisAlignment;

  AddressWidget({
    Key key,
    this.interpolator,
    this.showLine2 = false,
    this.showLine3 = false,
    this.showLine4 = false,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.firstLineKey = AddressPattern.numberStreet,
    this.postCodeKey = AddressPattern.postCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SectionBinding sectionBinding = Provider.of<SectionBinding>(context);
    final AddressModel model =
        AddressModel(baseBinding: sectionBinding.dataBinding);
    List<Widget> children = List();
    children
        .add(StringPart(binding: model.numberStreet, captionKey: firstLineKey));
    if (showLine2) {
      children.add(StringPart(binding: model.line2));
    }
    if (showLine3) {
      children.add(StringPart(binding: model.line3));
    }
    if (showLine4) {
      children.add(StringPart(binding: model.line4));
    }
    children.add(StringPart(binding: model.postCode, captionKey: postCodeKey));
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}

class AddressModel extends SectionModel {
  final ModelBinding baseBinding;

  AddressModel({@required this.baseBinding})
      : super(
          baseBinding: baseBinding,
          modelProperties: const [],
          modelListProperties: const [],
        );

  StringBinding get numberStreet {
    return baseBinding.stringBinding(property: "numberStreet");
  }

  StringBinding get line2 {
    return baseBinding.stringBinding(property: "line2");
  }

  StringBinding get line3 {
    return baseBinding.stringBinding(property: "line3");
  }

  StringBinding get line4 {
    return baseBinding.stringBinding(property: "line4");
  }

  StringBinding get postCode {
    return baseBinding.stringBinding(property: "postCode");
  }
}
