import 'package:flutter/material.dart';
import 'package:recce/components/loading_widget.dart';
import 'package:recce/configs/color/color.dart';
import 'package:recce/services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashServices _splashServices = SplashServices();

  @override
    void initState() {
      super.initState();
     _splashServices.isLogin(context);
    }
  @override
  Widget build(BuildContext context) {
    return  const SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
                 SizedBox(height: 300,),
              Text("RECEE 17000ft Foundation",style: TextStyle(color:AppColors.primary,fontSize: 25),),

            SizedBox(height: 100,),
              LoadingWidget(),
               
              //TextButton(child: const Text('Go to Home'),onPressed:(){ Navigator.pushNamed(context, RoutesName.homeScreen);},),
            ],
          ),
        ),
      ),
    );
  }
}