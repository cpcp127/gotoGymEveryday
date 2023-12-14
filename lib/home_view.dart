import 'package:calendar_every/home_tab/chart_view.dart';
import 'package:calendar_every/home_tab/show_calendar_view.dart';
import 'package:calendar_every/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      child: SafeArea(child: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          if(provider.autoLogin){
            return Scaffold(
                bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  elevation: 1,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.calendar_month), label: '일지'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.area_chart), label: '차트'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.dangerous_outlined), label: '준비중'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person), label: '계정'),
                  ],
                  onTap: (index) {
                    context.read<HomeProvider>().changePageIndex(index);
                  },
                  currentIndex: context.watch<HomeProvider>().pageIndex,
                ),
                body: provider.pageIndex == 0
                    ? const ShowCalendarView()
                    : provider.pageIndex == 1
                    ? const ChartView()
                    : Container()
            );
          }else{
            return GestureDetector(
              onTap: (){
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Scaffold(
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(),
                    Text('로그인'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: provider.emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: provider.pwdController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,

                        children: [
                          Expanded(child: SizedBox()),
                          GestureDetector(
                            onTap: (){
                              context.push('/register');
                            },
                            child: Container(
                              height: 44,
                              color: Colors.white,
                              child: Center(child: Text('회원가입')),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }

        },
      )),
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
