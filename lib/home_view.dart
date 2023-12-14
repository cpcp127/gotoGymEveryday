import 'package:calendar_every/home_tab/chart_view.dart';
import 'package:calendar_every/home_tab/show_calendar_view.dart';
import 'package:calendar_every/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          bottomNavigationBar: BottomNavigationBar(
           backgroundColor: Colors.white,
            elevation: 1,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month), label: '일지'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.area_chart), label: '차트'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.dangerous_outlined), label: '준비중'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: '계정'),
            ],
            onTap: (index) {
              context.read<HomeProvider>().changePageIndex(index);
            },
            currentIndex:  context.watch<HomeProvider>().pageIndex,
          ),
          body: Consumer<HomeProvider>(builder: (context, provider, child) {
            if (provider.pageIndex == 0) {
              return ShowCalendarView();
            } else if (provider.pageIndex == 1) {
              return ChartView();
            } else if (provider.pageIndex == 2) {
              return Container();
            } else {
              return Container();
            }
          }),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    //   await homeProvider.getFireStore(DateTime.now());
    // });
  }
}
