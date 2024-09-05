// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      username: json['username'] as String,
      adminEmail: json['admin_email'] as String,
      roleName: json['role_name'] as String,
      officeName: json['office_name'] as String,
      empId: json['emp_id'] as String,
      version: json['version'] as String,
      offlineVersion: json['offline_version'] as String,
      empDa: (json['emp_da'] as num).toInt(),
      onlineTask: json['onlineTask'] as String,
      offlineTask: json['offlineTask'] as String,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'admin_email': instance.adminEmail,
      'role_name': instance.roleName,
      'office_name': instance.officeName,
      'emp_id': instance.empId,
      'version': instance.version,
      'offline_version': instance.offlineVersion,
      'emp_da': instance.empDa,
      'onlineTask': instance.onlineTask,
      'offlineTask': instance.offlineTask,
    };
