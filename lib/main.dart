// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/splash.dart';
import 'screens/forgot_password.dart';
import 'screens/home.dart';
import 'screens/bookcatalog.dart';
import 'screens/mylibrary.dart';
import 'screens/borrowbook.dart';
import 'screens/bookreserve.dart';
import 'screens/cart.dart';
import 'screens/myorders.dart';
import 'screens/orderdetails.dart';
import 'screens/profile.dart';
import 'data/mock_db.dart';

void main() {
  runApp(const MyFirstApp());
}

class MyFirstApp extends StatelessWidget {
  const MyFirstApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My First Layout App",
      routes: {
        "/login": (context) => const LoginPage(),
        "/register": (context) => const RegisterPage(),
        "/splash": (context) => const SplashScreen(),
        "/forgot_password": (context) => const ForgotPasswordPage(),
        "/home": (context) => const HomePage(),
        "/profile": (context) => const ProfilePage(),
        "/bookcatalog": (context) => const BookCatalogPage(),
        "/mylibrary": (context) => const MyLibraryPage(),
        // "/borrowbook": (context) => const BorrowBookPage(),
        // "/bookreserve": (context) => const BookReservePage(),
        "/cart": (context) => const CartPage(),
        "/myorders": (context) => const MyOrdersPage(),
        "/orderdetails": (context) =>
            OrderDetailsPage(order: MockDatabase.orders.first),
      },
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
