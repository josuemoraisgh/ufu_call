import 'package:hive_flutter/hive_flutter.dart';
part 'students_model.g.dart';

@HiveType(typeId: 2, adapterName: 'UserAdapter')
class User extends HiveObject {
  @HiveField(0)  
  int id;
  @HiveField(1)
  String firstname;
  @HiveField(2)
  String lastname;
  @HiveField(3)
  String email;  
  @HiveField(4)
  String profileimageurl;

  User(
      {required this.id,
      required this.firstname,
      required this.lastname,
      required this.email,
      required this.profileimageurl});

  User.empty()
      : id = -1,
        firstname = "",
        lastname = "",
        email = "",
        profileimageurl = "";

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        firstname = json['firstname'] as String,
        lastname = json['lastname'] as String,
        email = json['email'] as String,
        profileimageurl = json['profileimageurl'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'profileimageurl': profileimageurl,
      };
}
