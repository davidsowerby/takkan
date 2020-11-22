import 'package:flutter/widgets.dart';
import 'package:precept_client/precept/binding/mapBinding.dart';
import 'package:precept_client/precept/dataModel/dataModel.dart';

/// A child of [DocumentModel] or another [SectionModel].  Sub-class for specific models.  Each complex object should
/// usually have its own model
/// Used by [DocumentPageSection] in conjunction with a [SectionConfiguration], which determines UI layout options and characteristics, typically used to
/// allow a Club some choices in how things are presented.
abstract class SectionModel extends DataModel {
  SectionModel(
      {@required ModelBinding baseBinding,
      @required List<String> modelProperties,
      @required List<String> modelListProperties})
      : super(
          baseBinding: baseBinding,
          modelProperties: modelProperties,
          modelListProperties: modelListProperties,
        );

  ModelBinding childBinding(String propertyName) {
    return baseBinding.modelBinding(property: propertyName);
  }

  /// This is an example for creating a childModel
//  SubModel childModel(String propertyName) {
//    return SubModel(childBinding(propertyName), );
//  }

  /// Override to provide child models
//  model(String propertyName) {
//    return null;
//  }

  /// example:
//    childModel (String propertyName){
//      switch(propertyName){
//        case "name" : return name;
//        case "address" : return address;
//      }
//    }
}
