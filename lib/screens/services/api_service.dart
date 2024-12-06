import 'dart:convert';
import 'package:http/http.dart' as http;
import '/../constants.dart';

class ApiService {
  Future<List<dynamic>> fetchMovies() async {
    final url = Uri.parse('$baseUrl/movie/top_rated?api_key=$apiKey&page=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Error al cargar películas');
    }
  }

  Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar detalles de la película');
    }
  }

  Future<List<dynamic>> fetchMovieCredits(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['cast'];
    } else {
      throw Exception('Error al cargar los créditos');
    }
  }

  Future<List<dynamic>> fetchMovieVideos(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/videos?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Error al cargar videos');
    }
  }

  // Método para obtener las películas por una lista de IDs
  Future<List<dynamic>> fetchMoviesByIds(List<int> movieIds) async {
    final List<dynamic> movies = [];

    for (var id in movieIds) {
      final url = Uri.parse('$baseUrl/movie/$id?api_key=$apiKey');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        movies.add(json.decode(response.body));
      } else {
        throw Exception('Error al cargar película con ID $id');
      }
    }

    return movies;
  }

  // Método para obtener el trailer de YouTube basado en el título de la película
  Future<String?> fetchYouTubeTrailer(String movieTitle) async {
    // Prepara el título de la película para ser usado en una consulta
    final query = Uri.encodeComponent('$movieTitle trailer');
  
    // Construye la URL de la API de YouTube para buscar el trailer
    final url = 'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&key=$youtubeApiKey';

    // Realiza la solicitud HTTP a YouTube
    final response = await http.get(Uri.parse(url));

    // Verifica si la respuesta es exitosa
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Si se encuentran elementos (videos) en la respuesta
      if (data['items'].isNotEmpty) {
        // Obtiene el videoId del primer video de los resultados de YouTube
        final videoId = data['items'][0]['id']['videoId'];
        return videoId;
      } else {
        // Si no se encuentra un trailer, retorna null
        return null;
      }
    } else {
      // Si ocurre un error en la respuesta, lanza una excepción
      throw Exception('Error al buscar el trailer en YouTube');
    }
  }
}
