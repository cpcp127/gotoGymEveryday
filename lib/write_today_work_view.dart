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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            bottomSheet: Consumer<WriteTodayWorkProvider>(
                builder: (context, provider, child) {
              return Container(
                height: 80,
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: Visibility(
                          visible: provider.pageIndex == 0 ? false : true,
                          child: GestureDetector(
                            onTap: () {
                              provider.stepPrevious();
                            },
                            child: Container(
                              child: const Center(child: Text('이전')),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.cyan,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            provider.stepContinue(context);
                          },
                          child: Container(
                            child: const Center(child: Text('다음')),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.cyan,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              );
            }),
            body: Consumer<WriteTodayWorkProvider>(
              builder: (context, provider, child) {
                return provider.pageIndex == 0
                    ? stepOne(provider)
                    : stepTwo(provider);
              },
            ),
          ),
        ),
      ),
    );
  }

  Column stepTwo(WriteTodayWorkProvider provider) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: provider.textEditingController,
            maxLines: 10,
            decoration: const InputDecoration(
              hintText: '운동에 대해 간단히 설명해 주세요',
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
        )
      ],
    );
  }

  Column stepOne(WriteTodayWorkProvider provider) {
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
            const SizedBox(width: 20),
            buildWorkBox(
              provider,
              '가슴',
              'chest',
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildWorkBox(
              provider,
              '하체',
              'leg',
            ),
            const SizedBox(width: 20),
            buildWorkBox(
              provider,
              '어깨',
              'shoulder',
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildWorkBox(
              provider,
              '팔',
              'arm',
            ),
            const SizedBox(width: 20),
            buildWorkBox(
              provider,
              '유산소',
              'running',
            ),
          ],
        )
      ],
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
                      : const Color(0xffb9b9b9),
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
