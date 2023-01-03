class Farm{
  String id;
  String name;
  int livestocks;
  String sector;

  Farm.fromJson(Map<String,dynamic> map): id = map['farm_id'],name = map['farm_name'],livestocks = map['livestocks'],sector = map['sector_name'];
}