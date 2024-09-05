// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  factory User({
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'admin_email') required String adminEmail,
    @JsonKey(name: 'role_name') required String roleName,
    @JsonKey(name: 'office_name') required String officeName,
    @JsonKey(name: 'emp_id') required String empId,
    @JsonKey(name: 'version') required String version,
    @JsonKey(name: 'offline_version') required String offlineVersion,
    @JsonKey(name: 'emp_da') required int empDa, // This is an int
    @JsonKey(name: 'onlineTask') required String onlineTask,
    @JsonKey(name: 'offlineTask') required String offlineTask,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
