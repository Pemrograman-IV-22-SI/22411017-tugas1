import 'package:flutter/material.dart';
import 'package:tugas_1_biodata/users/genre/genre.dart';
import 'package:tugas_1_biodata/users/movie/movie.dart';
import 'package:tugas_1_biodata/users/transaction/transaction.dart';
import 'package:quickalert/quickalert.dart';

class HomeUsers extends StatefulWidget {
  const HomeUsers({super.key});
  static const routeName = '/home_users';
  @override
  State<HomeUsers> createState() => _HomeUsersState();
}

class _HomeUsersState extends State<HomeUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Row(
          children: <Widget>[
            Icon(
              Icons.home,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Home - Users",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, GenreUsers.routeName),
                  child: Column(children: [
                    buildMenuItem(
                      Icons.library_books,
                      'Genre',
                    ),
                  ]),
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, MovieUsers.routeName),
                  child: Column(children: [
                    buildMenuItem(
                      Icons.movie,
                      'Movie',
                    ),
                  ]),
                ),
              ],
            ),
            const SizedBox(width: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, TransactionUsers.routeName),
                  child: Column(children: [
                    buildMenuItem(
                      Icons.receipt_long,
                      'Transaksi',
                    ),
                  ]),
                ),
                GestureDetector(
                  child: Column(
                    children: [
                      buildMenuItem(
                        Icons.output,
                        'Keluar',
                      ),
                    ],
                  ),
                  onTap: () {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      title: "Konfirmasi",
                      text: "Apakah Anda yakin ingin keluar?",
                      confirmBtnText: "Ya",
                      cancelBtnText: "Tidak",
                      onConfirmBtnTap: () {
                        // exit(0);
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(width: 75),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(IconData iconData, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.teal,
              borderRadius: BorderRadius.circular(7.0),
            ),
            child: Icon(
              iconData,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
