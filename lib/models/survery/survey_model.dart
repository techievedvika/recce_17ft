// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
part 'survey_model.freezed.dart';
part 'survey_model.g.dart';


@freezed
class SurveyModel with _$SurveyModel {
  factory SurveyModel({
    @JsonKey(name: 'message') required String message,
    @JsonKey(name: 'status') required int status,
    // User is a nested object
  }) = _SurveyModel;

  factory SurveyModel.fromJson(Map<String, dynamic> json) =>
      _$SurveyModelFromJson(json);
}
