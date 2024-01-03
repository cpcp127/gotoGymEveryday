import 'package:calendar_every/toast/show_toast.dart';
import 'package:calendar_every/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  int _pageIndex = 0;

  bool _autoLogin = false;
  bool _loginLoading = false;
  bool _showPwd = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  TextEditingController get emailController => _emailController;

  TextEditingController get pwdController => _pwdController;

  int get pageIndex => _pageIndex;

  bool get autoLogin => _autoLogin;
  bool get loginLoading => _loginLoading;
  bool get showPwd => _showPwd;

  void resetProvider() {
    _pageIndex = 0;
    _autoLogin = false;
    _loginLoading = false;
    _showPwd = true;
    _emailController.clear();
    _pwdController.clear();
  }

  void changePageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  Future<void> autoLoginCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('auto_info') == null) {
      _autoLogin = false;
      notifyListeners();
    } else {
      await UserService.instance.initUser();
      _autoLogin = true;
      notifyListeners();
    }
    // notifyListeners();
  }

  Future<void> loginFirebase() async {
    FocusManager.instance.primaryFocus?.unfocus();
    _loginLoading = true;
    notifyListeners();
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _pwdController.text.trim())
        .then((value) async {
      await FirebaseFirestore.instance
          .collection(emailController.text.trim())
          .doc('info')
          .get()
          .then((value) async {
        await UserService.instance.initUser();
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList('auto_info',
          [_emailController.text.trim(), _pwdController.text.trim()]);
      await UserService.instance.initUser();
      showToast('${UserService.instance.userModel.nickname}님 오늘도 오운완하세요!');
      _autoLogin = true;
      _loginLoading = false;
      notifyListeners();
    }).catchError((e) {
      showToast('로그인 실패');
      _loginLoading = false;
      notifyListeners();
    });
    //notifyListeners();
  }

  void showObscureText() {
    if (_showPwd == false) {
      _showPwd = true;
    } else {
      _showPwd = false;
    }
    notifyListeners();
  }
}
