library built_vehicle;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:precept/precept/model/serializers.dart';

part 'precept-signin.g.dart';

abstract class PreceptSignIn
    implements Built<PreceptSignIn, PreceptSignInBuilder> {

  Backend get backend;
  String get brand;

  PreceptSignIn._();

  factory PreceptSignIn([updates(PreceptSignInBuilder b)]) = _$PreceptSignIn;

  String toJson() {
    return json
        .encode(serializers.serializeWith(PreceptSignIn.serializer, this));
  }

  static PreceptSignIn fromJson(String jsonString) {
    return serializers.deserializeWith(
        PreceptSignIn.serializer, json.decode(jsonString));
  }

  static Serializer<PreceptSignIn> get serializer => _$preceptSignInSerializer;
}

class Backend extends EnumClass {


  static const Backend yes = _$yes;
  static const Backend no = _$no;
  static const Backend maybe = _$maybe;

  const Backend._(String name) : super(name);

  static BuiltSet<Backend> get values => _$values;
  static Backend valueOf(String name) => _$valueOf(name);
  static Serializer<Backend> get serializer => _$backendSerializer;


}


buildOne(){
  var user1 =  PreceptSignIn((b) => b
    ..brand = 'John Smith');
}