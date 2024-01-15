import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSingleton {
  SharedPreferencesSingleton._internal();

  static final SharedPreferencesSingleton _singleton =
      SharedPreferencesSingleton._internal();

  factory SharedPreferencesSingleton() {
    return _singleton;
  }

  Future clearPreferenceValue() async {
    (await SharedPreferences.getInstance()).clear();
  }

  Future<List<String>?> getAutoLogin() async {
    var pref = await SharedPreferences.getInstance();
    List<String>? list = pref.getStringList('auto_info');
    if (list == null) return null;
    return list;
  }

  Future setAutoInfo(String email, String pwd) async {
    var pref = await SharedPreferences.getInstance();
    pref.setStringList('auto_info', [
      email.trim(),
      pwd.trim(),
    ]);
  }
}
