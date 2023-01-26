

class User {
  static User? user;

  String id;
  String? fName;
  String? lName;
  String? email;
  String phone;
  String status;
  String token;
  DateTime? regDate;

  User.fromJson(Map<String, dynamic> map)
      :id = map['user_id'],
        fName = map['user_fname'],
        lName = map['user_lname'],
        email = map['user_email'],
        phone = map['user_phone'],
        status = map['user_status'],
  regDate = DateTime.parse(map['user_reg_date']),
        token = map['user_token'];


  String get display=>"${fName??""} ${lName??""}";
  String get initials=>"${fName != null && fName!.length>1 ? fName!.substring(0,1) : ""} ${lName != null && lName!.length>1 ?lName!.substring(0,1) : ""}";
}