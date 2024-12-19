import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tugas_1_biodata/admin/home_admin.dart';
import 'package:tugas_1_biodata/api_service/api.dart';
import 'insert.dart';
import 'edit.dart';

class Movie extends StatefulWidget {
  const Movie({super.key});
  static String routeName = '/Movie';

  @override
  State<Movie> createState() => _MovieState();
}

class _MovieState extends State<Movie> {
  final dio = Dio();
  bool isLoading = false;
  var dataMovie = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void deleteMovieResponse(int idMovie) async {
    try {
      setState(() {
        isLoading = true;
      });
      Response response = await dio.delete(deleteMovie + idMovie.toString());

      if (response.data['status'] == true) {
        toastification.show(
          context: context,
          title: Text(response.data['msg']),
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
        );
        getData();
      }
    } catch (e) {
      toastification.show(
        context: context,
        title: const Text("Terjadi Kesalahan pada Kode"),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
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
            const SizedBox(width: 10),
            const Icon(Icons.movie, color: Colors.white),
            const SizedBox(width: 10),
            const Text(
              "Movie",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () async {
                bool? isAdded = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const InsertMovie();
                  },
                );
                if (isAdded == true) {
                  getData();
                }
              },
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2 / 3,
              ),
              itemBuilder: (context, index) {
                var movie = dataMovie[index];
                return MovieCard(
                  idMovie: movie['id_movie'],
                  title: movie['title'],
                  rating: movie['rating'],
                  imageName: movie['image'],
                  price: movie['price'],
                  description: movie['description'],
                  namaGenre: movie['genre_movie_genreTogenre']['nama_genre'],
                  onRefresh: getData,
                  onDelete: deleteMovieResponse,
                );
              },
              itemCount: dataMovie.length,
            ),
    );
  }

  void getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response = await dio.get(getMovie);

      if (response.data['status'] == true) {
        dataMovie = response.data['data'];
        print(dataMovie);
      }
    } catch (e) {
      toastification.show(
          context: context,
          title: const Text("Terjadi Kesalahan pada Kode"),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

class MovieCard extends StatelessWidget {
  final int idMovie;
  final String title;
  final double rating;
  final String imageName;
  final int price;
  final String description;
  final String namaGenre;
  final VoidCallback onRefresh;
  final Function(int) onDelete;

  const MovieCard({
    super.key,
    required this.idMovie,
    required this.title,
    required this.rating,
    required this.imageName,
    required this.price,
    required this.description,
    required this.namaGenre,
    required this.onRefresh,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    const String baseUrl = "http://localhost:3000/img/movie/";
    final String imageUrl = baseUrl + imageName;

    return GestureDetector(
      onTap: () {
        _showMovieDetails(context);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image,
                        size: 50, color: Colors.grey);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < rating.round() ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    namaGenre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Rp. ${price.toString()}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMovieDetails(BuildContext context) {
    const String baseUrl = "http://localhost:3000/img/movie/";
    final String imageUrl = baseUrl + imageName;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              const Icon(Icons.movie),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
                tooltip: "Tutup",
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: 240,
                    height: 240,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image,
                          size: 100, color: Colors.grey);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Rating: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < rating.round()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Genre: $namaGenre",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Price: Rp. ${price.toString()}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () async {
                        bool? isEdited = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EditMovie(
                              idMovie: idMovie.toString(),
                              namaMovie: title,
                              price: price,
                              rating: rating,
                              description: description,
                            );
                          },
                        );
                        if (isEdited == true) {
                          onRefresh();
                        }
                      },
                      icon: const Icon(Icons.edit, size: 20),
                      tooltip: "Edit",
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          text: 'Anda ingin menghapus movie $title?',
                          confirmBtnText: 'Ya',
                          cancelBtnText: 'Tidak',
                          confirmBtnColor: Colors.red,
                          onConfirmBtnTap: () {
                            Navigator.pop(context);
                            onDelete(idMovie);
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        size: 20,
                      ),
                      tooltip: "Tutup",
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
