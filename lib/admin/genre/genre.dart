import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tugas_1_biodata/admin/home_admin.dart';
import 'package:tugas_1_biodata/api_service/api.dart';
import 'insert.dart';
import 'edit.dart';

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
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              bool? isAdded = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const InsertGenre();
                },
              );
              if (isAdded == true) {
                getData();
              }
            },
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
                          onPressed: () async {
                            bool? isEdited = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return EditGenre(
                                  idGenre: genre['id_genre'],
                                  namaGenre: genre['nama_genre'],
                                );
                              },
                            );
                            if (isEdited == true) {
                              getData();
                            }
                          },
                          icon: const Icon(Icons.edit,
                              color: Colors.yellow, size: 20),
                        ),
                        IconButton(
                          onPressed: () {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.confirm,
                              text:
                                  'Anda ingin menghapus genre ${genre['nama_genre']}?',
                              confirmBtnText: 'Ya',
                              cancelBtnText: 'Tidak',
                              confirmBtnColor: Colors.red,
                              onConfirmBtnTap: () {
                                deleteGenreResponse(genre['id_genre']);
                              },
                            );
                          },
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

  void deleteGenreResponse(int idGenre) async {
    try {
      setState(() {
        isLoading = true;
      });
      Response response;
      response = await dio.delete(deleteGenre + idGenre.toString());

      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored);
        Navigator.pushNamed(context, Genre.routeName);
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
