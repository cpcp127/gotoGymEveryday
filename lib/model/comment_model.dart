class CommentModel {
  String? body;
  DateTime? createdAt;
  String? uid;

  CommentModel({this.body, this.createdAt, this.uid});

  factory CommentModel.fromJson(Map<dynamic, dynamic> json) => CommentModel(
        body: json['body'],
        createdAt: json['createdAt'],
        uid: json['uid'],
      );

  Map<String, dynamic> toJson() => {
        "body": body,
        "createdAt": createdAt,
        'uid': uid,
      };
}
