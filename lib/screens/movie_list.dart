import 'package:flutter/material.dart';
import './services/api_service.dart';
import 'movie_details.dart';
import './favorite_movies.dart';  // Importar la pantalla de favoritos
import './services/favorites_service.dart';  // Importar el servicio de favoritos

class MovieList extends StatelessWidget {
  final ApiService apiService = ApiService();

  MovieList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas Populares'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          // Botón de corazón para acceder a la pantalla de favoritos
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),  // Navegar a la pantalla de favoritos
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<dynamic>>(
        future: apiService.fetchMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)),
            );
          } else {
            final movies = snapshot.data!;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];

                // Verificar si hay una imagen de póster
                String imageUrl = movie['poster_path'] != null
                    ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}'
                    : 'https://via.placeholder.com/500x750?text=No+Image';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    color: Colors.grey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 8.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Stack(
                            children: [
                              Hero(
                                tag: 'movie-hero-${movie['id']}',  // Usamos Hero para la transición de la imagen
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 250.0,
                                ),
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
                        // Botón de favoritos
                        IconButton(
                          icon: Icon(
                            FavoritesService.isFavorite(movie['id']) 
                              ? Icons.favorite 
                              : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            FavoritesService.toggleFavorite(movie['id']);  // Agregar o eliminar de favoritos
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
