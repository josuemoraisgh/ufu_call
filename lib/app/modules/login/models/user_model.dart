import 'package:hive_flutter/hive_flutter.dart';
part 'user_model.g.dart';

@HiveType(typeId: 1, adapterName: 'UserAdapter')
class User extends HiveObject {
  @HiveField(0)
  String username;
  @HiveField(1)
  String firstname;
  @HiveField(2)
  String lastname;
  @HiveField(3)
  String lang;
  @HiveField(4)
  int userid;
  @HiveField(5)
  String userpictureurl;

  User(
      {required this.username,
      required this.firstname,
      required this.lastname,
      required this.lang,
      required this.userid,
      required this.userpictureurl});

  User.fromJson(Map<String, dynamic> json)
      : username = json['username'] as String,
        firstname = json['firstname'] as String,
        lastname = json['lastname'] as String,
        lang = json['lang'] as String,
        userid = json['userid'] as int,
        userpictureurl = json['userpictureurl'] as String;

  Map<String, dynamic> toJson() => {
        'username': username,
        'firstname': firstname,
        'lastname': lastname,
        'lang': lang,
        'userid': userid,
        'userpictureurl': userpictureurl,
      };
}
