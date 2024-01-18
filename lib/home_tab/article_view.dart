import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_every/hero_view.dart';
import 'package:calendar_every/provider/article_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:provider/provider.dart';

import '../user_service.dart';

class ArticleView extends StatefulWidget {
  const ArticleView({super.key});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
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
                                  Text(documentSnapshot.get('subtitle'))
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
}
