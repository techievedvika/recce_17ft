import 'package:bloc/bloc.dart';
import 'package:recce/blocs/login_state.dart';
import 'package:recce/repository/auth/login_repository.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  String username = '';
  String password = '';

  final LoginRepository _loginRepository = LoginRepository();

  // void login(String username, String password) async {
  //   emit(LoginLoading());
  //   try {
  //     // Simulate a login process
  //     await Future.delayed(Duration(seconds: 2));
  //     if (username == 'user' && password == 'password') {
  //       emit(LoginSuccess());
  //     } else {
  //       emit(LoginFailure('Invalid username or password'));
  //     }
  //   } catch (e) {
  //     emit(LoginFailure('An error occurred'));
  //   }
  // }
    void login(String username,String password ) async {
   emit(LoginLoading());

    try {
      final value = await _loginRepository.loginApi({"username": username, "password": password});
      if (value!.status == 0) {
       emit(LoginFailure(value.message));
      } else if(value.status == 1) {
       emit(LoginSuccess(value.message));
      }
    } catch (error) {
    emit(LoginFailure('Something went wrong'));
    }
  }

  
}
