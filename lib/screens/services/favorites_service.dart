class FavoritesService {
  static List<int> _favoriteMovieIds = [];  // Lista de IDs de películas favoritas

  // Comprobar si una película está en favoritos
  static bool isFavorite(int movieId) {
    return _favoriteMovieIds.contains(movieId);
  }

  // Agregar o eliminar película de favoritos
  static void toggleFavorite(int movieId) {
    if (isFavorite(movieId)) {
      _favoriteMovieIds.remove(movieId);  // Eliminar de favoritos
    } else {
      _favoriteMovieIds.add(movieId);  // Agregar a favoritos
    }
  }

  // Obtener lista de películas favoritas
  static List<int> getFavorites() {
    return _favoriteMovieIds;
  }
}
