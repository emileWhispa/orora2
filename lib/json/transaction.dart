class Transaction {
  String id;
  String farmId;
  String date;
  num? amount;
  String? notes;
  String? type;
  String? name;
  String? category;
  String? categoryId;

  Transaction.fromJson(Map<String, dynamic> map)
      : id = map['transaction_id'],
        amount = num.tryParse("${map['transaction_amount']}"),
  type = map['transaction_type'],
        farmId = map['farm_id'],
  notes = map['transaction_notes'],
  category = map['category_name'],
  categoryId = map['category_id'],
  name = map['transaction_name'],
        date = map['transaction_date'];
}
