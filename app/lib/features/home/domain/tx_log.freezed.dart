// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tx_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TxLog _$TxLogFromJson(Map<String, dynamic> json) {
  return _TransactionLog.fromJson(json);
}

/// @nodoc
mixin _$TxLog {
  String get address => throw _privateConstructorUsedError;
  List<String> get topics => throw _privateConstructorUsedError;
  String get data => throw _privateConstructorUsedError;
  String get blockNumber => throw _privateConstructorUsedError;
  String get blockHash => throw _privateConstructorUsedError;
  String get timeStamp => throw _privateConstructorUsedError;
  String get gasPrice => throw _privateConstructorUsedError;
  String get gasUsed => throw _privateConstructorUsedError;
  String get logIndex => throw _privateConstructorUsedError;
  String get transactionHash => throw _privateConstructorUsedError;
  String get transactionIndex => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TxLogCopyWith<TxLog> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TxLogCopyWith<$Res> {
  factory $TxLogCopyWith(TxLog value, $Res Function(TxLog) then) =
      _$TxLogCopyWithImpl<$Res, TxLog>;
  @useResult
  $Res call(
      {String address,
      List<String> topics,
      String data,
      String blockNumber,
      String blockHash,
      String timeStamp,
      String gasPrice,
      String gasUsed,
      String logIndex,
      String transactionHash,
      String transactionIndex});
}

/// @nodoc
class _$TxLogCopyWithImpl<$Res, $Val extends TxLog>
    implements $TxLogCopyWith<$Res> {
  _$TxLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? topics = null,
    Object? data = null,
    Object? blockNumber = null,
    Object? blockHash = null,
    Object? timeStamp = null,
    Object? gasPrice = null,
    Object? gasUsed = null,
    Object? logIndex = null,
    Object? transactionHash = null,
    Object? transactionIndex = null,
  }) {
    return _then(_value.copyWith(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      topics: null == topics
          ? _value.topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      blockNumber: null == blockNumber
          ? _value.blockNumber
          : blockNumber // ignore: cast_nullable_to_non_nullable
              as String,
      blockHash: null == blockHash
          ? _value.blockHash
          : blockHash // ignore: cast_nullable_to_non_nullable
              as String,
      timeStamp: null == timeStamp
          ? _value.timeStamp
          : timeStamp // ignore: cast_nullable_to_non_nullable
              as String,
      gasPrice: null == gasPrice
          ? _value.gasPrice
          : gasPrice // ignore: cast_nullable_to_non_nullable
              as String,
      gasUsed: null == gasUsed
          ? _value.gasUsed
          : gasUsed // ignore: cast_nullable_to_non_nullable
              as String,
      logIndex: null == logIndex
          ? _value.logIndex
          : logIndex // ignore: cast_nullable_to_non_nullable
              as String,
      transactionHash: null == transactionHash
          ? _value.transactionHash
          : transactionHash // ignore: cast_nullable_to_non_nullable
              as String,
      transactionIndex: null == transactionIndex
          ? _value.transactionIndex
          : transactionIndex // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionLogImplCopyWith<$Res>
    implements $TxLogCopyWith<$Res> {
  factory _$$TransactionLogImplCopyWith(_$TransactionLogImpl value,
          $Res Function(_$TransactionLogImpl) then) =
      __$$TransactionLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String address,
      List<String> topics,
      String data,
      String blockNumber,
      String blockHash,
      String timeStamp,
      String gasPrice,
      String gasUsed,
      String logIndex,
      String transactionHash,
      String transactionIndex});
}

/// @nodoc
class __$$TransactionLogImplCopyWithImpl<$Res>
    extends _$TxLogCopyWithImpl<$Res, _$TransactionLogImpl>
    implements _$$TransactionLogImplCopyWith<$Res> {
  __$$TransactionLogImplCopyWithImpl(
      _$TransactionLogImpl _value, $Res Function(_$TransactionLogImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? topics = null,
    Object? data = null,
    Object? blockNumber = null,
    Object? blockHash = null,
    Object? timeStamp = null,
    Object? gasPrice = null,
    Object? gasUsed = null,
    Object? logIndex = null,
    Object? transactionHash = null,
    Object? transactionIndex = null,
  }) {
    return _then(_$TransactionLogImpl(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      topics: null == topics
          ? _value._topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      blockNumber: null == blockNumber
          ? _value.blockNumber
          : blockNumber // ignore: cast_nullable_to_non_nullable
              as String,
      blockHash: null == blockHash
          ? _value.blockHash
          : blockHash // ignore: cast_nullable_to_non_nullable
              as String,
      timeStamp: null == timeStamp
          ? _value.timeStamp
          : timeStamp // ignore: cast_nullable_to_non_nullable
              as String,
      gasPrice: null == gasPrice
          ? _value.gasPrice
          : gasPrice // ignore: cast_nullable_to_non_nullable
              as String,
      gasUsed: null == gasUsed
          ? _value.gasUsed
          : gasUsed // ignore: cast_nullable_to_non_nullable
              as String,
      logIndex: null == logIndex
          ? _value.logIndex
          : logIndex // ignore: cast_nullable_to_non_nullable
              as String,
      transactionHash: null == transactionHash
          ? _value.transactionHash
          : transactionHash // ignore: cast_nullable_to_non_nullable
              as String,
      transactionIndex: null == transactionIndex
          ? _value.transactionIndex
          : transactionIndex // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionLogImpl implements _TransactionLog {
  const _$TransactionLogImpl(
      {required this.address,
      required final List<String> topics,
      required this.data,
      required this.blockNumber,
      required this.blockHash,
      required this.timeStamp,
      required this.gasPrice,
      required this.gasUsed,
      required this.logIndex,
      required this.transactionHash,
      required this.transactionIndex})
      : _topics = topics;

  factory _$TransactionLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionLogImplFromJson(json);

  @override
  final String address;
  final List<String> _topics;
  @override
  List<String> get topics {
    if (_topics is EqualUnmodifiableListView) return _topics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topics);
  }

  @override
  final String data;
  @override
  final String blockNumber;
  @override
  final String blockHash;
  @override
  final String timeStamp;
  @override
  final String gasPrice;
  @override
  final String gasUsed;
  @override
  final String logIndex;
  @override
  final String transactionHash;
  @override
  final String transactionIndex;

  @override
  String toString() {
    return 'TxLog(address: $address, topics: $topics, data: $data, blockNumber: $blockNumber, blockHash: $blockHash, timeStamp: $timeStamp, gasPrice: $gasPrice, gasUsed: $gasUsed, logIndex: $logIndex, transactionHash: $transactionHash, transactionIndex: $transactionIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionLogImpl &&
            (identical(other.address, address) || other.address == address) &&
            const DeepCollectionEquality().equals(other._topics, _topics) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.blockNumber, blockNumber) ||
                other.blockNumber == blockNumber) &&
            (identical(other.blockHash, blockHash) ||
                other.blockHash == blockHash) &&
            (identical(other.timeStamp, timeStamp) ||
                other.timeStamp == timeStamp) &&
            (identical(other.gasPrice, gasPrice) ||
                other.gasPrice == gasPrice) &&
            (identical(other.gasUsed, gasUsed) || other.gasUsed == gasUsed) &&
            (identical(other.logIndex, logIndex) ||
                other.logIndex == logIndex) &&
            (identical(other.transactionHash, transactionHash) ||
                other.transactionHash == transactionHash) &&
            (identical(other.transactionIndex, transactionIndex) ||
                other.transactionIndex == transactionIndex));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      address,
      const DeepCollectionEquality().hash(_topics),
      data,
      blockNumber,
      blockHash,
      timeStamp,
      gasPrice,
      gasUsed,
      logIndex,
      transactionHash,
      transactionIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionLogImplCopyWith<_$TransactionLogImpl> get copyWith =>
      __$$TransactionLogImplCopyWithImpl<_$TransactionLogImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionLogImplToJson(
      this,
    );
  }
}

abstract class _TransactionLog implements TxLog {
  const factory _TransactionLog(
      {required final String address,
      required final List<String> topics,
      required final String data,
      required final String blockNumber,
      required final String blockHash,
      required final String timeStamp,
      required final String gasPrice,
      required final String gasUsed,
      required final String logIndex,
      required final String transactionHash,
      required final String transactionIndex}) = _$TransactionLogImpl;

  factory _TransactionLog.fromJson(Map<String, dynamic> json) =
      _$TransactionLogImpl.fromJson;

  @override
  String get address;
  @override
  List<String> get topics;
  @override
  String get data;
  @override
  String get blockNumber;
  @override
  String get blockHash;
  @override
  String get timeStamp;
  @override
  String get gasPrice;
  @override
  String get gasUsed;
  @override
  String get logIndex;
  @override
  String get transactionHash;
  @override
  String get transactionIndex;
  @override
  @JsonKey(ignore: true)
  _$$TransactionLogImplCopyWith<_$TransactionLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
