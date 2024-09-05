part of 'form_cubit.dart';

abstract class FormStates {}

class FormInitial extends FormStates {}

class FormUpLoading extends FormStates {
  double progress = 0.0;
 FormUpLoading({this.progress = 0.0});
  
}
class FormLoading extends FormStates {

 FormLoading();
  
}
class FormLoaded extends FormStates {
 // final List<FormjsonModel> formData;
 final List<Map<String,dynamic>> formData;
  final Position? position;

  FormLoaded(this.formData,this.position);
}

class FormError extends FormStates {
  final String message;

  FormError(this.message);
}

class CurrentLocation extends FormStates {
  final Position currentLocation;
  CurrentLocation(this.currentLocation);
}

class FormSubmitted extends FormStates {
  final SurveyModel formData;

  FormSubmitted(this.formData);
}
