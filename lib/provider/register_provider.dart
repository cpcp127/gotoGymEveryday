import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../toast/show_toast.dart';

class RegisterProvider extends ChangeNotifier {
  final ImagePicker picker = ImagePicker();
  int _pageIndex = 0;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _pwdCheckController = TextEditingController();
  TextEditingController _nickController = TextEditingController();
  List<XFile> _imageList = [];
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

  int get pageIndex => _pageIndex;

  TextEditingController get emailController => _emailController;

  TextEditingController get pwdController => _pwdController;

  TextEditingController get pwdCheckController => _pwdCheckController;

  TextEditingController get nickController => _nickController;

  FocusNode get emailNode => _emailNode;

  FocusNode get pwdNode => _pwdNode;

  List<XFile> get imageList => _imageList;

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
    nickNode.addListener(() async {
      if (!nickNode.hasFocus) {
        nickFormKey.currentState!.validate();
      }
    });
  }

  Future<void> registerEmail(BuildContext context) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: pwdController.text.trim())
        .then((value) {
      FirebaseStorage.instance
          .ref('user_profile_image/${emailController.text.trim()}')
          .putFile(File(_imageList.first.path))
          .then((val) async {
        FirebaseFirestore.instance
            .collection(emailController.text.trim())
            .doc('info')
            .set({
          'email': emailController.text.trim(),
          'nickname': nickController.text.trim(),
          'image': await val.ref.getDownloadURL(),
        });
      });
      context.pop();
      showToast('회원가입에 성공했습니다');
    }).catchError((e) {
      if (e.code == 'email-already-in-use') {
        _isEmailExists = true;
        emailFormKey.currentState!.validate();
        showToast('이미 등록된 이메일 입니다');
      } else {
        showToast('회원가입에 실패했습니다');
      }
    });
    notifyListeners();
  }

  Future<void> selectProfileImage() async {
    await picker
        .pickImage(source: ImageSource.gallery, maxHeight: 1024, maxWidth: 1024)
        .then((value) {
      _imageList.clear();
      _imageList.add(value!);
    });
    notifyListeners();
  }

  void stepPrevious() async {
    _pageIndex = 0;
    notifyListeners();
  }

  void stepNext(context) async {
    if (pageIndex == 0) {
      if (nickFormKey.currentState!.validate() == false || imageList.isEmpty) {
        showToast('닉네임,프로필 사진을 작성해주세요');
      } else {
        _pageIndex = 1;
      }
    } else {
      registerEmail(context);
    }
    notifyListeners();
  }

  void resetProvider() {
    _pageIndex = 0;
    _emailController.clear();
    _pwdController.clear();
    _pwdCheckController.clear();
    _nickController.clear();
    _imageList.clear();
    notifyListeners();
  }
}
