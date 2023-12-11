import 'dart:collection';
import 'package:calendar_every/toast/show_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/event_model.dart';

class HomeProvider extends ChangeNotifier {
  int _pageIndex = 0;

  int get pageIndex => _pageIndex;

  DateTime _focusDay = DateTime.now();
  DateTime _selectDay = DateTime.now();
  PageController _pageController = PageController();

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

  Future<void> getFireStore(DateTime date) async {
    _events.clear();
    await FirebaseFirestore.instance
        .collection('cpcp127@naver.com')
        .doc('운동기록')
        .collection(DateFormat('yyyy년MM월').format(date))
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        print(value.docs[i].data()['date'].toDate());
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

  void changePage(DateTime date) {
    getFireStore(date);
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

  Future<void> deleteWorkRecord(DateTime date)async{
    int photoListLength = events[DateTime.utc(
        date.year, date.month, date.day)]!.first.photoList.length;
    print(photoListLength);
    //개수에 따라서 사진 삭제후 firestore도 삭제
    //FirebaseStorage.instance.ref()
  }
}
