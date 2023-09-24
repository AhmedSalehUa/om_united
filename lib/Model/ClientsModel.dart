import 'RentsAttachments.dart';

class ClientsModel {
  final int id;
  final String name;
  final String phone;
  final String nationalId;
  final String guardPhone;
  final String location;

  ClientsModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    required this.nationalId,
    required this.guardPhone,
  });

  factory ClientsModel.fromJson(Map<String, dynamic> json) {
    return ClientsModel(
        id: int.parse(json['id']),
        name: json['name'],
        location: json['address'],
        guardPhone: json['guard_phone'],
        nationalId: json['national_id'],
        phone: json['phone'] );
  }
}
