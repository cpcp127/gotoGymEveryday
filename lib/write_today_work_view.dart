import 'dart:io';

import 'package:calendar_every/provider/write_today_work_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
      child: Stack(
        children: [
          Container(
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
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.cyan,
                                  ),
                                  child: const Center(child: Text('이전')),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                provider.stepContinue(context, DateTime.now());
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.cyan,
                                ),
                                child: const Center(child: Text('다음')),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ),
                  );
                }),
                body: Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Consumer<WriteTodayWorkProvider>(
                    builder: (context, provider, child) {
                      return provider.pageIndex == 0
                          ? stepOne(provider)
                          : provider.pageIndex == 1
                              ? stepTwo(provider)
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Row(),
                                    GestureDetector(
                                      onTap: () async {
                                        await provider.selectMultiImage();
                                      },
                                      child: provider.imageList.isEmpty
                                          ? Container(
                                              width: 220,
                                              height: 220,
                                              color: Colors.red,
                                              child: const Icon(Icons.add),
                                            )
                                          : SizedBox(
                                              width: 220,
                                              height: 220,
                                              child: PageView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  controller:
                                                      provider.pageController,
                                                  itemCount:
                                                      provider.imageList.length,
                                                  itemBuilder: (context, index) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12),
                                                        image: DecorationImage(
                                                            image: FileImage(
                                                              File(provider
                                                                  .imageList[
                                                                      index]
                                                                  .path),
                                                            ),
                                                            fit: BoxFit.cover),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      width: 220,
                                      alignment: Alignment.center,
                                      child: SmoothPageIndicator(
                                          controller: provider.pageController,
                                          count: provider.imageList.length,
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
                                    )
                                  ],
                                );
                    },
                  ),
                ),
              ),
            ),
          ),
          Consumer<WriteTodayWorkProvider>(
            builder: (context, provider, child) {
              return Visibility(
                visible: provider.isLoading,
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget stepTwo(WriteTodayWorkProvider provider) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          GestureDetector(
            onTap: () async {
              await provider.selectMultiImage();
            },
            child: provider.imageList.isEmpty
                ? Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey,width: 2)
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(Icons.photo_camera,size: 25,),
                        SizedBox(height: 5),
                        Text('8장 이하로 올려주세요')
                      ],
                    ),
                  )
                : SizedBox(
                    width: 150,
                    height: 150,
                    child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: provider.pageController,
                        itemCount: provider.imageList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                  image: FileImage(
                                    File(provider.imageList[index].path),
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          );
                        }),
                  ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 220,
            alignment: Alignment.center,
            child: SmoothPageIndicator(
                controller: provider.pageController,
                count: provider.imageList.length,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: provider.textEditingController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
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
          ),

        ],
      ),
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final provider =
          Provider.of<WriteTodayWorkProvider>(context, listen: false);
      provider.resetProvider();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
