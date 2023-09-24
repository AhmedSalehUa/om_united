
class RentsAttachments {
  final int id;
  final String photo;
  final String ext;

  RentsAttachments(
      {required this.id, required this.photo, required this.ext});

  factory RentsAttachments.fromJson(Map<String, dynamic> json) {
    return RentsAttachments(
      id:int.parse(json['id']),
      ext:  json['photo_ext'],
      photo:  json['photo'],
    );
  }

}
