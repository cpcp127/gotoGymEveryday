import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_every/provider/article_provider.dart';
import 'package:calendar_every/provider/comment_provider.dart';
import 'package:calendar_every/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentView extends StatefulWidget {
  const CommentView({super.key, required this.articleId});

  final String articleId;

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  @override
  Widget build(BuildContext context) {
    CommentProvider commentProvider =
        Provider.of<CommentProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Consumer<CommentProvider>(
                  builder: (context, provider, child) {
                    return commentList(provider);
                  },
                ),
              ),
            ),
            commentTextField(commentProvider),
          ],
        ),
      ),
    );
  }

  Container commentTextField(CommentProvider commentProvider) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(width: 16),
          Expanded(
              child: TextField(
            controller: commentProvider.controller,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
          )),
          GestureDetector(
            onTap: () async {
              await commentProvider.sendComment(widget.articleId);
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
    );
  }

  ListView commentList(CommentProvider provider) {
    return ListView.builder(
        controller: provider.scrollController,
        reverse: true,
        shrinkWrap: true,
        itemCount: provider.commentList.length,
        itemBuilder: (context, index) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('user')
                  .doc(provider.commentList[index].data()['uid'])
                  .snapshots(),
              builder: (context, snapshotUser) {
                if (!snapshotUser.hasData) {
                  return Container(
                    height: 70,
                  );
                }
                return GestureDetector(
                  onLongPress: () {
                    if(provider.commentList[index].data()['uid']==UserService.instance.userModel.uid){
                      showDeleteDialog(context, provider, index);
                    }

                  },
                  child: ListTile(
                    horizontalTitleGap: 10,
                    leading: CachedNetworkImage(
                      imageUrl: ((snapshotUser.data!.data() ?? {}))['image'],
                      imageBuilder: (context, imageProvider) {
                        return CircleAvatar(
                          radius: 15,
                          backgroundImage: imageProvider,
                        );
                      },
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                    ),
                    title:
                        Text(((snapshotUser.data!.data() ?? {}))['nickname']),
                    subtitle: Text(provider.commentList[index].data()['body']),
                    trailing: Text(timeago.format(
                        provider.commentList[index]
                            .data()['createdAt']
                            .toDate(),
                        locale: 'kr')),
                  ),
                );
              });
        });
  }

  Future<dynamic> showDeleteDialog(
      BuildContext context, CommentProvider provider, int index) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              //insetPadding: EdgeInsets.symmetric(horizontal: 0),
              buttonPadding: EdgeInsets.zero,
              actionsPadding: EdgeInsets.zero,
              content: Container(
                height: 200,
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text('댓글을 삭제할까요?'),
                    const Expanded(child: SizedBox()),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                context.pop();
                              },
                              child: Container(
                                height: 50,
                                color: Colors.grey,
                                child: const Center(child: Text('아니요')),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () async {
                                provider.deleteComment(widget.articleId,
                                    provider.commentList[index].id);
                                context.pop();
                              },
                              child: Container(
                                height: 50,
                                color: Colors.blue,
                                child: const Center(child: Text('네')),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ));
        });
  }

  @override
  void initState() {
    super.initState();
    CommentProvider commentProvider =
        Provider.of<CommentProvider>(context, listen: false);
    commentProvider.initProvider(widget.articleId);
  }
}
