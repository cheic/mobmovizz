class Constants {
  // URL de base de l'API TMDB v3
  static const String apiUrl = 'https://api.themoviedb.org/3/';

  // Bearer Token TMDB (API Read Access Token)
  // IMPORTANT: En production, passez le token via --dart-define=TMDB_TOKEN=votre_token
  // Le defaultValue ci-dessous est utilisé uniquement pour le développement
  static const String token = String.fromEnvironment(
    'TMDB_TOKEN',
    defaultValue: '',
  );

  // URL de base pour les images TMDB
  static const String imageUrl = 'https://image.tmdb.org/t/p/w500';

  // Nom de l'application
  static const String mobmovizz = 'MobMovizz';
}
