import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class RegisterProvider extends ChangeNotifier{

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
  var keyboardVisibilityController = KeyboardVisibilityController();
  void addNodeListener(){
    emailNode.addListener(() async {
      if(!emailNode.hasFocus){
        emailFormKey.currentState!.validate();
      }
    });
    pwdNode.addListener(() {
      if(!pwdNode.hasFocus){
        pwdFormKey.currentState!.validate();
      }
    });
    pwdCheckNode.addListener(() {
      if(!pwdCheckNode.hasFocus){
        pwdCheckFormKey.currentState!.validate();
      }
    });
  }
  void keyboardListener(){

    keyboardVisibilityController.onChange.listen((bool visible) {
      _isKeyboard = visible;
      notifyListeners();

    });
    notifyListeners();
  }
}