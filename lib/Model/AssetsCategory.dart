
class AssetsCategory {
  final int id;
  final String name;
  final String image;
  final String forRent;
  final String count;
  final String value;

  AssetsCategory(
      {required this.id,
        required this.name,
        required this.image,
        required this.forRent,
        required this.count,
        required this.value });

  factory AssetsCategory.fromJson(Map<String, dynamic> json) {
    return AssetsCategory(
        id: int.parse(json['id']),
        name: json['name'],
        image: json['image'],
        forRent: json['for_rent'] ,
        count: json['count'] ,
        value: json['value'] );
  }
  factory AssetsCategory.fromString() {
    return AssetsCategory(
        id: 4,
        name: "test",
        image: "",
        forRent: "true" ,
        count: "10" ,
        value: "100" );
  }
}
