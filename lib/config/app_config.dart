class AppConfig {
  static bool isProd = false;

  static String get baseUrl {
    if (isProd) {
      return 'https://backend-strapi-gh6q.onrender.com';
    } else {
      return 'http://localhost:1337';
    }
  }
}