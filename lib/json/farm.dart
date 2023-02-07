class Farm {
  String id;
  String name;
  int livestocks;
  String sector;
  String? picture;

  Farm.fromJson(Map<String, dynamic> map)
      : id = map['farm_id'],
        name = map['farm_name'],
        picture = map['farm_profile_picture'] ?? "",
        livestocks = map['livestocks'] ?? 0,
        sector = map['sector_name'];
}
