import 'package:flutter/material.dart';
import 'package:tugas_1_biodata/admin/genre/genre.dart';
import 'package:tugas_1_biodata/admin/home_admin.dart';
import 'package:tugas_1_biodata/admin/movie/movie.dart';
import 'package:tugas_1_biodata/admin/transaction/transaction.dart';
import 'package:tugas_1_biodata/login.dart';
import 'package:tugas_1_biodata/register.dart';
import 'package:tugas_1_biodata/users/home_users.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MovieApp',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        initialRoute: LoginPage.routeName,
        routes: {
          LoginPage.routeName: (context) => const LoginPage(),
          RegisterPage.routeName: (context) => const RegisterPage(),
          HomeAdmin.routeName: (context) => const HomeAdmin(),
          HomeUsers.routeName: (context) => const HomeUsers(),
          Genre.routeName: (context) => const Genre(),
          Movie.routeName: (context) => const Movie(),
          Transaction.routeName: (context) => const Transaction(),
        });
  }
}
