import 'package:flutter/material.dart';
import './services/api_service.dart';

class MovieDetails extends StatefulWidget {
  final int movieId;

  const MovieDetails({super.key, required this.movieId});

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late Future<Map<String, dynamic>> _movieDetails;
  late Future<List<dynamic>> _movieCredits;
  late Future<List<dynamic>> _movieTrailers;

  @override
  void initState() {
    super.initState();
    _movieDetails = ApiService().fetchMovieDetails(widget.movieId);
    _movieCredits = ApiService().fetchMovieCredits(widget.movieId);
    _movieTrailers = ApiService().fetchMovieVideos(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la película'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(  // Hacemos que la pantalla sea desplazable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FutureBuilder para los detalles de la película
              FutureBuilder<Map<String, dynamic>>(
                future: _movieDetails,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error al cargar los detalles: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No se encontraron detalles.'));
                  }

                  final movie = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250.0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        movie['title'],
                        style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fecha de estreno: ${movie['release_date']}',
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Descripción:',
                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie['overview'] ?? 'No disponible.',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              // FutureBuilder para los créditos de la película
              FutureBuilder<List<dynamic>>(
                future: _movieCredits,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error al cargar los créditos: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No se encontraron créditos.'));
                  }

                  final credits = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Créditos:',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: credits.length,
                          itemBuilder: (context, index) {
                            final credit = credits[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      'https://image.tmdb.org/t/p/w500${credit['profile_path']}',
                                    ),
                                    radius: 40.0,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    credit['name'],
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              // FutureBuilder para los trailers
              FutureBuilder<List<dynamic>>(
                future: _movieTrailers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error al cargar los trailers: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No se encontraron trailers.'));
                  }

                  final trailers = snapshot.data!;
                  if (trailers.isEmpty) {
                    return const Center(child: Text('No hay trailers disponibles.'));
                  }

                  final trailerKey = trailers[0]['key'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trailer:',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          // Navegar a YouTube
                          final url = 'https://www.youtube.com/watch?v=$trailerKey';
                          // Lanza el navegador para ver el trailer
                        },
                        child: Container(
                          height: 200.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://img.youtube.com/vi/$trailerKey/hqdefault.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
