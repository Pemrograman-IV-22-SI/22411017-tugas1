import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:tugas_1_biodata/api_service/api.dart';

class GenreUsers extends StatefulWidget {
  const GenreUsers({super.key});
  static String routeName = '/genre_users';

  @override
  State<GenreUsers> createState() => _GenreUsersState();
}

class _GenreUsersState extends State<GenreUsers> {
  final dio = Dio();
  bool isLoading = false;
  var dataGenre = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Row(
          children: const <Widget>[
            Icon(Icons.library_books, color: Colors.white),
            SizedBox(width: 10),
            Text("Genre", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (context, index) {
                var genre = dataGenre[index];
                return ListTile(
                  title: Text(
                    genre['nama_genre'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: const Icon(Icons.movie),
                );
              },
              itemCount: dataGenre.length,
            ),
    );
  }

  void getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response = await dio.get(getGenre);

      if (response.data['status'] == true) {
        dataGenre = response.data['data'];
      }
    } catch (e) {
      toastification.show(
        context: context,
        title: const Text("Terjadi Kesalahan saat memuat data"),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
