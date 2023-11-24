import 'package:calendar_every/provider/write_today_work_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WriteTodayWorkView extends StatefulWidget {
  const WriteTodayWorkView({super.key});

  @override
  State<WriteTodayWorkView> createState() => _WriteTodayWorkViewState();
}

class _WriteTodayWorkViewState extends State<WriteTodayWorkView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Consumer<WriteTodayWorkProvider>(
            builder: (context, provider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildWorkBox(
                        provider,
                        '등',
                        'back',
                      ),
                      SizedBox(width: 20),
                      buildWorkBox(
                        provider,
                        '가슴',
                        'chest',
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildWorkBox(
                        provider,
                        '하체',
                        'leg',
                      ),
                      SizedBox(width: 20),
                      buildWorkBox(
                        provider,
                        '어깨',
                        'shoulder',
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildWorkBox(
                        provider,
                        '팔',
                        'arm',
                      ),
                      SizedBox(width: 20),
                      buildWorkBox(
                        provider,
                        '유산소',
                        'running',
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Column buildWorkBox(
      WriteTodayWorkProvider provider, String workKr, String work) {
    return Column(
      children: [
        Text(workKr),
        GestureDetector(
          onTap: () {
            provider.addWorkList(work);
          },
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: provider.workList.contains(work)
                      ? Colors.black
                      : Color(0xffb9b9b9),
                  width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(provider.workList.contains(work)
                        ? 'assets/images/${work}_black.png'
                        : 'assets/images/${work}_gray.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
