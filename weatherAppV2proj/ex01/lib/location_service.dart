import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationService {
  static Future<String> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 位置情報サービスが有効かどうか
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

    // ここに到達した場合、権限が付与されており、デバイスの位置情報にアクセスできます。
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return await getCityName(position.latitude, position.longitude);
  }

  static Future<String> getCityName(double latitude, double longitude) async {
    final apiKey = 'AIzaSyA9v4DCv3P-r8Omlh7ESXCUrpV-NZIO6Lc';  // ここにGoogle APIキーを入れてください
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        for (var component in data['results'][0]['address_components']) {
          if (component['types'].contains('locality')) {
            return component['long_name'];
          }
        }
      }
    }
    return '都市名が見つかりませんでした';
  }
}
