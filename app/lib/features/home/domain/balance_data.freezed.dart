// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'balance_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BalanceData _$BalanceDataFromJson(Map<String, dynamic> json) {
  return _BalanceData.fromJson(json);
}

/// @nodoc
mixin _$BalanceData {
  double get usdc => throw _privateConstructorUsedError;
  double get aUsdc => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BalanceDataCopyWith<BalanceData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BalanceDataCopyWith<$Res> {
  factory $BalanceDataCopyWith(
          BalanceData value, $Res Function(BalanceData) then) =
      _$BalanceDataCopyWithImpl<$Res, BalanceData>;
  @useResult
  $Res call({double usdc, double aUsdc});
}

/// @nodoc
class _$BalanceDataCopyWithImpl<$Res, $Val extends BalanceData>
    implements $BalanceDataCopyWith<$Res> {
  _$BalanceDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? usdc = null,
    Object? aUsdc = null,
  }) {
    return _then(_value.copyWith(
      usdc: null == usdc
          ? _value.usdc
          : usdc // ignore: cast_nullable_to_non_nullable
              as double,
      aUsdc: null == aUsdc
          ? _value.aUsdc
          : aUsdc // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BalanceDataImplCopyWith<$Res>
    implements $BalanceDataCopyWith<$Res> {
  factory _$$BalanceDataImplCopyWith(
          _$BalanceDataImpl value, $Res Function(_$BalanceDataImpl) then) =
      __$$BalanceDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double usdc, double aUsdc});
}

/// @nodoc
class __$$BalanceDataImplCopyWithImpl<$Res>
    extends _$BalanceDataCopyWithImpl<$Res, _$BalanceDataImpl>
    implements _$$BalanceDataImplCopyWith<$Res> {
  __$$BalanceDataImplCopyWithImpl(
      _$BalanceDataImpl _value, $Res Function(_$BalanceDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? usdc = null,
    Object? aUsdc = null,
  }) {
    return _then(_$BalanceDataImpl(
      usdc: null == usdc
          ? _value.usdc
          : usdc // ignore: cast_nullable_to_non_nullable
              as double,
      aUsdc: null == aUsdc
          ? _value.aUsdc
          : aUsdc // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BalanceDataImpl extends _BalanceData {
  _$BalanceDataImpl({required this.usdc, required this.aUsdc}) : super._();

  factory _$BalanceDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$BalanceDataImplFromJson(json);

  @override
  final double usdc;
  @override
  final double aUsdc;

  @override
  String toString() {
    return 'BalanceData(usdc: $usdc, aUsdc: $aUsdc)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BalanceDataImpl &&
            (identical(other.usdc, usdc) || other.usdc == usdc) &&
            (identical(other.aUsdc, aUsdc) || other.aUsdc == aUsdc));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, usdc, aUsdc);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BalanceDataImplCopyWith<_$BalanceDataImpl> get copyWith =>
      __$$BalanceDataImplCopyWithImpl<_$BalanceDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BalanceDataImplToJson(
      this,
    );
  }
}

abstract class _BalanceData extends BalanceData {
  factory _BalanceData(
      {required final double usdc,
      required final double aUsdc}) = _$BalanceDataImpl;
  _BalanceData._() : super._();

  factory _BalanceData.fromJson(Map<String, dynamic> json) =
      _$BalanceDataImpl.fromJson;

  @override
  double get usdc;
  @override
  double get aUsdc;
  @override
  @JsonKey(ignore: true)
  _$$BalanceDataImplCopyWith<_$BalanceDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
