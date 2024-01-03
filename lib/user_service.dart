import 'package:calendar_every/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  static UserService get instance {
    return _instance;
  }

  UserService._internal() {
    // create instance
  }

  UserModel userModel = UserModel('email', 'nickname', 'photoUrl');

  Future<void> initUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('auto_info') == null) {
    } else {
      await FirebaseFirestore.instance
          .collection(prefs.getStringList('auto_info')![0])
          .doc('info')
          .get()
          .then((value) {
        userModel = UserModel(value.data()!['email'], value.data()!['nickname'],
            value.data()!['image']);
      });
    }
  }
}
