import 'package:flutter/material.dart';
import 'package:user_explorer_app/app/app_constant/app_assets.dart';
import 'package:user_explorer_app/screens/user_list_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState

    initMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        spacing: 20.0,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AppAssets.splashLogo),
          Text('User Explorer App',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      )),
    );
  }

  initMethod() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserListScreen()),
      );
    });
  }
}
