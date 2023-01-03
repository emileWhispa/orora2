class Sector{
  String id;
  String name;

  Sector.fromJson(Map<String,dynamic> map): id = map['sector_id'] , name = map['sector_name'];
}