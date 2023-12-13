import 'package:flutter/material.dart';
import '../models/stream_user_model.dart';
import '../modelsView/user_insert_edit_view.dart';

class UserEditInsertPage extends StatelessWidget {
  final StreamUser? user;
  const UserEditInsertPage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Insira/Edite o usuário!!")),
      body: UserInsertEditView(user: user),
    );
  }
}
