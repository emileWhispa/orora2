class Feed {
  String id;
  String? name;
  String? activity;
  num? activityQty;
  String? activityDate;
  String? notes;

  Feed.fromJson(Map<String, dynamic> map)
      : id = map['feed_id'],
  activity = map['activity'],
  activityDate = map['activity_date'],
        notes = map['notes'],
  activityQty = num.tryParse(map['activity_quantity']??""),
        name = map['feed_name'];

  Feed(this.name, {this.id = "0"});
}
