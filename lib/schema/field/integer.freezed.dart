// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'integer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

VInteger _$VIntegerFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType'] as String?) {
    case 'greaterThan':
      return _$IntegerGreaterThan.fromJson(json);
    case 'lessThan':
      return _$IntegerLessThan.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'VInteger',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
class _$VIntegerTearOff {
  const _$VIntegerTearOff();

  _$IntegerGreaterThan greaterThan(int threshold) {
    return _$IntegerGreaterThan(
      threshold,
    );
  }

  _$IntegerLessThan lessThan(int threshold) {
    return _$IntegerLessThan(
      threshold,
    );
  }

  VInteger fromJson(Map<String, Object> json) {
    return VInteger.fromJson(json);
  }
}

/// @nodoc
const $VInteger = _$VIntegerTearOff();

/// @nodoc
mixin _$VInteger {
  int get threshold => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int threshold) greaterThan,
    required TResult Function(int threshold) lessThan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(int threshold)? greaterThan,
    TResult Function(int threshold)? lessThan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int threshold)? greaterThan,
    TResult Function(int threshold)? lessThan,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_$IntegerGreaterThan value) greaterThan,
    required TResult Function(_$IntegerLessThan value) lessThan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_$IntegerGreaterThan value)? greaterThan,
    TResult Function(_$IntegerLessThan value)? lessThan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_$IntegerGreaterThan value)? greaterThan,
    TResult Function(_$IntegerLessThan value)? lessThan,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VIntegerCopyWith<VInteger> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VIntegerCopyWith<$Res> {
  factory $VIntegerCopyWith(VInteger value, $Res Function(VInteger) then) =
      _$VIntegerCopyWithImpl<$Res>;
  $Res call({int threshold});
}

/// @nodoc
class _$VIntegerCopyWithImpl<$Res> implements $VIntegerCopyWith<$Res> {
  _$VIntegerCopyWithImpl(this._value, this._then);

  final VInteger _value;
  // ignore: unused_field
  final $Res Function(VInteger) _then;

