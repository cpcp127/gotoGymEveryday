import 'package:calendar_every/model/user_model.dart';
import 'package:calendar_every/provider/home_provider.dart';
import 'package:calendar_every/toast/show_toast.dart';
import 'package:calendar_every/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> logout(BuildContext context) async {
    context.pop();
    try {
      HomeProvider homeProvider =
          Provider.of<HomeProvider>(context, listen: false);
      _isLoading = true;
      notifyListeners();
      await FirebaseAuth.instance.signOut();
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.clear();
      UserService.instance.userModel = UserModel('', '', '');
      _isLoading = false;
      await homeProvider.autoLoginCheck();
      homeProvider.resetProvider();
      notifyListeners();
    } catch (e) {
      showToast('로그아웃 실패');
      _isLoading = false;
      notifyListeners();
    }
  }
}
