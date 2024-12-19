String baseUrl = "http://192.168.249.135:3000";

//auth
String register = "$baseUrl/users/register";
String login = "$baseUrl/users/login";

//genre
String getGenre = "$baseUrl/genre/get";
String insertGenre = "$baseUrl/genre/insert";
String deleteGenre = "$baseUrl/genre/delete/";
String editGenre = "$baseUrl/genre/edit/";

//movie
String imageUrl = '$baseUrl/img/movie/';
String getMovie = "$baseUrl/movie/get";
String insertMovie = "$baseUrl/movie/insert";
String deleteMovie = "$baseUrl/movie/delete/";
String editMovie = "$baseUrl/movie/edit/";

//transaction
String getTransactionALL = "$baseUrl/transaction/get";
String getTransactionbyID = "$baseUrl/transaction/get/:id";
String insertTransaction = "$baseUrl/transaction/insert";
String confirmTransaction = "$baseUrl/transaction/confirm-transaction/:id";
