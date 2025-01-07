import 'package:http/http.dart' as http;
import 'dart:io';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<http.Response> get(String url) async {
    try {
      final response = await _client.get(Uri.parse(url));
      _handleResponse(response);
      return response;
    } on SocketException {
      throw Exception(
          'No Internet connection. Please check your network settings.');
    } on HttpException {
      throw Exception('Could not find the requested resource.');
    } on FormatException {
      throw Exception('Bad response format.');
    } catch (error) {
      throw Exception('Unexpected error occurred: $error');
    }
  }

  void _handleResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'Error: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
}
