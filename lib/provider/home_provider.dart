import 'package:calendar_every/model/user_model.dart';
import 'package:calendar_every/toast/show_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  int _pageIndex = 0;
  UserModel _userModel = UserModel('', '', '');
  bool _autoLogin = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  TextEditingController get emailController => _emailController;

  TextEditingController get pwdController => _pwdController;

  int get pageIndex => _pageIndex;

  bool get autoLogin => _autoLogin;
  UserModel get userModel => _userModel;
  void changePageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  Future<void> autoLoginCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('auto_info') == null) {
      _autoLogin = false;
    } else {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: prefs.getStringList('auto_info')![0],
          password: prefs.getStringList('auto_info')![1])
          .then((value) async{
        await FirebaseFirestore.instance
            .collection(prefs.getStringList('auto_info')![0])
            .doc('info')
            .get()
            .then((value) {
         _userModel = UserModel(value.data()!['email'], value.data()!['nickname'],
              value.data()!['image']);
        });
      });
      _autoLogin = true;
      notifyListeners();
    }
   // notifyListeners();
  }

  Future<void> loginFirebase() async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _pwdController.text.trim())
        .then((value) async{
     await FirebaseFirestore.instance
          .collection(emailController.text.trim())
          .doc('info')
          .get()
          .then((value) {
        UserModel(value.data()!['email'], value.data()!['nickname'],
            value.data()!['image']);
      });
     SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setStringList('auto_info', [_emailController.text.trim(),_pwdController.text.trim()]);
     _autoLogin = true;
     notifyListeners();
    }).catchError((e) {
      showToast('로그인 실패');
    });
    //notifyListeners();
  }
}
