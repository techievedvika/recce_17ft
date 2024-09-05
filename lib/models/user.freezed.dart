// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  @JsonKey(name: 'username')
  String get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'admin_email')
  String get adminEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_name')
  String get roleName => throw _privateConstructorUsedError;
  @JsonKey(name: 'office_name')
  String get officeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'emp_id')
  String get empId => throw _privateConstructorUsedError;
  @JsonKey(name: 'version')
  String get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'offline_version')
  String get offlineVersion => throw _privateConstructorUsedError;
  @JsonKey(name: 'emp_da')
  int get empDa => throw _privateConstructorUsedError; // This is an int
  @JsonKey(name: 'onlineTask')
  String get onlineTask => throw _privateConstructorUsedError;
  @JsonKey(name: 'offlineTask')
  String get offlineTask => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {@JsonKey(name: 'username') String username,
      @JsonKey(name: 'admin_email') String adminEmail,
      @JsonKey(name: 'role_name') String roleName,
      @JsonKey(name: 'office_name') String officeName,
      @JsonKey(name: 'emp_id') String empId,
      @JsonKey(name: 'version') String version,
      @JsonKey(name: 'offline_version') String offlineVersion,
      @JsonKey(name: 'emp_da') int empDa,
      @JsonKey(name: 'onlineTask') String onlineTask,
      @JsonKey(name: 'offlineTask') String offlineTask});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? adminEmail = null,
    Object? roleName = null,
    Object? officeName = null,
    Object? empId = null,
    Object? version = null,
    Object? offlineVersion = null,
    Object? empDa = null,
    Object? onlineTask = null,
    Object? offlineTask = null,
  }) {
    return _then(_value.copyWith(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      adminEmail: null == adminEmail
          ? _value.adminEmail
          : adminEmail // ignore: cast_nullable_to_non_nullable
              as String,
      roleName: null == roleName
          ? _value.roleName
          : roleName // ignore: cast_nullable_to_non_nullable
              as String,
      officeName: null == officeName
          ? _value.officeName
          : officeName // ignore: cast_nullable_to_non_nullable
              as String,
      empId: null == empId
          ? _value.empId
          : empId // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      offlineVersion: null == offlineVersion
          ? _value.offlineVersion
          : offlineVersion // ignore: cast_nullable_to_non_nullable
              as String,
      empDa: null == empDa
          ? _value.empDa
          : empDa // ignore: cast_nullable_to_non_nullable
              as int,
      onlineTask: null == onlineTask
          ? _value.onlineTask
          : onlineTask // ignore: cast_nullable_to_non_nullable
              as String,
      offlineTask: null == offlineTask
          ? _value.offlineTask
          : offlineTask // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'username') String username,
      @JsonKey(name: 'admin_email') String adminEmail,
      @JsonKey(name: 'role_name') String roleName,
      @JsonKey(name: 'office_name') String officeName,
      @JsonKey(name: 'emp_id') String empId,
      @JsonKey(name: 'version') String version,
      @JsonKey(name: 'offline_version') String offlineVersion,
      @JsonKey(name: 'emp_da') int empDa,
      @JsonKey(name: 'onlineTask') String onlineTask,
      @JsonKey(name: 'offlineTask') String offlineTask});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? adminEmail = null,
    Object? roleName = null,
    Object? officeName = null,
    Object? empId = null,
    Object? version = null,
    Object? offlineVersion = null,
    Object? empDa = null,
    Object? onlineTask = null,
    Object? offlineTask = null,
  }) {
    return _then(_$UserImpl(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      adminEmail: null == adminEmail
          ? _value.adminEmail
          : adminEmail // ignore: cast_nullable_to_non_nullable
              as String,
      roleName: null == roleName
          ? _value.roleName
          : roleName // ignore: cast_nullable_to_non_nullable
              as String,
      officeName: null == officeName
          ? _value.officeName
          : officeName // ignore: cast_nullable_to_non_nullable
              as String,
      empId: null == empId
          ? _value.empId
          : empId // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      offlineVersion: null == offlineVersion
          ? _value.offlineVersion
          : offlineVersion // ignore: cast_nullable_to_non_nullable
              as String,
      empDa: null == empDa
          ? _value.empDa
          : empDa // ignore: cast_nullable_to_non_nullable
              as int,
      onlineTask: null == onlineTask
          ? _value.onlineTask
          : onlineTask // ignore: cast_nullable_to_non_nullable
              as String,
      offlineTask: null == offlineTask
          ? _value.offlineTask
          : offlineTask // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  _$UserImpl(
      {@JsonKey(name: 'username') required this.username,
      @JsonKey(name: 'admin_email') required this.adminEmail,
      @JsonKey(name: 'role_name') required this.roleName,
      @JsonKey(name: 'office_name') required this.officeName,
      @JsonKey(name: 'emp_id') required this.empId,
      @JsonKey(name: 'version') required this.version,
      @JsonKey(name: 'offline_version') required this.offlineVersion,
      @JsonKey(name: 'emp_da') required this.empDa,
      @JsonKey(name: 'onlineTask') required this.onlineTask,
      @JsonKey(name: 'offlineTask') required this.offlineTask});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  @JsonKey(name: 'username')
  final String username;
  @override
  @JsonKey(name: 'admin_email')
  final String adminEmail;
  @override
  @JsonKey(name: 'role_name')
  final String roleName;
  @override
  @JsonKey(name: 'office_name')
  final String officeName;
  @override
  @JsonKey(name: 'emp_id')
  final String empId;
  @override
  @JsonKey(name: 'version')
  final String version;
  @override
  @JsonKey(name: 'offline_version')
  final String offlineVersion;
  @override
  @JsonKey(name: 'emp_da')
  final int empDa;
// This is an int
  @override
  @JsonKey(name: 'onlineTask')
  final String onlineTask;
  @override
  @JsonKey(name: 'offlineTask')
  final String offlineTask;

  @override
  String toString() {
    return 'User(username: $username, adminEmail: $adminEmail, roleName: $roleName, officeName: $officeName, empId: $empId, version: $version, offlineVersion: $offlineVersion, empDa: $empDa, onlineTask: $onlineTask, offlineTask: $offlineTask)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.adminEmail, adminEmail) ||
                other.adminEmail == adminEmail) &&
            (identical(other.roleName, roleName) ||
                other.roleName == roleName) &&
            (identical(other.officeName, officeName) ||
                other.officeName == officeName) &&
            (identical(other.empId, empId) || other.empId == empId) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.offlineVersion, offlineVersion) ||
                other.offlineVersion == offlineVersion) &&
            (identical(other.empDa, empDa) || other.empDa == empDa) &&
            (identical(other.onlineTask, onlineTask) ||
                other.onlineTask == onlineTask) &&
            (identical(other.offlineTask, offlineTask) ||
                other.offlineTask == offlineTask));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      username,
      adminEmail,
      roleName,
      officeName,
      empId,
      version,
      offlineVersion,
      empDa,
      onlineTask,
      offlineTask);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  factory _User(
      {@JsonKey(name: 'username') required final String username,
      @JsonKey(name: 'admin_email') required final String adminEmail,
      @JsonKey(name: 'role_name') required final String roleName,
      @JsonKey(name: 'office_name') required final String officeName,
      @JsonKey(name: 'emp_id') required final String empId,
      @JsonKey(name: 'version') required final String version,
      @JsonKey(name: 'offline_version') required final String offlineVersion,
      @JsonKey(name: 'emp_da') required final int empDa,
      @JsonKey(name: 'onlineTask') required final String onlineTask,
      @JsonKey(name: 'offlineTask')
      required final String offlineTask}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  @JsonKey(name: 'username')
  String get username;
  @override
  @JsonKey(name: 'admin_email')
  String get adminEmail;
  @override
  @JsonKey(name: 'role_name')
  String get roleName;
  @override
  @JsonKey(name: 'office_name')
  String get officeName;
  @override
  @JsonKey(name: 'emp_id')
  String get empId;
  @override
  @JsonKey(name: 'version')
  String get version;
  @override
  @JsonKey(name: 'offline_version')
  String get offlineVersion;
  @override
  @JsonKey(name: 'emp_da')
  int get empDa;
  @override // This is an int
  @JsonKey(name: 'onlineTask')
  String get onlineTask;
  @override
  @JsonKey(name: 'offlineTask')
  String get offlineTask;
  @override
  @JsonKey(ignore: true)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
