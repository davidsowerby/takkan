import 'package:json_annotation/json_annotation.dart';

part 'list.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class PListReadParticle  {

  PListReadParticle() ;

  factory PListReadParticle.fromJson(Map<String, dynamic> json) =>
      _$PListReadParticleFromJson(json);

  Map<String, dynamic> toJson() => _$PListReadParticleToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PListEditParticle  {

  PListEditParticle() ;

  factory PListEditParticle.fromJson(Map<String, dynamic> json) =>
      _$PListEditParticleFromJson(json);

  Map<String, dynamic> toJson() => _$PListEditParticleToJson(this);
}