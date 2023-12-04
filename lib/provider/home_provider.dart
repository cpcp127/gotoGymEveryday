import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/event_model.dart';

class HomeProvider extends ChangeNotifier {
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
            Event(value.docs[i].data()['date'].toDate(),
                value.docs[i].data()['title'], value.docs[i].data()['subtitle'],value.docs[i].data()['photoList'],)
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
  void changePage(DateTime date){
    getFireStore(date);
    _focusDay = date;
  }
  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }
}
