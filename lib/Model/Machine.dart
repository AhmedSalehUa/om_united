import 'package:om_united/Model/MachineCategories.dart';
import 'package:om_united/Model/Rent.dart';

import 'Maintaince.dart';

class Machine {
  final int id;
  final String name;
  String? code;
  String? brand;
  String? serial;

  final String status;
  String? lastMaintaince;
  String? total_maintance_cost;
  String? machine_value;

  MachineCategories category;
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
    this.serial,
    required this.status,
    required this.category,
    required this.maintainceEvery,
    this.lastMaintaince,
    this.machine_value,
    this.total_maintance_cost,
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
    MachineCategories maintainceCat =
        MachineCategories.fromJson(json['categoryItem'][0]);
    return Machine(
        id: int.parse(json['id']),
        name: json['name'],
        status: json['status'],
        category: maintainceCat,
        maintainceEvery: json['maintance_every'],
        imageUrl: json['photo'],
        lastMaintaince: json['last_maintaince'],
        machine_value: json['machine_value'],
        serial: json['serialName'],
        total_maintance_cost: json['total_maintance_cost'],
        code: json['code'],
        imageExt: json['photo_ext'],
        brand: json['brand'],
        mainainces: maintaince,
        rent: rent);
  }
}
