import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../toast/show_toast.dart';

class RegisterProvider extends ChangeNotifier {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _pwdCheckController = TextEditingController();
  TextEditingController _nickController = TextEditingController();
  FocusNode _emailNode = FocusNode();
  FocusNode _pwdNode = FocusNode();
  FocusNode _pwdCheckNode = FocusNode();
  FocusNode _nickNode = FocusNode();
  GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _pwdFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _pwdCheckFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _nickFormKey = GlobalKey<FormState>();
  bool _isEmailExists = false;
  bool _isKeyboard = false;

  TextEditingController get emailController => _emailController;

  TextEditingController get pwdController => _pwdController;

  TextEditingController get pwdCheckController => _pwdCheckController;

  TextEditingController get nickController => _nickController;

  FocusNode get emailNode => _emailNode;

  FocusNode get pwdNode => _pwdNode;

  FocusNode get pwdCheckNode => _pwdCheckNode;

  FocusNode get nickNode => _nickNode;

  GlobalKey<FormState> get emailFormKey => _emailFormKey;

  GlobalKey<FormState> get pwdFormKey => _pwdFormKey;

  GlobalKey<FormState> get pwdCheckFormKey => _pwdCheckFormKey;

  GlobalKey<FormState> get nickFormKey => _nickFormKey;

  bool get isEmailExists => _isEmailExists;

  bool get isKeyboard => _isKeyboard;

  void addNodeListener() {
    emailNode.addListener(() async {
      if (!emailNode.hasFocus) {
        emailFormKey.currentState!.validate();
      }
    });
    pwdNode.addListener(() {
      if (!pwdNode.hasFocus) {
        pwdFormKey.currentState!.validate();
      }
    });
    pwdCheckNode.addListener(() {
      if (!pwdCheckNode.hasFocus) {
        pwdCheckFormKey.currentState!.validate();
      }
    });
  }

  Future<void> registerEmail() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: pwdController.text.trim())
        .then((value) {})
        .catchError((e) {
      if (e.code == 'email-already-in-use') {
        _isEmailExists = true;
        emailFormKey.currentState!.validate();
        showToast('이미 등록된 이메일 입니다');

      }
    });
    notifyListeners();
  }
}
