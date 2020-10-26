import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/foundation.dart';
import 'package:precept/precept/assembler.dart';
import 'package:precept/precept/model/precept-signin.dart';
import 'package:precept/precept/model/serializers.dart';
import 'package:precept/precept/widget/displayType.dart';
import 'package:precept/section/base/section.dart';

part 'precept.g.dart';

/// A Precept instance represents a specific backend - Back4App, Firebase for example, or perhaps a Rest API for some third party service.
///
/// For larger implementations, it may contain multiple [components].  Each component defines its own [sections], where a Section is just an arbitrary part of a page
/// To enable re-use of sections (for example an AddressSection), they are defined at Component level, but looked up using a [PreceptSection]
///
abstract class Precept implements Built<Precept, PreceptBuilder> {
  BuiltList<PreceptComponent> get components;

  PreceptSignIn get signIn;

  Precept._();

  factory Precept([updates(PreceptBuilder b)]) = _$Precept;

  String toJson() {
    return json.encode(serializers.serializeWith(Precept.serializer, this));
  }

  static Precept fromJson(String jsonString) {
    return serializers.deserializeWith(
        Precept.serializer, json.decode(jsonString));
  }

  static Serializer<Precept> get serializer => _$preceptSerializer;
}

/// A [PreceptComponent] is notional separation within an app.  Simple Apps may contain only one.
///
/// The idea is to gather together the definition of functionally related UI into one place.
/// It contains one or more [sections] which are re-usable parts of a display page - for example an address
/// could be used in multiple ways, but declared only once.
abstract class PreceptComponent
    implements Built<PreceptComponent, PreceptComponentBuilder> {
  String get name;

  BuiltMap<EnumClass, PreceptWidget> get sections;

  BuiltList<PreceptRoute> get routes;

  PreceptComponent._();

  factory PreceptComponent([updates(PreceptComponentBuilder b)]) =
      _$PreceptComponent;

  String toJson() {
    return json
        .encode(serializers.serializeWith(PreceptComponent.serializer, this));
  }

  static PreceptComponent fromJson(String jsonString) {
    return serializers.deserializeWith(
        PreceptComponent.serializer, json.decode(jsonString));
  }

  static Serializer<PreceptComponent> get serializer =>
      _$preceptComponentSerializer;

  List<String> get routeList {
    return [];
  }
}

/// A route is represented by a [path] - simply a String but typically a pseudo URL such as '/user/home'
///
/// Each path displays a [page] - a descriptor which is converted to Widgets by a [PreceptPageAssembler]
abstract class PreceptRoute
    implements Built<PreceptRoute, PreceptRouteBuilder> {
  String get path;

  PreceptPage get page;

  PreceptRoute._();

  factory PreceptRoute([updates(PreceptRouteBuilder b)]) = _$PreceptRoute;

  String toJson() {
    return json
        .encode(serializers.serializeWith(PreceptRoute.serializer, this));
  }

  static PreceptRoute fromJson(String jsonString) {
    return serializers.deserializeWith(
        PreceptRoute.serializer, json.decode(jsonString));
  }

  static Serializer<PreceptRoute> get serializer => _$preceptRouteSerializer;
}

/// Describes a displayed page, using re-usable [sections]
/// This descriptor is converted to a UI [Section] by a [PreceptPageAssembler]
abstract class PreceptPage implements Built<PreceptPage, PreceptPageBuilder> {
  String get title;

  BuiltList<PreceptSection> get sections;

  PreceptPage._();

  factory PreceptPage([updates(PreceptPageBuilder b)]) = _$PreceptPage;

  String toJson() {
    return json.encode(serializers.serializeWith(PreceptPage.serializer, this));
  }

  static PreceptPage fromJson(String jsonString) {
    return serializers.deserializeWith(
        PreceptPage.serializer, json.decode(jsonString));
  }

  static Serializer<PreceptPage> get serializer => _$preceptPageSerializer;
}

abstract class PreceptSection
    implements Built<PreceptSection, PreceptSectionBuilder> {
  EnumClass get sectionKey;

  PreceptSection._();

  factory PreceptSection([updates(PreceptSectionBuilder b)]) = _$PreceptSection;

  String toJson() {
    return json
        .encode(serializers.serializeWith(PreceptSection.serializer, this));
  }

  static PreceptSection fromJson(String jsonString) {
    return serializers.deserializeWith(
        PreceptSection.serializer, json.decode(jsonString));
  }

  static Serializer<PreceptSection> get serializer =>
      _$preceptSectionSerializer;
}

/// Describes a composite widget, to supplement the standard Flutter Widgets.
///
/// It contains 1 or more [fields], which in turn define
/// the properties from which to read / write data, and the widget to display it.
///
/// A [PreceptWidget] may be reused either within a [PreceptComponent] or even
/// between [PreceptComponents].  This is enabled by having each [PreceptComponent]
/// declare its widgets as a map - entries are then looked up from wherever needed.
abstract class PreceptWidget
    implements Built<PreceptWidget, PreceptWidgetBuilder> {
  String get caption;

  BuiltList<PreceptField> get fields;

  PreceptWidget._();

  factory PreceptWidget([updates(PreceptWidgetBuilder b)]) = _$PreceptWidget;

  String toJson() {
    return json
        .encode(serializers.serializeWith(PreceptWidget.serializer, this));
  }

  static PreceptWidget fromJson(String jsonString) {
    return serializers.deserializeWith(
        PreceptWidget.serializer, json.decode(jsonString));
  }

  static Serializer<PreceptWidget> get serializer => _$preceptWidgetSerializer;
}

abstract class PreceptField
    implements Built<PreceptField, PreceptFieldBuilder> {
  String get caption;

  String get toolTip;

  String get property;

  DisplayType get displayType;

  @nullable
  String get section;

  PreceptField._();

  factory PreceptField([updates(PreceptFieldBuilder b)]) = _$PreceptField;

  String toJson() {
    return json
        .encode(serializers.serializeWith(PreceptField.serializer, this));
  }

  static PreceptField fromJson(String jsonString) {
    return serializers.deserializeWith(
        PreceptField.serializer, json.decode(jsonString));
  }

  static Serializer<PreceptField> get serializer => _$preceptFieldSerializer;
}

/// Common interface to load a Precept instance from any source
abstract class PreceptLoader {
  /// Loads the precept JSON file from source.  Implementations must call [Precept.init] after loading
  Future<Precept> load();

  bool get isLoaded;
}

/// Generally only used for testing this implementation of [PreceptLoader] just
/// takes a pre-built [Precept] model
class DirectPreceptLoader implements PreceptLoader {
  final Precept model;
  bool _loaded = false;

  DirectPreceptLoader({@required this.model});

  @override
  Future<Precept> load() {
    _loaded = true;
    return Future.value(model);
  }

  bool get isLoaded => _loaded;
}
