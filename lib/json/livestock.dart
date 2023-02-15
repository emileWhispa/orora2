class Livestock {
  String id;
  String? tag;
  String? description;

  Livestock.fromJson(Map<String, dynamic> map)
      : id = map['livestock_id'],
        tag = map['brucellosis_tag'],
        description = map['notes'];
}
