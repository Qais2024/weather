import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherServices {
  final String apiKey = "416ce4d9a18f44b69b264641241012";
  final String forecastBaseUrl = 'http://api.weatherapi.com/v1/forecast.json';
  final String searchBaseUrl = 'http://api.weatherapi.com/v1/search.json';

  Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
    final url = "$forecastBaseUrl?key=$apiKey&q=$city&days=1&aqi=no&alerts=no";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load weather");
    }
  }

  Future<Map<String, dynamic>> fetch7dayforecast(String city) async {
    final url = "$forecastBaseUrl?key=$apiKey&q=$city&days=7&aqi=no&alerts=no";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load forecast");
    }
  }

  Future<List<dynamic>?> fetchCitySuggestion(String query) async {
    final url = "$searchBaseUrl?key=$apiKey&q=$query";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