  @override
  $Res call({
    Object? threshold = freezed,
  }) {
    return _then(_value.copyWith(
      threshold: threshold == freezed
          ? _value.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$$IntegerGreaterThanCopyWith<$Res>
    implements $VIntegerCopyWith<$Res> {
  factory _$$IntegerGreaterThanCopyWith(_$IntegerGreaterThan value,
          $Res Function(_$IntegerGreaterThan) then) =
      __$$IntegerGreaterThanCopyWithImpl<$Res>;
  @override
  $Res call({int threshold});
}

/// @nodoc
class __$$IntegerGreaterThanCopyWithImpl<$Res>
    extends _$VIntegerCopyWithImpl<$Res>
    implements _$$IntegerGreaterThanCopyWith<$Res> {
  __$$IntegerGreaterThanCopyWithImpl(
      _$IntegerGreaterThan _value, $Res Function(_$IntegerGreaterThan) _then)
      : super(_value, (v) => _then(v as _$IntegerGreaterThan));

  @override
  _$IntegerGreaterThan get _value => super._value as _$IntegerGreaterThan;

  @override
  $Res call({
    Object? threshold = freezed,
  }) {
    return _then(_$IntegerGreaterThan(
      threshold == freezed
          ? _value.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_$IntegerGreaterThan
    with DiagnosticableTreeMixin
    implements _$IntegerGreaterThan {
  const _$_$IntegerGreaterThan(this.threshold);

  factory _$_$IntegerGreaterThan.fromJson(Map<String, dynamic> json) =>
      _$$_$IntegerGreaterThanFromJson(json);

  @override
  final int threshold;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'VInteger.greaterThan(threshold: $threshold)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'VInteger.greaterThan'))
      ..add(DiagnosticsProperty('threshold', threshold));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _$IntegerGreaterThan &&
            (identical(other.threshold, threshold) ||
                const DeepCollectionEquality()
                    .equals(other.threshold, threshold)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(threshold);

  @JsonKey(ignore: true)
  @override
  _$$IntegerGreaterThanCopyWith<_$IntegerGreaterThan> get copyWith =>
      __$$IntegerGreaterThanCopyWithImpl<_$IntegerGreaterThan>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int threshold) greaterThan,
    required TResult Function(int threshold) lessThan,
  }) {
    return greaterThan(threshold);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(int threshold)? greaterThan,
    TResult Function(int threshold)? lessThan,
  }) {
    return greaterThan?.call(threshold);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int threshold)? greaterThan,
    TResult Function(int threshold)? lessThan,
    required TResult orElse(),
  }) {
    if (greaterThan != null) {
      return greaterThan(threshold);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_$IntegerGreaterThan value) greaterThan,
    required TResult Function(_$IntegerLessThan value) lessThan,
  }) {
    return greaterThan(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_$IntegerGreaterThan value)? greaterThan,
    TResult Function(_$IntegerLessThan value)? lessThan,
  }) {
    return greaterThan?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_$IntegerGreaterThan value)? greaterThan,
    TResult Function(_$IntegerLessThan value)? lessThan,
    required TResult orElse(),
  }) {
    if (greaterThan != null) {
      return greaterThan(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$_$IntegerGreaterThanToJson(this)..['runtimeType'] = 'greaterThan';
  }
}

abstract class _$IntegerGreaterThan implements VInteger {
  const factory _$IntegerGreaterThan(int threshold) = _$_$IntegerGreaterThan;

  factory _$IntegerGreaterThan.fromJson(Map<String, dynamic> json) =
      _$_$IntegerGreaterThan.fromJson;

  @override
  int get threshold => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$IntegerGreaterThanCopyWith<_$IntegerGreaterThan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$IntegerLessThanCopyWith<$Res>
    implements $VIntegerCopyWith<$Res> {
  factory _$$IntegerLessThanCopyWith(
          _$IntegerLessThan value, $Res Function(_$IntegerLessThan) then) =
      __$$IntegerLessThanCopyWithImpl<$Res>;
  @override
  $Res call({int threshold});
}

/// @nodoc
class __$$IntegerLessThanCopyWithImpl<$Res> extends _$VIntegerCopyWithImpl<$Res>
    implements _$$IntegerLessThanCopyWith<$Res> {
  __$$IntegerLessThanCopyWithImpl(
      _$IntegerLessThan _value, $Res Function(_$IntegerLessThan) _then)
      : super(_value, (v) => _then(v as _$IntegerLessThan));

  @override
  _$IntegerLessThan get _value => super._value as _$IntegerLessThan;

  @override
  $Res call({
    Object? threshold = freezed,
  }) {
    return _then(_$IntegerLessThan(
      threshold == freezed
          ? _value.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_$IntegerLessThan
    with DiagnosticableTreeMixin
    implements _$IntegerLessThan {
  const _$_$IntegerLessThan(this.threshold);

  factory _$_$IntegerLessThan.fromJson(Map<String, dynamic> json) =>
      _$$_$IntegerLessThanFromJson(json);

  @override
  final int threshold;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'VInteger.lessThan(threshold: $threshold)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'VInteger.lessThan'))
      ..add(DiagnosticsProperty('threshold', threshold));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _$IntegerLessThan &&
            (identical(other.threshold, threshold) ||
                const DeepCollectionEquality()
                    .equals(other.threshold, threshold)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(threshold);

  @JsonKey(ignore: true)
  @override
  _$$IntegerLessThanCopyWith<_$IntegerLessThan> get copyWith =>
      __$$IntegerLessThanCopyWithImpl<_$IntegerLessThan>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int threshold) greaterThan,
    required TResult Function(int threshold) lessThan,
  }) {
    return lessThan(threshold);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(int threshold)? greaterThan,
    TResult Function(int threshold)? lessThan,
  }) {
    return lessThan?.call(threshold);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int threshold)? greaterThan,
    TResult Function(int threshold)? lessThan,
    required TResult orElse(),
  }) {
    if (lessThan != null) {
      return lessThan(threshold);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_$IntegerGreaterThan value) greaterThan,
    required TResult Function(_$IntegerLessThan value) lessThan,
  }) {
    return lessThan(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_$IntegerGreaterThan value)? greaterThan,
    TResult Function(_$IntegerLessThan value)? lessThan,
  }) {
    return lessThan?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_$IntegerGreaterThan value)? greaterThan,
    TResult Function(_$IntegerLessThan value)? lessThan,
    required TResult orElse(),
  }) {
    if (lessThan != null) {
      return lessThan(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$_$IntegerLessThanToJson(this)..['runtimeType'] = 'lessThan';
  }
}

abstract class _$IntegerLessThan implements VInteger {
  const factory _$IntegerLessThan(int threshold) = _$_$IntegerLessThan;

  factory _$IntegerLessThan.fromJson(Map<String, dynamic> json) =
      _$_$IntegerLessThan.fromJson;

  @override
  int get threshold => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$IntegerLessThanCopyWith<_$IntegerLessThan> get copyWith =>
      throw _privateConstructorUsedError;
}
