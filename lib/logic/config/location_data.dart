import 'package:shared_preferences/shared_preferences.dart';

class LocationData {
  getLocationUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get("locationUser");
  }
}