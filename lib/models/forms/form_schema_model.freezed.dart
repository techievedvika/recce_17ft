// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_schema_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FormjsonModel _$FormjsonModelFromJson(Map<String, dynamic> json) {
  return _FormjsonModel.fromJson(json);
}

/// @nodoc
mixin _$FormjsonModel {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'collection')
  dynamic get collectionJson => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FormjsonModelCopyWith<FormjsonModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FormjsonModelCopyWith<$Res> {
  factory $FormjsonModelCopyWith(
          FormjsonModel value, $Res Function(FormjsonModel) then) =
      _$FormjsonModelCopyWithImpl<$Res, FormjsonModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'collection') dynamic collectionJson,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class _$FormjsonModelCopyWithImpl<$Res, $Val extends FormjsonModel>
    implements $FormjsonModelCopyWith<$Res> {
  _$FormjsonModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? collectionJson = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      collectionJson: freezed == collectionJson
          ? _value.collectionJson
          : collectionJson // ignore: cast_nullable_to_non_nullable
              as dynamic,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FormjsonModelImplCopyWith<$Res>
    implements $FormjsonModelCopyWith<$Res> {
  factory _$$FormjsonModelImplCopyWith(
          _$FormjsonModelImpl value, $Res Function(_$FormjsonModelImpl) then) =
      __$$FormjsonModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'collection') dynamic collectionJson,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class __$$FormjsonModelImplCopyWithImpl<$Res>
    extends _$FormjsonModelCopyWithImpl<$Res, _$FormjsonModelImpl>
    implements _$$FormjsonModelImplCopyWith<$Res> {
  __$$FormjsonModelImplCopyWithImpl(
      _$FormjsonModelImpl _value, $Res Function(_$FormjsonModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? collectionJson = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$FormjsonModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      collectionJson: freezed == collectionJson
          ? _value.collectionJson
          : collectionJson // ignore: cast_nullable_to_non_nullable
              as dynamic,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FormjsonModelImpl implements _FormjsonModel {
  _$FormjsonModelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'collection') required this.collectionJson,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$FormjsonModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FormjsonModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'collection')
  final dynamic collectionJson;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  @override
  String toString() {
    return 'FormjsonModel(id: $id, name: $name, collectionJson: $collectionJson, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FormjsonModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other.collectionJson, collectionJson) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name,
      const DeepCollectionEquality().hash(collectionJson), createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FormjsonModelImplCopyWith<_$FormjsonModelImpl> get copyWith =>
      __$$FormjsonModelImplCopyWithImpl<_$FormjsonModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FormjsonModelImplToJson(
      this,
    );
  }
}

abstract class _FormjsonModel implements FormjsonModel {
  factory _FormjsonModel(
          {@JsonKey(name: 'id') required final int id,
          @JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'collection') required final dynamic collectionJson,
          @JsonKey(name: 'created_at') required final String createdAt}) =
      _$FormjsonModelImpl;

  factory _FormjsonModel.fromJson(Map<String, dynamic> json) =
      _$FormjsonModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'collection')
  dynamic get collectionJson;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$FormjsonModelImplCopyWith<_$FormjsonModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
