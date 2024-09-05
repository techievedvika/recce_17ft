import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:recce/blocs/login_cubit.dart';
import 'package:recce/blocs/login_state.dart';
import 'package:recce/components/curved_container.dart';
import 'package:recce/components/custom_button.dart';
import 'package:recce/components/custom_textField.dart';
import 'package:recce/configs/color/color.dart';
import 'package:recce/configs/helper/responsive_helper.dart';
import 'package:recce/configs/routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
// class LoginScreen2 extends StatefulWidget {
//   const LoginScreen2({super.key});

//   @override
//   State<LoginScreen2> createState() => _LoginScreen2State();
// }

// class _LoginScreen2State extends State<LoginScreen2> {

//   @override
//   void initState() {
//     super.initState();
//     _checkLoginState();
//   }

//   Future<void> _checkLoginState() async {
//     final prefs = await SharedPreferences.getInstance();
//     final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

//     if (isLoggedIn) {
//       // Use Navigator directly if necessary
//       if (context.mounted) {
//         Navigator.pushReplacementNamed(context, RoutesName.test);
//       } else {
//         print('Context is not mounted. Navigation aborted.');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final loginCubit = BlocProvider.of<LoginCubit>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: BlocConsumer<LoginCubit, LoginState>(
//           listener: (context, state) {
//             if (state is LoginSuccess) {
//               _saveLoginState();
//               Navigator.pushReplacementNamed(context, RoutesName.test);
//             }
//             if (state is LoginFailure) {
//               // Optionally handle login failure state here
//             }
//           },
//           builder: (context, state) {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (state is LoginFailure)
//                   Text(
//                     state.message,
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                 TextField(
//                   decoration: const InputDecoration(labelText: 'Username'),
//                   onChanged: (value) => loginCubit.username = value,
//                 ),
//                 TextField(
//                   decoration: const InputDecoration(labelText: 'Password'),
//                   obscureText: true,
//                   onChanged: (value) => loginCubit.password = value,
//                 ),
//                 const SizedBox(height: 20),
//                 if (state is LoginLoading)
//                   const CircularProgressIndicator(),
//                 if (state is! LoginLoading)
//                   ElevatedButton(
//                     onPressed: () {
//                       loginCubit.login(
//                         loginCubit.username,
//                         loginCubit.password,
//                       );
//                     },
//                     child: const Text('Login'),
//                   ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Future<void> _saveLoginState() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isLoggedIn', true);
//   }
// }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  bool? login;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    _checkLoginState(); // Check login state on init
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Use Navigator directly if necessary
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, RoutesName.homeScreen);
      } else {
        print('Context is not mounted. Navigation aborted.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final loginCubit = BlocProvider.of<LoginCubit>(context);

    return Scaffold(
      backgroundColor: AppColors.onPrimary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CurvedContainer(),
            Image.asset(
              'assets/logo.png',
              height: responsive.responsiveValue(
                  small: 60.0, medium: 80.0, large: 100.0),
              width: responsive.responsiveValue(
                  small: 150.0, medium: 200.0, large: 250.0),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Login',
                  style: AppStyles.heading1(context, AppColors.onBackground),
                ),
              ),
            ),
            SizedBox(
              height: responsive.responsiveValue(
                  small: 20.0, medium: 30.0, large: 40.0),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                if (state is LoginSuccess) {
                  _saveLoginState();
                  Navigator.pushReplacementNamed(
                      context, RoutesName.homeScreen);
                }

                if (state is LoginLoading) {
                  const CircularProgressIndicator();
                }
              }, builder: (context, state) {
                return Form(
                  key: loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextFormField(
                        textController: usernameController,
                        textInputType: TextInputType.text,
                        prefixIcon: Icons.phone,
                        hintText: 'Username',
                        labelText: 'Enter your username',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                        onChanged: (value) => loginCubit.username = value,
                      ),
                      SizedBox(
                        height: responsive.responsiveValue(
                            small: 30.0, medium: 40.0, large: 20.0),
                      ),
                      CustomTextFormField(
                        textController: passwordController,
                        obscureText: passwordVisible,
                        prefixIcon: Icons.password,
                        hintText: 'Password',
                        labelText: 'Enter your password',
                        suffixIcon: IconButton(
                          icon: Icon(passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        onChanged: (value) => loginCubit.password = value,
                      ),
                      SizedBox(
                        height: responsive.responsiveValue(
                            small: 20.0, medium: 30.0, large: 20.0),
                      ),
                      if (state is LoginLoading)
                        const Center(child: CircularProgressIndicator()),
                      if (state is LoginFailure)
                        Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (state is! LoginLoading)
                        CustomButton(
                          title: 'Login',
                          onPressedButton: () {
                            if (loginFormKey.currentState!.validate()) {
                              loginCubit.login(
                                loginCubit.username,
                                loginCubit.password,
                              );
                            }
                          },
                        ),
                      SizedBox(
                        height: responsive.responsiveValue(
                            small: 10.0, medium: 20.0, large: 30.0),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }
}
