// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'string.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

VString _$VStringFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType'] as String?) {
    case 'longerThan':
      return _$StringGreaterThan.fromJson(json);
    case 'shorterThan':
      return _$StringLessThan.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'VString',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
class _$VStringTearOff {
  const _$VStringTearOff();

  _$StringGreaterThan longerThan(int threshold) {
    return _$StringGreaterThan(
      threshold,
    );
  }

  _$StringLessThan shorterThan(int threshold) {
    return _$StringLessThan(
      threshold,
    );
  }

  VString fromJson(Map<String, Object> json) {
    return VString.fromJson(json);
  }
}

/// @nodoc
const $VString = _$VStringTearOff();

/// @nodoc
mixin _$VString {
  int get threshold => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int threshold) longerThan,
    required TResult Function(int threshold) shorterThan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(int threshold)? longerThan,
    TResult Function(int threshold)? shorterThan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int threshold)? longerThan,
    TResult Function(int threshold)? shorterThan,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_$StringGreaterThan value) longerThan,
    required TResult Function(_$StringLessThan value) shorterThan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_$StringGreaterThan value)? longerThan,
    TResult Function(_$StringLessThan value)? shorterThan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_$StringGreaterThan value)? longerThan,
    TResult Function(_$StringLessThan value)? shorterThan,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VStringCopyWith<VString> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VStringCopyWith<$Res> {
  factory $VStringCopyWith(VString value, $Res Function(VString) then) =
      _$VStringCopyWithImpl<$Res>;
  $Res call({int threshold});
}

/// @nodoc
class _$VStringCopyWithImpl<$Res> implements $VStringCopyWith<$Res> {
  _$VStringCopyWithImpl(this._value, this._then);

