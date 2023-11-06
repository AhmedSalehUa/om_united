
class Assets  {
  final int id;
  final int category_id;
  final String name;
  final String code;
  final String value;
  final String image;
  Assets(
      {required this.id,
        required this.category_id,
        required this.name,
        required this.code,
        required this.value,
        required this.image, });

  factory Assets.fromJson(Map<String, dynamic> json) {
    return Assets(
        id: int.parse(json['id']),
        category_id:  int.parse(json['category_id']),
        name: json['name'],
        code: json['code'],
        value: json['value'],
        image: json['image'] );
  }
}
