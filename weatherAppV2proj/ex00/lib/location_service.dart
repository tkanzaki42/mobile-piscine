import 'package:geolocator/geolocator.dart';

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
    return '緯度: ${position.latitude}, 経度: ${position.longitude}';
  }
}
