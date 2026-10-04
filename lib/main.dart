import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/register.dart';

void main() {
  runApp(MyFirstApp()); //runtime
}

//fixed or static, if statefull then dynamic
class MyFirstApp extends StatelessWidget {
  //constructor
  const MyFirstApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return MaterialApp(
      title: "My First Layout App",
      routes: {
        "/login": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
      },
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
