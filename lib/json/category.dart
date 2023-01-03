class Category{
  String id;
  String name;

  Category.fromJson(Map<String,dynamic> map): id = map['category_id'] , name = map['category_name'];
}