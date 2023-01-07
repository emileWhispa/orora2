class TransCategory {
  String id;
  String type;
  String name;

  TransCategory.fromJson(Map<String, dynamic> map)
      : id = map['category_id'],
        name = map['category_name'],
        type = map['transaction_type'];
}
