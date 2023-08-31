
class MaintainceComment {
  final int id;
  final int userId;
  final String UserName;
    String? img;
  final String comment;
  final String Date;

  MaintainceComment(
      {required this.id,
      required this.comment,
      required this.userId,
      required this.UserName,
        this.img,
      required this.Date});

  factory MaintainceComment.fromJson(Map<String, dynamic> json) {
    return MaintainceComment(
      id: int.parse(json['id']),
      comment: json['comment'],
      Date: json['date_time'],
      img: json['img'],
      userId: int.parse(json['user_id']),
      UserName: json['UserName'],
    );
  }

}
