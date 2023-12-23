import 'package:hive_flutter/hive_flutter.dart';
part 'students_model.g.dart';

@HiveType(typeId: 2, adapterName: 'UserAdapter')
class Students extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String firstname;
  @HiveField(2)
  String lastname;
  @HiveField(3)
  String email;
  @HiveField(4)
  String photoName;
  @HiveField(5)
  Map<String, String>? chamada;
  @HiveField(6)
  List<double>? fotoPoints;
  @HiveField(7)
  List<int>? photoIntList;

  Students(
      {required this.id,
      required this.firstname,
      required this.lastname,
      required this.email,
      required this.photoName,
      this.chamada,
      this.fotoPoints,
      this.photoIntList});

  Students.empty()
      : id = -1,
        firstname = "",
        lastname = "",
        email = "",
        photoName = "",
        chamada = {},
        fotoPoints = [],
        photoIntList = [];

  Students.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        firstname = json['firstname'] as String,
        lastname = json['lastname'] as String,
        email = json['email'] as String,
        photoName = json['profileimageurl'] as String,
        chamada = {},
        fotoPoints = [],
        photoIntList = [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'profileimageurl': photoName,
        'chamada': chamada,
      };
}
