import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recce/blocs/login_bloc.dart';
import 'package:recce/blocs/login_cubit.dart';
import 'package:recce/configs/routes/routes.dart';
import 'package:recce/configs/routes/routes_name.dart';

import 'blocs/form_cubit.dart';


void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        // BlocProvider<LoginBloc>(
        //   create: (context) => LoginBloc(),
          

        // ),
        BlocProvider<FormCubit>(
          create: (context) => FormCubit(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(),
        ),
        // Add other Blocs here if needed
      ],
     
        child:  MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: RoutesName.splashScreen,
          onGenerateRoute: Routes.generateRoute));
      }
    
  }
