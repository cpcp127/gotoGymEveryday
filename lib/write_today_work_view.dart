import 'dart:io';

import 'package:calendar_every/provider/write_today_work_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
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
                                child: Center(
                                    child: Text(
                                        provider.pageIndex == 0 ? '다음' : '완료')),
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
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        image: DecorationImage(
                                                            image: FileImage(
                                                              File(provider
                                                                  .imageList[
                                                                      index]),
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
          provider.imageList.isEmpty
              ? Container()
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          provider.tapHorizontalBtn();
                        },
                        child: Container(
                          height: 50,
                          color: Colors.white,
                          child: Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 5),
                                Icon(Icons.square_outlined,
                                    color: provider.photoRatio == '1:1'
                                        ? Colors.black
                                        : Colors.grey),
                                Text(
                                  '1:1',
                                  style: TextStyle(
                                      color: provider.photoRatio == '1:1'
                                          ? Colors.black
                                          : Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          provider.tapVerticalBtn();
                        },
                        child: Container(
                          height: 50,
                          color: Colors.white,
                          child: Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 5),
                                Transform.rotate(
                                    angle: 3.14 / 2,
                                    child: Icon(Icons.rectangle_outlined,
                                        color: provider.photoRatio == '4:5'
                                            ? Colors.black
                                            : Colors.grey)),
                                Text(
                                  '4:5',
                                  style: TextStyle(
                                      color: provider.photoRatio == '4:5'
                                          ? Colors.black
                                          : Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          GestureDetector(
            onTap: () async {
              await provider.selectMultiImage();
            },
            child: provider.imageList.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey, width: 2)),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.photo_camera,
                            size: 25,
                          ),
                          SizedBox(height: 5),
                          Text('8장 이하로 올려주세요')
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AspectRatio(
                      aspectRatio: provider.photoRatio == '1:1' ? 1 / 1 : 4 / 5,
                      child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: provider.pageController,
                          itemCount: provider.imageList.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.withOpacity(0.2),
                                    image: DecorationImage(
                                        image: FileImage(
                                          File(provider.imageList[index]),
                                        ),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          child: Container(
                                              width: 44,
                                              height: 44,
                                              color: Colors.transparent,
                                              child: const Icon(
                                                Icons.auto_fix_normal_outlined,
                                                size: 30,
                                              )),
                                          onTap: () async {
                                            await provider.cropImage(index);
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          child: Container(
                                              width: 44,
                                              height: 44,
                                              color: Colors.transparent,
                                              child: const Icon(
                                                Icons.highlight_remove_outlined,
                                                size: 30,
                                              )),
                                          onTap: () {
                                            provider.deleteImage(index);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
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
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(child: SizedBox()),
              Text('게시글 자동 업로드'),
              SizedBox(width: 16),
            ],
          ),
          Row(
            children: [
              const Expanded(child: SizedBox()),
              Switch(
                  value: provider.uploadArticle,
                  trackOutlineColor: MaterialStateProperty.resolveWith(
                      (final Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return null;
                    }

                    return Colors.transparent;
                  }),
                  onChanged: (bool on) {
                    provider.tapUploadArticleBtn();
                  }),
              const SizedBox(width: 16),
            ],
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
