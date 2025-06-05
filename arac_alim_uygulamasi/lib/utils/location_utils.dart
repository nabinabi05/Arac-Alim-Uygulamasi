import 'package:geocoding/geocoding.dart';

Future<String> getCityAndDistrict(double latitude, double longitude) async {
  try {
    final placemarks = await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      final city = place.administrativeArea ?? place.locality ?? '';
      final district = place.subAdministrativeArea ?? '';
      return "$city${district.isNotEmpty ? ' - $district' : ''}";
    }
    return "Bilinmiyor";
  } catch (_) {
    return "Bilinmiyor";
  }
}
