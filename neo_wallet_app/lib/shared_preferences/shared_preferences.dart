import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  //no one this propertyes it is used

  static final UserPreferences _instancia = new UserPreferences._internal();

  factory UserPreferences() {
    return _instancia;
  }

  UserPreferences._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  String get loginEmail {
    return _prefs.getString('loginEmail') ?? '';
  }

  set loginEmail(String value) {
    _prefs.setString('loginEmail', value);
  }

  /* int get genero {
    return _prefs.getInt('genero') ?? 1;
  }

  set genero(int value) {
    _prefs.setInt('genero', value);
  } */
}
