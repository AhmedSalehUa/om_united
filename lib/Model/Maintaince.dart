 import 'package:om_united/Model/MaintainceComment.dart';

import 'MaintainceAttachments.dart';

class Maintaince {
  final int id;
  final int userId;
  final String UserName;
    String? img;
  List<MaintainceAttachments>? attachments;
  List<MaintainceComment>? comments;
  final String date;
  final String notes;

  Maintaince(
      {required this.id,
      this.attachments,
      this.comments,
      required this.date,
      required this.userId,
      required this.UserName,
        this.img,
      required this.notes});

  factory Maintaince.fromJson(Map<String, dynamic> json) {
    List<MaintainceAttachments> attachments =[];
    if (json['Attachments'] != false) {
      for (var itemJson in json['Attachments']) {
        final item = MaintainceAttachments.fromJson(itemJson);
        attachments.add(item);
      }
    }
    List<MaintainceComment> comments =[];
    if (json['Comments'] != false) {
      for (var itemJson in json['Comments']) {
        final item = MaintainceComment.fromJson(itemJson);
        comments.add(item);
      }
    }
    return Maintaince(
      id: int.parse(json['id']),
      date: json['date'],
      notes: json['comments'],
      attachments: attachments,
      userId: int.parse(json['user_id']),
      UserName: json['UserName'],
      img: json['img'],
      comments: comments,
    );
  }
}
