import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiKey = 'a3b799ab314dbfefe881d0bb6071faae'; // TMDB API Key
const String baseUrl = 'https://api.themoviedb.org/3'; // Base URL de TMDB
const String youtubeApiKey = 'AIzaSyB8CKGR7k7CjyDyLp6vNOPg-BYrQVV9u3s'; // YouTube API Key

class ApiService {
  // Obtener películas populares desde TMDB
  Future<List<dynamic>> fetchMovies() async {
    final url = Uri.parse('$baseUrl/movie/popular?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Error al cargar películas');
    }
  }

  // Obtener detalles de una película desde TMDB
  Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar detalles de la película');
    }
  }

  // Obtener créditos de una película desde TMDB
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

  // Obtener videos de una película desde TMDB (incluidos trailers)
  Future<List<dynamic>> fetchMovieVideos(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/videos?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results']; // Devuelve todos los videos relacionados (incluidos los trailers)
    } else {
      throw Exception('Error al cargar videos');
    }
  }

  // Buscar trailers en YouTube basado en el título de la película
  Future<String?> fetchYouTubeTrailer(String movieTitle) async {
    final query = Uri.encodeComponent('$movieTitle trailer');
    final url = 'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&key=$youtubeApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['items'].isNotEmpty) {
        // Obtiene el primer video de los resultados
        final videoId = data['items'][0]['id']['videoId'];
        return videoId;
      }
    } else {
      throw Exception('Error al buscar el trailer en YouTube');
    }
    return null;
  }
}
