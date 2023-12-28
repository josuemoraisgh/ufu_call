class Students {
  int id;
  String firstname;
  String lastname;
  String email;
  String photoName;
  Map<String, String>? chamada;
  List<double>? fotoPoints;

  Students(
      {required this.id,
      required this.firstname,
      required this.lastname,
      required this.email,
      required this.photoName,
      this.chamada,
      this.fotoPoints});

  Students.empty()
      : id = -1,
        firstname = "",
        lastname = "",
        email = "",
        photoName = "",
        chamada = {},
        fotoPoints = [];

  Students.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        firstname = json['firstname'] as String,
        lastname = json['lastname'] as String,
        email = json['email'] as String,
        photoName = json['profileimageurl'] as String,
        chamada = {},
        fotoPoints = [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'profileimageurl': photoName,
        'chamada': chamada,
      };
}
