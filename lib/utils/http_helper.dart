import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpHelper {
  static String baseUrl = 'https://api.themoviedb.org/3/movie/popular?language=en-US';
  static String movieNightBaseUrl = 'https://movie-night-api.onrender.com';
  static String? apiKey = dotenv.env['TMDB_API_KEY'];

  static startSession(String? deviceId) async {
    var response = await http
        .get(Uri.parse('$movieNightBaseUrl/start-session?device_id=$deviceId'));
    return jsonDecode(response.body);
  }

  static joinSession(String? deviceId, int code) async {
    var response = await http.get(Uri.parse(
        '$movieNightBaseUrl/join-session?device_id=$deviceId&code=$code'));
    return jsonDecode(response.body);
  }

  static fetchMovies() async {
    var response = await http.get(Uri.parse('$baseUrl&api_key=$apiKey'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  static voteMovie(sessionId, movieId, vote) async {
    var response = await http.get(Uri.parse(
        '$movieNightBaseUrl/vote-movie?session_id=$sessionId&movie_id=$movieId&vote=$vote'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  }
}
