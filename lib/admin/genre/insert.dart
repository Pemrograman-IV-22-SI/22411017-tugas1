import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:tugas_1_biodata/api_service/api.dart';

class InsertGenre extends StatefulWidget {
  const InsertGenre({super.key});

  @override
  State<InsertGenre> createState() => _InsertGenreState();
}

class _InsertGenreState extends State<InsertGenre> {
  final TextEditingController _genreController = TextEditingController();
  bool isLoading = false;
  final dio = Dio();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(
            Icons.library_books,
          ),
          const SizedBox(width: 8),
          const Text(
            "Tambah Genre",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: TextField(
        controller: _genreController,
        decoration: const InputDecoration(
          labelText: "Nama Genre",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Batal"),
        ),
        isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () async {
                  String genreName = _genreController.text;
                  if (genreName.isEmpty) {
                    toastification.show(
                        context: context,
                        title: const Text("Genre tidak boleh kosong"),
                        type: ToastificationType.warning,
                        style: ToastificationStyle.fillColored);
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    await addGenre(genreName);
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text(
                  "Tambah",
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ],
    );
  }

  Future<void> addGenre(String genreName) async {
    try {
      Response response =
          await dio.post(insertGenre, data: {"nama_genre": genreName});

      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            style: ToastificationStyle.fillColored);
        Navigator.pop(context, true);
      } else {
        toastification.show(
            context: context,
            title: const Text("Gagal Menambahkan Genre"),
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored);
      }
    } catch (e) {
      toastification.show(
          context: context,
          title: const Text("Terjadi Kesalahan pada Kode"),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored);
    }
  }
}