  final VString _value;
  // ignore: unused_field
  final $Res Function(VString) _then;

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
abstract class _$$StringGreaterThanCopyWith<$Res>
    implements $VStringCopyWith<$Res> {
  factory _$$StringGreaterThanCopyWith(
          _$StringGreaterThan value, $Res Function(_$StringGreaterThan) then) =
      __$$StringGreaterThanCopyWithImpl<$Res>;
  @override
  $Res call({int threshold});
}

/// @nodoc
class __$$StringGreaterThanCopyWithImpl<$Res>
    extends _$VStringCopyWithImpl<$Res>
    implements _$$StringGreaterThanCopyWith<$Res> {
  __$$StringGreaterThanCopyWithImpl(
      _$StringGreaterThan _value, $Res Function(_$StringGreaterThan) _then)
      : super(_value, (v) => _then(v as _$StringGreaterThan));

  @override
  _$StringGreaterThan get _value => super._value as _$StringGreaterThan;

  @override
  $Res call({
    Object? threshold = freezed,
  }) {
    return _then(_$StringGreaterThan(
      threshold == freezed
          ? _value.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_$StringGreaterThan
    with DiagnosticableTreeMixin
    implements _$StringGreaterThan {
  const _$_$StringGreaterThan(this.threshold);

  factory _$_$StringGreaterThan.fromJson(Map<String, dynamic> json) =>
      _$$_$StringGreaterThanFromJson(json);

  @override
  final int threshold;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'VString.longerThan(threshold: $threshold)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'VString.longerThan'))
      ..add(DiagnosticsProperty('threshold', threshold));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _$StringGreaterThan &&
            (identical(other.threshold, threshold) ||
                const DeepCollectionEquality()
                    .equals(other.threshold, threshold)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(threshold);

  @JsonKey(ignore: true)
  @override
  _$$StringGreaterThanCopyWith<_$StringGreaterThan> get copyWith =>
      __$$StringGreaterThanCopyWithImpl<_$StringGreaterThan>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int threshold) longerThan,
    required TResult Function(int threshold) shorterThan,
  }) {
    return longerThan(threshold);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(int threshold)? longerThan,
    TResult Function(int threshold)? shorterThan,
  }) {
    return longerThan?.call(threshold);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int threshold)? longerThan,
    TResult Function(int threshold)? shorterThan,
    required TResult orElse(),
  }) {
    if (longerThan != null) {
      return longerThan(threshold);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_$StringGreaterThan value) longerThan,
    required TResult Function(_$StringLessThan value) shorterThan,
  }) {
    return longerThan(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_$StringGreaterThan value)? longerThan,
    TResult Function(_$StringLessThan value)? shorterThan,
  }) {
    return longerThan?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_$StringGreaterThan value)? longerThan,
    TResult Function(_$StringLessThan value)? shorterThan,
    required TResult orElse(),
  }) {
    if (longerThan != null) {
      return longerThan(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$_$StringGreaterThanToJson(this)..['runtimeType'] = 'longerThan';
  }
}

abstract class _$StringGreaterThan implements VString {
  const factory _$StringGreaterThan(int threshold) = _$_$StringGreaterThan;

  factory _$StringGreaterThan.fromJson(Map<String, dynamic> json) =
      _$_$StringGreaterThan.fromJson;

  @override
  int get threshold => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$StringGreaterThanCopyWith<_$StringGreaterThan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StringLessThanCopyWith<$Res>
    implements $VStringCopyWith<$Res> {
  factory _$$StringLessThanCopyWith(
          _$StringLessThan value, $Res Function(_$StringLessThan) then) =
      __$$StringLessThanCopyWithImpl<$Res>;
  @override
  $Res call({int threshold});
}

/// @nodoc
class __$$StringLessThanCopyWithImpl<$Res> extends _$VStringCopyWithImpl<$Res>
    implements _$$StringLessThanCopyWith<$Res> {
  __$$StringLessThanCopyWithImpl(
      _$StringLessThan _value, $Res Function(_$StringLessThan) _then)
      : super(_value, (v) => _then(v as _$StringLessThan));

  @override
  _$StringLessThan get _value => super._value as _$StringLessThan;

  @override
  $Res call({
    Object? threshold = freezed,
  }) {
    return _then(_$StringLessThan(
      threshold == freezed
          ? _value.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_$StringLessThan
    with DiagnosticableTreeMixin
    implements _$StringLessThan {
  const _$_$StringLessThan(this.threshold);

  factory _$_$StringLessThan.fromJson(Map<String, dynamic> json) =>
      _$$_$StringLessThanFromJson(json);

  @override
  final int threshold;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'VString.shorterThan(threshold: $threshold)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'VString.shorterThan'))
      ..add(DiagnosticsProperty('threshold', threshold));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _$StringLessThan &&
            (identical(other.threshold, threshold) ||
                const DeepCollectionEquality()
                    .equals(other.threshold, threshold)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(threshold);

  @JsonKey(ignore: true)
  @override
  _$$StringLessThanCopyWith<_$StringLessThan> get copyWith =>
      __$$StringLessThanCopyWithImpl<_$StringLessThan>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int threshold) longerThan,
    required TResult Function(int threshold) shorterThan,
  }) {
    return shorterThan(threshold);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(int threshold)? longerThan,
    TResult Function(int threshold)? shorterThan,
  }) {
    return shorterThan?.call(threshold);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int threshold)? longerThan,
    TResult Function(int threshold)? shorterThan,
    required TResult orElse(),
  }) {
    if (shorterThan != null) {
      return shorterThan(threshold);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_$StringGreaterThan value) longerThan,
    required TResult Function(_$StringLessThan value) shorterThan,
  }) {
    return shorterThan(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_$StringGreaterThan value)? longerThan,
    TResult Function(_$StringLessThan value)? shorterThan,
  }) {
    return shorterThan?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_$StringGreaterThan value)? longerThan,
    TResult Function(_$StringLessThan value)? shorterThan,
    required TResult orElse(),
  }) {
    if (shorterThan != null) {
      return shorterThan(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$_$StringLessThanToJson(this)..['runtimeType'] = 'shorterThan';
  }
}

abstract class _$StringLessThan implements VString {
  const factory _$StringLessThan(int threshold) = _$_$StringLessThan;

  factory _$StringLessThan.fromJson(Map<String, dynamic> json) =
      _$_$StringLessThan.fromJson;

  @override
  int get threshold => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$StringLessThanCopyWith<_$StringLessThan> get copyWith =>
      throw _privateConstructorUsedError;
}
