import 'dart:collection';

import 'package:calendar_every/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Consumer<HomeProvider>(builder: (context, provider, child) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () async{
                     await provider.getFireStore();
                    },
                    child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(
                            child: Icon(
                          Icons.add,
                          size: 30,
                        ))),
                  ),
                );
              })
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Consumer<HomeProvider>(builder: (context, provider, child) {
                  return TableCalendar(
                    locale: 'ko_KR',
                    // 추가
                    focusedDay: provider.focusDay,
                    firstDay: DateTime.utc(2021, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    calendarStyle: const CalendarStyle(
                        selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    )),
                    headerStyle: const HeaderStyle(
                        titleCentered: true, formatButtonVisible: false),
                    selectedDayPredicate: (day) {
                      return isSameDay(provider.selectDay, day);
                    },
                    onDaySelected: (selectDay, focusDay) {
                      provider.selectingDay(selectDay, focusDay);

                      showModalBottomSheet(
                          isScrollControlled: true,
                          barrierColor: Colors.black.withOpacity(0.2),
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 500,
                              decoration: BoxDecoration(
                                color: Colors.cyan,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(width: double.infinity),
                                  SizedBox(height: 30),
                                  Text(DateFormat('yyyy년 MM월 dd일')
                                      .format(selectDay)),
                                  SizedBox(height: 30),
                                  provider.events.containsKey(selectDay)
                                      ? Text('${provider.events[selectDay]!.single.title}')
                                      : Text('너 뭐하냐?')
                                ],
                              ),
                            );
                          });
                    },
                    eventLoader: (day) {
                      return provider.getEventsForDay(day);
                    },
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   final auth = Provider.of<HomeProvider>(context, listen: false);
    //   auth.getFireStore();
    // });
  }
}
