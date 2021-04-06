import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/particle/particle.dart';

part 'list.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PListReadParticle extends PReadParticle {

  PListReadParticle() ;

  factory PListReadParticle.fromJson(Map<String, dynamic> json) =>
      _$PListReadParticleFromJson(json);

  Map<String, dynamic> toJson() => _$PListReadParticleToJson(this);

  @override
  Type get viewDataType => List;
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PListEditParticle extends PEditParticle {

  PListEditParticle() ;

  factory PListEditParticle.fromJson(Map<String, dynamic> json) =>
      _$PListEditParticleFromJson(json);

  Map<String, dynamic> toJson() => _$PListEditParticleToJson(this);

  @override
  Type get viewDataType => List;
}