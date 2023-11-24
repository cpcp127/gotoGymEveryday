import 'package:flutter/material.dart';

class WriteTodayWorkProvider extends ChangeNotifier{
  List<String> _workList = [];

  List<String> get workList => _workList;

  void addWorkList(String work){
    if(workList.contains(work)){
      workList.remove(work);
    }else{
      workList.add(work);
    }
    notifyListeners();
  }
}