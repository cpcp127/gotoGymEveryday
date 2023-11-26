import 'package:calendar_every/provider/home_provider.dart';
import 'package:calendar_every/toast/show_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WriteTodayWorkProvider extends ChangeNotifier {
  List<String> _workList = [];
  int _pageIndex = 0;
  TextEditingController _textEditingController = TextEditingController();

  List<String> get workList => _workList;

  int get pageIndex => _pageIndex;

  TextEditingController get textEditingController => _textEditingController;

  void stepContinue(context) {
    if (_pageIndex == 0) {
      if (_workList.isEmpty) {
        showToast('1개 이상 선택해 주세요');
      } else {
        _pageIndex++;
      }
    } else if (_pageIndex == 1) {
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
}
