// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_schema_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FormjsonModelImpl _$$FormjsonModelImplFromJson(Map<String, dynamic> json) =>
    _$FormjsonModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      collectionJson: json['collection'],
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$$FormjsonModelImplToJson(_$FormjsonModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'collection': instance.collectionJson,
      'created_at': instance.createdAt,
    };
