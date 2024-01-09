import 'package:cached_network_image/cached_network_image.dart';
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
          query: FirebaseFirestore.instance.collection('article'),
          itemBuilder: (context, documentSnapshot, index) {
            return GestureDetector(onTap: () {
              print(documentSnapshot.get('title'));
            }, child: Consumer<ArticleProvider>(
              builder: (context, provider, child) {
                return Container(
                  color: Colors.red,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: UserService.instance.userModel.photoUrl,
                            imageBuilder: (context, imageProvider) {
                              return CircleAvatar(
                                radius: 20,
                                backgroundImage: imageProvider,
                              );
                            },
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                          ),
                          Text(UserService.instance.userModel.nickname),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width,
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: provider.pageController,
                          itemCount: documentSnapshot.get('photoList').length,
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl:
                                  documentSnapshot.get('photoList')[index],
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover)),
                                );
                              },
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                            );
                          },
                        ),
                      ),
                      Text(
                          '운동 부위 : ${documentSnapshot.get('title').join(', ').toString()}'),
                      Text(documentSnapshot.get('subtitle'))
                    ],
                  ),
                );
              },
            ));
          }),
    );
  }
}
