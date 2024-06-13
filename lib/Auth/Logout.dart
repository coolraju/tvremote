import 'package:shared_preferences/shared_preferences.dart';

class Logout {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> logout() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove('token');
    prefs.remove('email');
    prefs.remove('firstname');
    prefs.remove('lastname');
  }
}
