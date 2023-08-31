class Rent {
  final int id;
  final String name;
  final String date;
  final String dateTo;
  final String phone;
  final String nationalId;
  final String guardPhone;
  final String location;
  final String imageUrl;
  final String imageExt;

  Rent({
    required this.id,
    required this.name,
    required this.date,
    required this.phone,
    required this.location,
    required this.nationalId,
    required this.guardPhone,
    required this.dateTo,
    required this.imageUrl,
    required this.imageExt,
  });

  factory Rent.fromJson(Map<String, dynamic> json) {
    return Rent(
        id: int.parse(json['id']),
        name: json['name'],
        location: json['address'],
        imageUrl: json['doc'],
        date: json['date_from'],
        imageExt: json['doc_ext'],
        dateTo: json['date_to'],
        guardPhone: json['guard_phone'],
        nationalId: json['national_id'],
        phone: json['phone']);
  }

}
