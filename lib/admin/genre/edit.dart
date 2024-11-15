import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:tugas_1_biodata/api_service/api.dart';

class EditGenre extends StatefulWidget {
  final int idGenre;
  final String namaGenre;

  const EditGenre({Key? key, required this.idGenre, required this.namaGenre})
      : super(key: key);

  @override
  State<EditGenre> createState() => _EditGenreState();
}

class _EditGenreState extends State<EditGenre> {
  final dio = Dio();
  final TextEditingController _genreController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _genreController.text = widget.namaGenre;
  }

  @override
  void dispose() {
    _genreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.edit),
          const SizedBox(width: 8),
          const Text(
            "Edit Genre",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: TextField(
        controller: _genreController,
        decoration: const InputDecoration(labelText: 'Nama Genre'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
          onPressed: isLoading ? null : _editGenre,
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Simpan", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _editGenre() async {
    try {
      setState(() => isLoading = true);
      Response response = await dio.put(
        editGenre + widget.idGenre.toString(),
        data: {'nama_genre': _genreController.text},
      );
      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored);
        Navigator.pop(context, true);
      }
    } catch (e) {
      toastification.show(
          context: context,
          title: Text("Terjadi Kesalahan"),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored);
    } finally {
      setState(() => isLoading = false);
    }
  }
}
