import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_explorer_app/provider/user_provider.dart';
import 'package:user_explorer_app/screens/splash_screen.dart';
import 'package:user_explorer_app/screens/user_list_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'User Explorer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:  SplashScreen(),

      ),
    );
  }
}