class Feed{
  String id;
  String? name;
  Feed.fromJson(Map<String,dynamic> map):id = map['feed_id'],name = map['feed_name'];

  Feed(this.name,{this.id = "0"});
}