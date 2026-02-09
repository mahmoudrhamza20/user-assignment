class ApiConstants {
  static const String baseUrl = 'https://reqres.in/api';

  // Endpoints
  static const String login = '/login';
  static const String users = '/users';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String apiKey = 'reqres_df4a615a327f496d8a19d5d9b00bde93';

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'x-api-key': apiKey,
  };
}
