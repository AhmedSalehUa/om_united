
import 'package:om_united/Model/Rent.dart';

import 'Maintaince.dart';

class Machine {
  final int id;
  final String name;
  String? code;
  String? brand;
  final String status;
  String? lastMaintaince;
  String? imageUrl;
  String? imageExt;
  final String maintainceEvery;
  Rent? rent;
  List<Maintaince>? mainainces;

  Machine({
    required this.id,
    required this.name,
    this.code,
    this.brand,
    required this.status,
    required this.maintainceEvery,
    this.lastMaintaince,
    this.imageUrl,
    this.imageExt,
    this.rent,
    this.mainainces,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    Rent? rent;
    if (json['rents'] != false) {
      rent = Rent.fromJson(json['rents']);
    }
    List<Maintaince> maintaince = [];
    if (json['Maintainces'] != false) {
      for (var itemJson in json['Maintainces']) {
        final item = Maintaince.fromJson(itemJson);
        maintaince.add(item);
      }
    }
    return Machine(
        id: int.parse(json['id']),
        name: json['name'],
        status: json['status'],
        maintainceEvery: json['maintance_every'],
        imageUrl: json['photo'],
        lastMaintaince: json['last_maintaince'],
        code: json['code'],
        imageExt: json['photo_ext'],
        brand: json['brand'],
        mainainces: maintaince,
        rent: rent);
  }

}
