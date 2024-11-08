import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';
import 'package:tugas_1_biodata/admin/home_admin.dart';
import 'package:tugas_1_biodata/api_service/api.dart';

class Genre extends StatefulWidget {
  const Genre({super.key});
  static String routeName = '/genre';

  @override
  State<Genre> createState() => _GenreState();
}

class _GenreState extends State<Genre> {
  final dio = Dio();
  bool isLoading = false;
  var dataGenre = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, HomeAdmin.routeName);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.library_books,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "Genre",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (context, index) {
                var genre = dataGenre[index];
                return ListTile(
                    title: Text(
                      genre['nama_genre'],
                    ),
                    leading: const Icon(
                      Icons.movie,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.yellow,
                            size: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ],
                    ));
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
      Response response;
      response = await dio.get(getGenre);

      if (response.data['status'] == true) {
        print(response.data['data']);
        dataGenre = response.data['data'];
        print(dataGenre);
      }
    } catch (e) {
      toastification.show(
          context: context,
          title: Text("Terjadi Kesalahan pada Kode"),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
