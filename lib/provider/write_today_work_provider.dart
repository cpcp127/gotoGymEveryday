import 'package:calendar_every/provider/home_provider.dart';
import 'package:calendar_every/toast/show_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WriteTodayWorkProvider extends ChangeNotifier {
  final ImagePicker picker = ImagePicker();
  List<String> _workList = [];
  int _pageIndex = 0;
  TextEditingController _textEditingController = TextEditingController();
  List<XFile> _imageList = [];
  PageController _pageController = PageController();

  List<String> get workList => _workList;
  int get pageIndex => _pageIndex;
  TextEditingController get textEditingController => _textEditingController;
  List<XFile> get imageList => _imageList;
  PageController get pageController => _pageController;

  void stepContinue(context) {
    if (_pageIndex == 0) {
      if (_workList.isEmpty) {
        showToast('1개 이상 선택해 주세요');
      } else {
        _pageIndex++;
      }
    } else if (_pageIndex == 1) {
      _pageIndex++;
    } else {
      FirebaseFirestore.instance
          .collection('cpcp127@naver.com')
          .doc('운동기록')
          .collection(DateFormat('yyyy년MM월').format(DateTime.now()))
          .add({
        'date': DateTime.now().toLocal(),
        'datetime': (DateFormat('yyyy년MM월dd일').format(DateTime.now())),
        'title': _workList.toString(),
        'subtitle': textEditingController.text,
      }).then((value) async {
        await Provider.of<HomeProvider>(context, listen: false).getFireStore();
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
    await picker.pickMultiImage().then((value){
      for(int i=0;i<value.length;i++){
        _imageList.add(value[i]);
      }
    });
    notifyListeners();
  }
}
