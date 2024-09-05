// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'form_schema_model.freezed.dart';
part 'form_schema_model.g.dart';

@freezed
class FormjsonModel with _$FormjsonModel {
  factory FormjsonModel({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'collection') required dynamic collectionJson,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _FormjsonModel;

  factory FormjsonModel.fromJson(Map<String, dynamic> json) =>
      _$FormjsonModelFromJson(json);
}
