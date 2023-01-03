class Province{
  String id;
  String name;

  Province.fromJson(Map<String,dynamic> map): id = map['province_id'] , name = map['province_name'];
}