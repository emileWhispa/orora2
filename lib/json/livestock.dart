class Livestock{
  String id;
  String? tag;

  Livestock.fromJson(Map<String,dynamic> map): id = map['livestock_id'],tag = map['brucellosis_tag'];
}