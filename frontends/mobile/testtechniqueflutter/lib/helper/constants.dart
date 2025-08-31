class Constants {
  // Base URL du serveur
  // static const String URL = "http://192.168.2.103";
  static const String URL = "http://195.26.241.68";

  // Préfixe API (évite de le répéter pour chaque microservice)
  static const String API_PREFIX = "/api/v1";

  // Microservices URLs
  static const BASE_URL_MICROCERVICE_USER = "$URL:9000$API_PREFIX";
  static const BASE_URL_MICROCERVICE_CONTRAT = "$URL:9001$API_PREFIX";
  static const BASE_URL_MICROCERVICE_EVENT = "$URL:9002$API_PREFIX";
}
