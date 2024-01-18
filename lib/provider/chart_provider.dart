import 'dart:collection';

import 'package:calendar_every/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/event_model.dart';

class ChartProvider extends ChangeNotifier {
  int _lastDay = 30;
  int _workDay = 20;
  final _events = LinkedHashMap<DateTime, List<Event>>(equals: isSameDay);
  final _firstEvents = LinkedHashMap<DateTime, List<Event>>(equals: isSameDay);
  final _secondEvents = LinkedHashMap<DateTime, List<Event>>(equals: isSameDay);
  final _thirdEvents = LinkedHashMap<DateTime, List<Event>>(equals: isSameDay);
  final _fourEvents = LinkedHashMap<DateTime, List<Event>>(equals: isSameDay);
  final _fiveEvents = LinkedHashMap<DateTime, List<Event>>(equals: isSameDay);
  final _sixEvents = LinkedHashMap<DateTime, List<Event>>(equals: isSameDay);

  int get lastDay => _lastDay;
  int get workDay => _workDay;
  LinkedHashMap<DateTime, List<Event>> get events => _events;
  LinkedHashMap<DateTime, List<Event>> get firstEvents => _firstEvents;
  LinkedHashMap<DateTime, List<Event>> get secondEvents => _secondEvents;
  LinkedHashMap<DateTime, List<Event>> get thirdEvents => _thirdEvents;
  LinkedHashMap<DateTime, List<Event>> get fourEvents => _fourEvents;
  LinkedHashMap<DateTime, List<Event>> get fiveEvents => _fiveEvents;
  LinkedHashMap<DateTime, List<Event>> get sixEvents => _sixEvents;

  Future<void> getLastDayOfMonth(DateTime dateTime) async {
    _lastDay = DateTime(dateTime.year, dateTime.month + 1, 0).day;
    notifyListeners();
  }

  Future<void> getWorkDayOfMonth(DateTime dateTime) async {
    _events.clear();
    await FirebaseFirestore.instance
        .collection('운동기록')
        .doc((UserService.instance.userModel.uid))
        .collection(DateFormat('yyyy년MM월').format(dateTime))
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
      _workDay = _events.length;
    });
    notifyListeners();
  }

  Future<void> getSixEventMonth(
      DateTime dateTime, LinkedHashMap<DateTime, List<Event>> eventMap) async {
    eventMap.clear();
    await FirebaseFirestore.instance
        .collection('운동기록')
        .doc((UserService.instance.userModel.uid))
        .collection(DateFormat('yyyy년MM월').format(dateTime))
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        eventMap.addAll({
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
}
