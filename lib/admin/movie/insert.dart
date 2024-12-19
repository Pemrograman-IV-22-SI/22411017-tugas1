import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';
import 'package:tugas_1_biodata/api_service/api.dart';
import 'package:flutter/services.dart';

class InsertMovie extends StatefulWidget {
  const InsertMovie({super.key});

  @override
  State<InsertMovie> createState() => _InsertMovieState();
}

class _InsertMovieState extends State<InsertMovie> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  double? _rating = 0.0;
  bool isLoading = false;
  final dio = Dio();
  List<dynamic> genres = [];
  int? selectedGenre;

  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _fetchGenres();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();
        setState(() {
          _imageBytes = imageBytes;
        });
      }
    } catch (e) {
      toastification.show(
        context: context,
        title: Text("Gagal memilih gambar: $e"),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.movie),
          SizedBox(width: 8),
          Text(
            "Tambah Movie",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Judul Movie",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: "Harga Movie",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Deskripsi",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Rating",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(
                    index < _rating!.round() ? Icons.star : Icons.star_border,
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
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: selectedGenre,
              items: genres
                  .map<DropdownMenuItem<int>>(
                    (genre) => DropdownMenuItem<int>(
                      value: genre['id_genre'],
                      child: Text(genre['nama_genre']),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedGenre = value;
                });
              },
              decoration: const InputDecoration(
                labelText: "Genre",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                "Pilih Gambar",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            if (_imageBytes != null)
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Image.memory(
                  _imageBytes!,
                  fit: BoxFit.cover,
                ),
              )
            else
              const Text("Belum ada gambar yang dipilih"),
          ],
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
                  String title = _titleController.text;
                  String price = _priceController.text;
                  String description = _descriptionController.text;

                  if (title.isEmpty ||
                      price.isEmpty ||
                      description.isEmpty ||
                      selectedGenre == null ||
                      _imageBytes == null) {
                    toastification.show(
                        context: context,
                        title: const Text("Semua field harus diisi"),
                        type: ToastificationType.warning,
                        style: ToastificationStyle.fillColored);
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    await _addMovie(
                      title,
                      int.parse(price),
                      _rating!,
                      description,
                      selectedGenre!,
                      _imageBytes!,
                    );
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

  Future<void> _fetchGenres() async {
    try {
      Response response = await dio.get(getGenre);
      if (response.statusCode == 200) {
        setState(() {
          genres = response.data['data'];
          selectedGenre = genres.isNotEmpty ? genres.first['id_genre'] : null;
        });
      }
    } catch (e) {
      toastification.show(
          context: context,
          title: const Text("Gagal memuat daftar genre"),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored);
    }
  }

  Future<void> _addMovie(
    String title,
    int price,
    double rating,
    String description,
    int genreId,
    Uint8List imageBytes,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'image':
            MultipartFile.fromBytes(imageBytes, filename: 'movie_image.jpg'),
        "title": title,
        "price": price,
        "rating": rating,
        "description": description,
        "genre": genreId,
      });

      Response response = await dio.post(insertMovie, data: formData);

      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            style: ToastificationStyle.fillColored);
        Navigator.pop(context, true);
      } else {
        toastification.show(
            context: context,
            title: const Text("Gagal Menambahkan Movie"),
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
