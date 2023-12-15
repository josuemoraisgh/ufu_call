import 'package:hive_flutter/hive_flutter.dart';
part 'token_model.g.dart';

@HiveType(typeId: 0, adapterName: 'TokenAdapter')
class Token extends HiveObject {
  @HiveField(0)
  String token;
  @HiveField(1)
  String privatetoken;

  Token({required this.token, required this.privatetoken});
  Token.empty()
      : token = "",
        privatetoken = "";

  Token.fromJson(Map<String, dynamic> json)
      : token = json['token'] as String,
        privatetoken = json['privatetoken'] as String;

  Map<String, dynamic> toJson() => {
        'token': token,
        'privatetoken': privatetoken,
      };
}
