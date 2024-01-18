import 'package:calendar_every/model/user_model.dart';
import 'package:calendar_every/singleton/shared_prefrence_singleton.dart';
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

  UserModel userModel = UserModel('uid','email', 'nickname', 'photoUrl');

  Future<void> initUser() async {
    await SharedPreferencesSingleton().getAutoLogin().then((value) async {
      if(value==null){

      }else{
        await FirebaseFirestore.instance
            .collection('user')
            .doc(value[0])
            .get()
            .then((value) {
          userModel = UserModel(value.data()!['uid'],value.data()!['email'], value.data()!['nickname'],
              value.data()!['image']);
        });
      }
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getStringList('auto_info'));
    if (prefs.getStringList('auto_info') == null) {
    } else {

    }
  }
}
