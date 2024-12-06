import 'package:flutter/material.dart';
import './services/favorites_service.dart';
import './services/api_service.dart';  // Necesario para obtener los detalles de las películas
import './movie_details.dart';

class FavoritesScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

   FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteMovieIds = FavoritesService.getFavorites();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: favoriteMovieIds.isEmpty
          ? const Center(
              child: Text(
                'No tienes películas favoritas.',
                style: TextStyle(color: Colors.white),
              ),
            )
          : FutureBuilder<List<dynamic>>(
              // Usamos FutureBuilder para obtener la información de las películas favoritas desde la API
              future: apiService.fetchMoviesByIds(favoriteMovieIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                } else {
                  final movies = snapshot.data!;
                  return ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          color: Colors.grey[850],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          elevation: 8.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Stack(
                                  children: [
                                    Image.network(
                                      'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 250.0,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  movie['title'],
                                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text(
                                  'Calificación: ${movie['vote_average']}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Eliminar de favoritos
                              IconButton(
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  FavoritesService.toggleFavorite(movie['id']);
                                },
                              ),
                              // Navegar a los detalles de la película
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetails(movieId: movie['id']),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.amber[700]!, Colors.orange[600]!],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  width: double.infinity,
                                  child: const Center(
                                    child: Text(
                                      'Ver Detalles',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
    );
  }
}
