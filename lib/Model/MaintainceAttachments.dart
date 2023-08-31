
class MaintainceAttachments {
  final int id;
  final String photo;
  final String ext;

  MaintainceAttachments(
      {required this.id, required this.photo, required this.ext});

  factory MaintainceAttachments.fromJson(Map<String, dynamic> json) {
    return MaintainceAttachments(
      id:int.parse(json['id']),
      ext:  json['photo_ext'],
      photo:  json['photo'],
    );
  }

}
