class Production {
  String id;
  String date;
  num quantity;
  String tag;
  String? notes;
  String? category;

  Production.fromJson(Map<String, dynamic> map)
      : id = map['production_id'],
  quantity = num.tryParse("${map['production_quantity']}") ?? 0,
  notes = map['production_notes'],
  tag = map['brucellosis_tag'],
  category = map['production_category'],
        date = map['production_date'];
}
