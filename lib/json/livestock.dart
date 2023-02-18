class Livestock {
  String id;
  String? tag;
  String? farmId;
  String? description;

  Livestock.fromJson(Map<String, dynamic> map)
      : id = map['livestock_id'],
        tag = map['brucellosis_tag'],
        farmId = map['farm_id'],
        description = map['notes'];
}
