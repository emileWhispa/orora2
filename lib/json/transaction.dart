class Transaction {
  String id;
  String date;
  num? amount;
  String? notes;
  String? type;
  String? name;
  String? category;

  Transaction.fromJson(Map<String, dynamic> map)
      : id = map['transaction_id'],
        amount = num.tryParse("${map['transaction_amount']}"),
  type = map['transaction_type'],
  notes = map['transaction_notes'],
  category = map['category_name'],
  name = map['transaction_name'],
        date = map['transaction_date'];
}
