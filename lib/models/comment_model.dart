class CommentModel {
  final int? did;
  final String? name;
  final String? profile;
  final String? content;

  CommentModel(
      {required this.did,
      required this.name,
      required this.profile,
      required this.content});

  static CommentModel fromJson(json) => CommentModel(
      did: json["did"],
      name: json["uName"],
      profile: json["profile"],
      content: json["content"]);
}

// class LostfoundCommentModel {
//   final int id;
//   final int uid;
//   final String name;
//   final String profile;
//   final String comment;

//   LostfoundCommentModel({
//     required this.id,
//     required this.uid,
//     required this.name,
//     required this.profile,
//     required this.comment,
//   });
// }
