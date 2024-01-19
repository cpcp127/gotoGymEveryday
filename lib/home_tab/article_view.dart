import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_every/hero_view.dart';
import 'package:calendar_every/provider/article_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

import '../user_service.dart';

class ArticleView extends StatefulWidget {
  const ArticleView({super.key});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FirestorePagination(
          onEmpty: const Center(child: Text('텅텅')),
          query: FirebaseFirestore.instance.collection('article'),
          itemBuilder: (context, documentSnapshot, index) {
            return GestureDetector(
                onTap: () {},
                child: Consumer<ArticleProvider>(
                  builder: (context, provider, child) {
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('user')
                            .doc(UserService.instance.userModel.uid)
                            .snapshots(),
                        builder: (context, snapshotUser) {
                          if (!snapshotUser.hasData) {
                            return Container();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      CachedNetworkImage(
                                        imageUrl: ((snapshotUser.data!.data() ??
                                            {}))['image'],
                                        imageBuilder: (context, imageProvider) {
                                          return CircleAvatar(
                                            radius: 20,
                                            backgroundImage: imageProvider,
                                          );
                                        },
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Text(((snapshotUser.data!.data() ??
                                          {}))['nickname']),
                                      const Expanded(child: SizedBox()),
                                      PopupMenuButton(
                                          color: Colors.white,
                                          surfaceTintColor: Colors.white,
                                          icon: const Icon(Icons.more_horiz),
                                          itemBuilder: (context) => [
                                                PopupMenuItem(
                                                    onTap: () {},
                                                    child: const Row(
                                                      children: [
                                                        Icon(Icons.delete),
                                                        Text('삭제'),
                                                      ],
                                                    )),
                                                PopupMenuItem(
                                                    onTap: () {},
                                                    child: const Row(
                                                      children: [
                                                        Icon(Icons.cut),
                                                        Text('수정'),
                                                      ],
                                                    )),
                                              ]),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  AspectRatio(
                                    aspectRatio:
                                        documentSnapshot.get('ratio') == '1:1'
                                            ? 1 / 1
                                            : 4 / 5,
                                    child: PageView.builder(
                                      scrollDirection: Axis.horizontal,
                                      controller: provider.pageController,
                                      itemCount: documentSnapshot
                                          .get('photoList')
                                          .length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) {
                                              return HeroView(
                                                  photoUrl: documentSnapshot
                                                      .get('photoList')[index]);
                                            }));
                                          },
                                          child: Hero(
                                            tag: documentSnapshot
                                                .get('photoList')[index],
                                            child: CachedNetworkImage(
                                              imageUrl: documentSnapshot
                                                  .get('photoList')[index],
                                              imageBuilder:
                                                  (context, imageProvider) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover)),
                                                );
                                              },
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Text(
                                      '운동 부위 : ${documentSnapshot.get('title').join(', ').toString()}'),
                                  Text(documentSnapshot.get('subtitle')),
                                  Row(
                                    children: [
                                      LikeButton(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        likeCount: documentSnapshot
                                            .get('like')['count'],
                                        isLiked: documentSnapshot
                                            .get('like')['people']
                                            .contains(UserService
                                                .instance.userModel.uid),
                                        onTap: (tap) async {
                                          await provider.tabLikeBtn(
                                              tap,
                                              documentSnapshot.id,
                                              documentSnapshot
                                                  .get('like')['count']);
                                          return !tap;
                                        },
                                        countDecoration: (widget, count) {
                                          if (count == 0) {
                                            return Container(
                                              height: 44,
                                            );
                                          }
                                          return GestureDetector(
                                            onTap: () {
                                              likeBottomSheet(
                                                  context, documentSnapshot);
                                            },
                                            child: Container(
                                              height: 44,
                                              color: Colors.white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3),
                                                child: Center(
                                                  child: Text(
                                                      '${documentSnapshot.get('like')['count'].toString()}명'),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          commentBottomSheet(context,
                                              documentSnapshot, provider);
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.comment, size: 30),
                                            const SizedBox(width: 3),
                                            Text(
                                                '${documentSnapshot.get('comment').length.toString()}개'),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ));
          }),
    );
  }

  Future<dynamic> commentBottomSheet(BuildContext context,
      DocumentSnapshot<Object?> documentSnapshot, ArticleProvider provider) {
    return showModalBottomSheet(
        useSafeArea: true,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Container(
              color: Colors.white,
              child: Scaffold(
                appBar: AppBar(),
                resizeToAvoidBottomInset: true,
                bottomSheet: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      SizedBox(width: 16),
                      Expanded(
                          child: TextField(
                        controller: provider.controller,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                      )),
                      GestureDetector(
                        onTap: () async {
                          await provider.sendComment(
                              documentSnapshot.id, provider.controller.text);
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          color: Colors.white,
                          child: Icon(Icons.send),
                        ),
                      )
                    ],
                  ),
                ),
                body: Column(
                  children: [
                    const Text('댓글'),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: provider.scrollController,
                        itemCount: documentSnapshot.get('comment').length,
                        itemBuilder: (context, index) {
                          return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(documentSnapshot.get('comment')[index]
                                      ['uid'])
                                  .snapshots(),
                              builder: (context, snapshotUser) {
                                if (!snapshotUser.hasData) {
                                  return Container(
                                    height: 60,
                                  );
                                }
                                return ListTile(
                                  leading: CachedNetworkImage(
                                    imageUrl: ((snapshotUser.data!.data() ??
                                        {}))['image'],
                                    imageBuilder: (context, imageProvider) {
                                      return CircleAvatar(
                                        radius: 20,
                                        backgroundImage: imageProvider,
                                      );
                                    },
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                  title: Text(((snapshotUser.data!.data() ??
                                      {}))['nickname']),
                                  subtitle: Text(documentSnapshot
                                      .get('comment')[index]['commentBody']),
                                );
                              });
                        },
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> likeBottomSheet(
      BuildContext context, DocumentSnapshot<Object?> documentSnapshot) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height - 250,
            child: Column(
              children: [
                const Text('좋아요 목록'),
                Expanded(
                  child: ListView.builder(
                      itemCount: documentSnapshot.get('like')['count'],
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('user')
                                .doc(documentSnapshot.get('like')['people']
                                    [index])
                                .snapshots(),
                            builder: (context, snapshotUser) {
                              if (!snapshotUser.hasData) {
                                return Container();
                              }
                              return ListTile(
                                leading: CachedNetworkImage(
                                  imageUrl: ((snapshotUser.data!.data() ??
                                      {}))['image'],
                                  imageBuilder: (context, imageProvider) {
                                    return CircleAvatar(
                                      radius: 20,
                                      backgroundImage: imageProvider,
                                    );
                                  },
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                ),
                                title: Text(((snapshotUser.data!.data() ??
                                    {}))['nickname']),
                              );
                            });
                      }),
                ),
              ],
            ),
          );
        });
  }
}
