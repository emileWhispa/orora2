class Farm {
  String id;
  String name;
  int livestocks;
  String sector;
  String? picture;
  String? provinceId;
  String? districtId;
  String? sectorId;
  String? categoryId;
  String? budgetType;
  num? budgetAmount;

  Farm.fromJson(Map<String, dynamic> map)
      : id = map['farm_id'],
        name = map['farm_name'],
        provinceId = map['province_id'],
        districtId = map['district_id'],
        sectorId = map['sector_id'],
        categoryId = map['category_id'],
        budgetType = map['budget_type'],
        budgetAmount = num.tryParse(map['budget_amount']??""),
        picture = map['farm_profile_picture'] ?? "",
        livestocks = map['livestocks'] ?? 0,
        sector = map['sector_name'];
}
