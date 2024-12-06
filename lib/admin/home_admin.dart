import 'package:flutter/material.dart';
import 'package:tugas_1_biodata/admin/genre/genre.dart';
import 'package:tugas_1_biodata/admin/movie/movie.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});
  static const routeName = '/home_admin';
  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
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
              "Home - Admin",
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
                  onTap: () => Navigator.pushNamed(context, Genre.routeName),
                  child: Column(children: [
                    buildMenuItem(
                      Icons.library_books,
                      'Genre',
                    ),
                  ]),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, Movie.routeName),
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
                  // onTap: () => Navigator.pushNamed(context, Page3.routes),
                  child: Column(children: [
                    buildMenuItem(
                      Icons.receipt_long,
                      'Transaksi',
                    ),
                  ]),
                ),
                GestureDetector(
                  // onTap: () => Navigator.pushNamed(context, Page4.routes),
                  child: Column(children: [
                    buildMenuItem(
                      Icons.output,
                      'Keluar',
                    ),
                  ]),
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
