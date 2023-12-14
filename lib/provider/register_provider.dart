import 'package:flutter/cupertino.dart';

class RegisterProvider extends ChangeNotifier{

  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _pwdCheckController = TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get pwdController => _pwdController;
  TextEditingController get pwdCheckController => _pwdCheckController;

}