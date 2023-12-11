import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

import '../provider/home_provider.dart';
import '../theme/agro_text_style.dart';

class ShowCalendarView extends StatefulWidget {
  const ShowCalendarView({super.key});

  @override
  State<ShowCalendarView> createState() => _ShowCalendarViewState();
}

class _ShowCalendarViewState extends State<ShowCalendarView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () async {
                    context.read<HomeProvider>().gotoWriteToday(context);
                  },
                  child: const SizedBox(
                      width: 44,
                      height: 44,
                      child: Center(
                          child: Icon(
                        Icons.add,
                        size: 30,
                      ))),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Consumer<HomeProvider>(builder: (context, provider, child) {
                  return TableCalendar(
                    locale: 'ko_KR',
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
                    onPageChanged: (DateTime date) async {
                      provider.changePage(date);
                    },
                    onDaySelected: (selectDay, focusDay) {
                      provider.selectingDay(selectDay, focusDay);

                      provider.events.containsKey(selectDay)
                          ? workBottomSheet(context, selectDay, provider)
                          : null;
                    },
                    eventLoader: (day) {
                      return provider.getEventsForDay(day);
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> workBottomSheet(
      BuildContext context, DateTime selectDay, HomeProvider provider) {
    return showModalBottomSheet(
        isScrollControlled: true,
        barrierColor: Colors.black.withOpacity(0.2),
        context: context,
        builder: (context) {
          return Container(
            height: 500,
            decoration: const BoxDecoration(
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
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: () {
                        context.read<HomeProvider>().deleteWorkRecord(selectDay);
                        // showDialog(
                        //     context: context,
                        //     builder: (context) {
                        //       return Dialog(
                        //         child: Container(
                        //           width: 200,
                        //           //height: 160,
                        //           decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(16),
                        //             color: Colors.amber,
                        //           ),
                        //           child: Column(
                        //             mainAxisAlignment: MainAxisAlignment.start,
                        //             mainAxisSize: MainAxisSize.min,
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               Text('삭제'),
                        //               SizedBox(height: 16),
                        //               Text(
                        //                   '${DateFormat('yyyy년 MM월 dd일').format(selectDay)}의 기록을 삭제하시겠어요?'),
                        //               SizedBox(height: 16),
                        //               Row(
                        //                 children: [
                        //                   Expanded(child: SizedBox()),
                        //                   GestureDetector(
                        //                     onTap: () {
                        //                       Navigator.pop(context);
                        //                       Navigator.pop(context);
                        //                     },
                        //                     child: Container(
                        //                       width: 50,
                        //                       height: 44,
                        //                       color: Colors.red,
                        //                       child: Center(child: Text('취소')),
                        //                     ),
                        //                   ),
                        //                   SizedBox(width: 10),
                        //                   GestureDetector(
                        //                     onTap: () {
                        //                       Navigator.pop(context);
                        //                       Navigator.pop(context);
                        //                     },
                        //                     child: Container(
                        //                       width: 50,
                        //                       height: 44,
                        //                       color: Colors.red,
                        //                       child: Center(child: Text('삭제')),
                        //                     ),
                        //                   )
                        //                 ],
                        //               )
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     });
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        child: Icon(Icons.delete),
                      ),
                    ),
                    SizedBox(width: 16),
                  ],
                ),
                const SizedBox(height: 30),
                Text(DateFormat('yyyy년 MM월 dd일').format(selectDay),
                    style: AgroTextStyle.headlineLarge),
                const SizedBox(height: 30),
                Text('${provider.events[selectDay]!.single.title}'),
                provider.events[selectDay]!.single.photoList.isEmpty
                    ? Container()
                    : Container(
                        width: 220,
                        height: 220,
                        child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            controller: provider.pageController,
                            itemCount: provider
                                .events[selectDay]!.single.photoList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                      image: NetworkImage(provider
                                          .events[selectDay]!
                                          .single
                                          .photoList[index]),
                                      fit: BoxFit.cover),
                                ),
                              );
                            }),
                      ),
                const SizedBox(height: 16),
                provider.events[selectDay]!.single.photoList.isEmpty
                    ? Container()
                    : Container(
                        width: 220,
                        alignment: Alignment.center,
                        child: SmoothPageIndicator(
                            controller: provider.pageController,
                            count: provider
                                .events[selectDay]!.single.photoList.length,
                            effect: const ScrollingDotsEffect(
                              activeDotColor: Colors.indigoAccent,
                              activeStrokeWidth: 10,
                              activeDotScale: 1.7,
                              maxVisibleDots: 5,
                              radius: 16,
                              spacing: 10,
                              dotHeight: 16,
                              dotWidth: 16,
                            )),
                      ),
              ],
            ),
          );
        });
  }
}
