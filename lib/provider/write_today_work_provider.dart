import 'dart:io';

import 'package:calendar_every/provider/show_calendar_provider.dart';
import 'package:calendar_every/toast/show_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../user_service.dart';

class WriteTodayWorkProvider extends ChangeNotifier {
  final ImagePicker picker = ImagePicker();
  final List<String> _workList = [];
  List<String> _imageUrlList = [];
  int _pageIndex = 0;
  final TextEditingController _textEditingController = TextEditingController();
  List<XFile> _imageList = [];
  final PageController _pageController = PageController();
  bool _isLoading = false;

  List<String> get workList => _workList;

  List<String> get imageUrlList => _imageUrlList;

  int get pageIndex => _pageIndex;

  TextEditingController get textEditingController => _textEditingController;

  List<XFile> get imageList => _imageList;

  PageController get pageController => _pageController;

  bool get isLoading => _isLoading;

  Future<void> stepContinue(context, DateTime date) async {
    if (_pageIndex == 0) {
      if (_workList.isEmpty) {
        showToast('1개 이상 선택해 주세요');
      } else {
        _pageIndex++;
      }
    } else if (_pageIndex == 1) {
      _pageIndex++;
    } else {
      _isLoading = true;
      notifyListeners();
      for (int i = 0; i < imageList.length; i++) {
        await FirebaseStorage.instance
            .ref(
                '${UserService.instance.userModel.email} ${DateFormat('yyyy년MM월dd일').format(date)}/${UserService.instance.userModel.email} ${DateFormat('yyyy년MM월dd일').format(date)} $i')
            .putFile(File(imageList[i].path))
            .then((val) async {
          imageUrlList.add(await val.ref.getDownloadURL());
        });
      }
      //storage에 사진 저장후 사진주소를 받아서 Firestore에 저장
      await FirebaseFirestore.instance
          .collection(UserService.instance.userModel.email)
          .doc('운동기록')
          .collection(DateFormat('yyyy년MM월').format(date))
          .doc(DateFormat('yyyy년MM월dd일').format(date))
          .set({
        'date': date.toLocal(),
        'datetime': (DateFormat('yyyy년MM월dd일').format(date)),
        'title': _workList.toString(),
        'subtitle': textEditingController.text,
        'photoList': imageUrlList
      }).then((value) async {
        await Provider.of<ShowCalendarProvider>(context, listen: false)
            .getFireStore(date, context);
        Navigator.of(context).pop();
      });
    }

    notifyListeners();
  }

  void stepPrevious() {
    _pageIndex--;
    notifyListeners();
  }

  void addWorkList(String work) {
    if (_workList.contains(work)) {
      _workList.remove(work);
    } else {
      _workList.add(work);
    }
    notifyListeners();
  }

  Future<void> selectMultiImage() async {
    await picker.pickMultiImage(maxHeight: 1024, maxWidth: 1024).then((value) {
      if (imageList.length + (value.length) >= 8) {
        showToast('8장 이하로 선택해주세요');
      } else {
        for (int i = 0; i < value.length; i++) {
          _imageList.add(value[i]);
        }
      }
    });
    notifyListeners();
  }

  void resetProvider() {
    _workList.clear();
    _imageUrlList.clear();
    _pageIndex = 0;
    _imageList = [];
    _imageUrlList = [];
    _textEditingController.clear();
    _isLoading = false;
    notifyListeners();
  }
}
