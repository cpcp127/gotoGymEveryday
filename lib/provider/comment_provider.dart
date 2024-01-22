import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../user_service.dart';

class CommentProvider extends ChangeNotifier {
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<dynamic> _commentList = [];

  TextEditingController get controller => _controller;

  ScrollController get scrollController => _scrollController;

  List<dynamic> get commentList => _commentList;

  Future<void> sendComment(String articleId) async {
    if (_controller.text.isEmpty) {
    } else {
      await FirebaseFirestore.instance
          .collection('comment')
          .doc(articleId)
          .collection('comment')
          .add({
        'body': controller.text,
        'createdAt': DateTime.now().toLocal(),
        'uid': UserService.instance.userModel.uid,
      });
      FirebaseFirestore.instance
          .collection('article')
          .doc(articleId)
          .update({'comment': FieldValue.increment(1)});
      await getCommentList(articleId);
      scrollController.jumpTo(0);
      controller.clear();
      notifyListeners();
    }
  }

  Future<void> getCommentList(String articleId) async {
    FirebaseFirestore.instance
        .collection('comment')
        .doc(articleId)
        .collection('comment')
        .get()
        .then((value) {
      _commentList = value.docs;
      _commentList.sort(
          (a, b) => b.data()['createdAt'].compareTo(a.data()['createdAt']));
      notifyListeners();
    });
  }

  Future<void> deleteComment(String articleId,String snapshotId) async {
    FirebaseFirestore.instance
        .collection('comment')
        .doc(articleId)
        .collection('comment')
        .doc(snapshotId)
        .delete().then((value) async {
          await getCommentList(articleId);
          FirebaseFirestore.instance.collection('article').doc(articleId).update({
            'comment':FieldValue.increment(-1),
          });
    });
  }

  initProvider(String articleId) {
    getCommentList(articleId);
    _scrollController = ScrollController();
    _controller.clear();
  }
}
