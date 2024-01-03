import 'dart:collection';

import 'package:calendar_every/toast/show_toast.dart';
import 'package:calendar_every/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/event_model.dart';

class ShowCalendarProvider extends ChangeNotifier {
  int _pageIndex = 0;

  int get pageIndex => _pageIndex;

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  DateTime _focusDay = DateTime.now();
  DateTime _selectDay = DateTime.now();
  final PageController _pageController = PageController();

  DateTime get focusDay => _focusDay;

  DateTime get selectDay => _selectDay;
  final _events = LinkedHashMap<DateTime, List<Event>>(equals: isSameDay)
    ..addAll({
      // DateTime.utc(2023, 11, 13): [
      //   Event(DateTime.utc(2023, 11, 13), 'true', 'sub')
      // ],
      //DateTime.utc(2023, 11, 08): [Event(DateTime.utc(2023, 11, 08), 'title','sub1')],
    });

  PageController get pageController => _pageController;

  LinkedHashMap<DateTime, List<Event>> get events => _events;

  get getEventsForDay => _getEventsForDay;

  Future<void> getFireStore(DateTime date, BuildContext context) async {
    _events.clear();
    await FirebaseFirestore.instance
        .collection(UserService.instance.userModel.email)
        .doc('운동기록')
        .collection(DateFormat('yyyy년MM월').format(date))
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        _events.addAll({
          DateTime.utc(
              value.docs[i].data()['date'].toDate().year,
              value.docs[i].data()['date'].toDate().month,
              value.docs[i].data()['date'].toDate().day): [
            Event(
              value.docs[i].data()['date'].toDate(),
              value.docs[i].data()['title'],
              value.docs[i].data()['subtitle'],
              value.docs[i].data()['photoList'],
            )
          ]
        });
      }
    });
    notifyListeners();
  }

  void selectingDay(DateTime selectDay, DateTime focusDay) {
    _selectDay = selectDay;
    _focusDay = focusDay;
    notifyListeners();
  }

  void changePage(DateTime date, BuildContext context) {
    getFireStore(date, context);
    _focusDay = date;
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void changePageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  void gotoWriteToday(BuildContext context) {
    if (events.keys.contains(
      DateTime.utc(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
    )) {
      showToast('이미 기록하셨습니다!');
    } else {
      context.go('/writeToday');
    }
  }

  Future<void> deleteWorkRecord(DateTime date, BuildContext context) async {
    //개수에 따라서 사진 삭제후 firestore도 삭제
    _isLoading = true;
    notifyListeners();
    await FirebaseStorage.instance
        .ref(
            '${UserService.instance.userModel.email} ${DateFormat('yyyy년MM월dd일/').format(date)}')
        .listAll()
        .then((value) {
      List<String> pathList = [];

      for (int i = 0; i < value.items.length; i++) {
        pathList.add(value.items[i].fullPath);
        // FirebaseStorage.instance.ref(value.items.first.fullPath).delete();
      }
      for (int i = 0; i < value.items.length; i++) {
        // pathList.add(value.items[i].fullPath);
        FirebaseStorage.instance.ref(pathList[i]).delete();
      }
    });
    await FirebaseFirestore.instance
        .collection(UserService.instance.userModel.email)
        .doc('운동기록')
        .collection(DateFormat('yyyy년MM월').format(date))
        .doc(DateFormat('yyyy년MM월dd일').format(date))
        .delete()
        .then((value) async {
      await getFireStore(date, context);
    }).whenComplete(() {
      _isLoading = false;
    });
    notifyListeners();
  }
}
