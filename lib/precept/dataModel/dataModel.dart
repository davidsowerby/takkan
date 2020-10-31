import 'package:flutter/material.dart';
import 'package:precept/precept/binding/mapBinding.dart';
import 'package:precept/precept/dataModel/documentModel.dart';
import 'package:precept/precept/model/modelDocument.dart';

/// Model implementations are a tree structure of objects matching the tree structure of a document.
/// They are used in conjunction with [Binding] to give read and write access to underlying data
/// A common interface for [SectionModel] and [DocumentModel]
/// [modelProperties] is a list of property names which should be transformed into sub-models
/// [modelListProperties] is a list of property names which should be transformed into lists of sub-models
abstract class DataModel {
  final ModelBinding baseBinding;
  final List<String> modelProperties;
  final List<String> modelListProperties;

  DataModel(
      {@required this.baseBinding,
      @required this.modelProperties,
      @required this.modelListProperties}) {
    /// Reading json is likely to produce Map<dynamic,dynamic> which messes up type inference
    /// So we have to re-create with the correct generics
    final Map<String, dynamic> data = baseBinding.read();
    for (String modelProperty in modelProperties) {
      if (data[modelProperty] == null) {
        data[modelProperty] = Map<String, dynamic>();
      } else {
        data[modelProperty] = Map<String, dynamic>.from(data[modelProperty]);
      }
    }

    /// We need to do the same for a list of models
    for (String modelListProperty in modelListProperties) {
      final List list = data[modelListProperty];
      final newList = List<Map<String, dynamic>>();
      if (list != null) {
        for (Map map in list) {
          newList.add(Map<String, dynamic>.from(map));
        }
        data[modelListProperty] = newList;
      }
    }
  }

  ModelBinding modelBinding({String property}) {
    baseBinding.read()[property] =
        Map<String, dynamic>.from(baseBinding.read()[property]);
    return baseBinding.modelBinding(property: property);
  }
}

/// A model used purely for configuration of a [DocumentPageSection] or [Document], and when used for configuration is read only.
abstract class Configuration extends DataModel {
  Configuration(
      {@required ModelBinding baseBinding,
      @required List<String> modelProperties,
      @required List<String> modelListProperties})
      : super(
          baseBinding: baseBinding,
          modelProperties: modelProperties,
          modelListProperties: modelListProperties,
        );
}

/// A model representing the elements of a document used to display in a [ListTile].
class CollectionTileModel {
  final String titleProperty;
  final String subtitleProperty;
  final TitledDocumentModel model;

  CollectionTileModel(
      {@required this.model,
      this.titleProperty = "title",
      this.subtitleProperty = "subtitle"});

  String get title {
    return model.title.read();
  }

  String get subtitle {
    return model.subtitle.read();
  }

  DocumentId get documentId {
    return model.documentId;
  }
}
