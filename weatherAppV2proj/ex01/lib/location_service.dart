import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationService {
  static Future<String> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return '位置情報サービスが無効です。';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return '位置情報の権限が拒否されました';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return '位置情報の権限が永久に拒否されました。権限をリクエストすることができません。';
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return await getCityName(position.latitude, position.longitude);
  }

  static Future<String> getCityName(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json&zoom=10');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['display_name'] != null) {
        return data['display_name'];
      }
    }
    return '都市名が見つかりませんでした';
  }

  static Future<List<String>> getSuggestions(String query) async {
    final url = Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search?name=$query&count=10&language=en&format=json');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null) {
        List<String> suggestions = [];
        for (var result in data['results']) {
          final city =
              await getCityName(result['latitude'], result['longitude']);
          suggestions.add(city);
        }
        return suggestions;
      }
    }
    return [];
  }
}
