import 'package:calendar_every/provider/start_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartView extends StatefulWidget {
  const StartView({super.key});

  @override
  State<StartView> createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
              ),
              Text('대전대 몸 관리 어플'),
              SizedBox(height: 32),
              Consumer<StartProvider>(builder: (context,provider,child){
                return GestureDetector(
                  onTap: ()async{

                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.purple),
                      child: Center(
                          child: Text(
                            '시작하기',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                );
              })

            ],
          ),
        ),
      ),
    );
  }
}
