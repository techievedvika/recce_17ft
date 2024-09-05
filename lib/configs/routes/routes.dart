
import 'package:flutter/material.dart';
import 'package:recce/views/form.dart';
import 'package:recce/views/home/testhome.dart';

import '../../views/view.dart';

class Routes {
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
     final arguments = settings.arguments as Map<String, dynamic>?;

    

    switch (settings.name) {
      case '/home_screen':
        return MaterialPageRoute(builder: (context) => const HomeScreen());

       case '/form1_screen':
        return MaterialPageRoute(
          builder: (context) => FormScreen(
          mapArgs: arguments!,
          ),
        );

      case '/login_screen':
        return MaterialPageRoute(builder: (context) =>  const LoginScreen());

      case '/splash_screen':
        return MaterialPageRoute(builder: (context) => const SplashScreen());

 case '/testhome':
        return MaterialPageRoute(builder: (context) => const HomeScreenTest());
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('No Route Generated'),
            ),
          ),
        );
    }
  }
}
