import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:tugas_1_biodata/api_service/api.dart';

class EditMovie extends StatefulWidget {
  final String idMovie;
  final String namaMovie;
  final int price;
  final double rating;
  final String description;

  const EditMovie({
    Key? key,
    required this.idMovie,
    required this.namaMovie,
    required this.price,
    required this.rating,
    required this.description,
  }) : super(key: key);

  @override
  State<EditMovie> createState() => _EditMovieState();
}

class _EditMovieState extends State<EditMovie> {
  final dio = Dio();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  double? _rating;
  bool isLoading = false;

  List<dynamic> genres = [];
  int? selectedGenre;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.namaMovie;
    _priceController.text = widget.price.toString();
    _descriptionController.text = widget.description;
    _rating = widget.rating;
    _fetchGenres();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.edit),
          SizedBox(width: 8),
          Text(
            "Edit Movie",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                const Text("Rating"),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (index) => IconButton(
                        icon: Icon(
                          index < _rating! ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = index + 1.0;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: selectedGenre,
              items: genres.map((genre) {
                return DropdownMenuItem<int>(
                  value: genre['id_genre'],
                  child: Text(genre['nama_genre']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGenre = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Genre'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
          onPressed: isLoading ? null : _editMovie,
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _fetchGenres() async {
    try {
      Response response = await dio.get(getGenre);
      print("Response data: ${response.data}");
      if (response.statusCode == 200) {
        if (response.data is Map) {
          setState(() {
            genres = response.data['data'];
            selectedGenre = genres.isNotEmpty ? genres.first['id_genre'] : null;
          });
        } else if (response.data is List) {
          setState(() {
            genres = response.data;
            selectedGenre = genres.isNotEmpty ? genres.first['id_genre'] : null;
          });
        }
      }
    } catch (e) {
      print("Error: $e");
      toastification.show(
          context: context,
          title: Text("Gagal memuat daftar genre"),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored);
    }
  }

  void _editMovie() async {
    try {
      setState(() => isLoading = true);
      Response response = await dio.put(
        editMovie + widget.idMovie,
        data: {
          'title': _titleController.text,
          'price': int.parse(_priceController.text),
          'rating': _rating,
          'description': _descriptionController.text,
          'genre': selectedGenre,
        },
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
      print("Error: $e");
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
