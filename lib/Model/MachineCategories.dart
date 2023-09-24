
class MachineCategories {
  final int id;
  final String name;
  final String weight_from;
  final String weight_to;

  MachineCategories({
    required this.id,
    required this.name,
    required this.weight_from,
    required this.weight_to
  });

  factory MachineCategories.fromJson(Map<String, dynamic> json) {
    return MachineCategories(
        id: int.parse(json['id']),
        name: json['name'],
        weight_from: json['weight_from'],
        weight_to: json['weight_to']   );
  }
}
