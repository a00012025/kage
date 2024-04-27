// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tx_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TxData _$TxDataFromJson(Map<String, dynamic> json) {
  return _TxData.fromJson(json);
}

/// @nodoc
mixin _$TxData {
  String get counterParty => throw _privateConstructorUsedError;
  double get balanceChange => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TxDataCopyWith<TxData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TxDataCopyWith<$Res> {
  factory $TxDataCopyWith(TxData value, $Res Function(TxData) then) =
      _$TxDataCopyWithImpl<$Res, TxData>;
  @useResult
  $Res call({String counterParty, double balanceChange});
}

/// @nodoc
class _$TxDataCopyWithImpl<$Res, $Val extends TxData>
    implements $TxDataCopyWith<$Res> {
  _$TxDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterParty = null,
    Object? balanceChange = null,
  }) {
    return _then(_value.copyWith(
      counterParty: null == counterParty
          ? _value.counterParty
          : counterParty // ignore: cast_nullable_to_non_nullable
              as String,
      balanceChange: null == balanceChange
          ? _value.balanceChange
          : balanceChange // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TxDataImplCopyWith<$Res> implements $TxDataCopyWith<$Res> {
  factory _$$TxDataImplCopyWith(
          _$TxDataImpl value, $Res Function(_$TxDataImpl) then) =
      __$$TxDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String counterParty, double balanceChange});
}

/// @nodoc
class __$$TxDataImplCopyWithImpl<$Res>
    extends _$TxDataCopyWithImpl<$Res, _$TxDataImpl>
    implements _$$TxDataImplCopyWith<$Res> {
  __$$TxDataImplCopyWithImpl(
      _$TxDataImpl _value, $Res Function(_$TxDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterParty = null,
    Object? balanceChange = null,
  }) {
    return _then(_$TxDataImpl(
      counterParty: null == counterParty
          ? _value.counterParty
          : counterParty // ignore: cast_nullable_to_non_nullable
              as String,
      balanceChange: null == balanceChange
          ? _value.balanceChange
          : balanceChange // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TxDataImpl implements _TxData {
  const _$TxDataImpl({required this.counterParty, required this.balanceChange});

  factory _$TxDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TxDataImplFromJson(json);

  @override
  final String counterParty;
  @override
  final double balanceChange;

  @override
  String toString() {
    return 'TxData(counterParty: $counterParty, balanceChange: $balanceChange)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TxDataImpl &&
            (identical(other.counterParty, counterParty) ||
                other.counterParty == counterParty) &&
            (identical(other.balanceChange, balanceChange) ||
                other.balanceChange == balanceChange));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, counterParty, balanceChange);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TxDataImplCopyWith<_$TxDataImpl> get copyWith =>
      __$$TxDataImplCopyWithImpl<_$TxDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TxDataImplToJson(
      this,
    );
  }
}

abstract class _TxData implements TxData {
  const factory _TxData(
      {required final String counterParty,
      required final double balanceChange}) = _$TxDataImpl;

  factory _TxData.fromJson(Map<String, dynamic> json) = _$TxDataImpl.fromJson;

  @override
  String get counterParty;
  @override
  double get balanceChange;
  @override
  @JsonKey(ignore: true)
  _$$TxDataImplCopyWith<_$TxDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
