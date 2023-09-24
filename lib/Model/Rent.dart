import 'package:om_united/Model/ClientsModel.dart';

import 'RentsAttachments.dart';

class Rent {
  final int id;
  final String date;
  final String dateTo;
    String? notes;

  ClientsModel? client;
  List<RentsAttachments>? attachments;

  Rent({
    required this.id,
    required this.date,
    required this.dateTo,
    this.notes,
    this.client,
    this.attachments,
  });

  factory Rent.fromJson(Map<String, dynamic> json) {
    List<RentsAttachments> attachments = [];
    if (json['Attachments'] != false) {
      for (var itemJson in json['Attachments']) {
        final item = RentsAttachments.fromJson(itemJson);
        attachments.add(item);
      }
    }
    ClientsModel? client = ClientsModel.fromJson(json['Clients'][0]);

    return Rent(
        id: int.parse(json['id']),
        date: json['date_from'],
        dateTo: json['date_to'],client: client,notes: json['notes'],
        attachments: attachments);
  }
}
