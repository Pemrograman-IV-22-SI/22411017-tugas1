import 'package:flutter/material.dart';
import 'package:tugas_1_biodata/admin/home_admin.dart';
import 'package:tugas_1_biodata/admin/genre/genre.dart';
import 'package:tugas_1_biodata/admin/movie/movie.dart';
import 'package:tugas_1_biodata/admin/transaction/transaction.dart';
import 'package:tugas_1_biodata/login.dart';
import 'package:tugas_1_biodata/register.dart';
import 'package:tugas_1_biodata/users/home_users.dart';
import 'package:tugas_1_biodata/users/genre/genre.dart';
import 'package:tugas_1_biodata/users/movie/movie.dart';
import 'package:tugas_1_biodata/users/transaction/transaction.dart';

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
          GenreAdmin.routeName: (context) => const GenreAdmin(),
          MovieAdmin.routeName: (context) => const MovieAdmin(),
          TransactionAdmin.routeName: (context) => const TransactionAdmin(),
          GenreUsers.routeName: (context) => const GenreUsers(),
          MovieUsers.routeName: (context) => const MovieUsers(),
          TransactionUsers.routeName: (context) => const TransactionUsers(),
        });
  }
}
