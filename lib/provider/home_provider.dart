import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  int _pageIndex = 0;
  bool _autoLogin = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get pwdController => _pwdController;
  int get pageIndex => _pageIndex;
  bool get autoLogin => _autoLogin;

  void changePageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  Future<void> autoLoginCheck() async {
    if (FirebaseAuth.instance.currentUser == null) {
      _autoLogin = false;
    } else {
      _autoLogin = true;
    }
    notifyListeners();
  }
}
