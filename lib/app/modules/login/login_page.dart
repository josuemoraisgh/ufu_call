import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../utils/constants.dart';
import '../../utils/models/token_model.dart';
import '../../utils/models/user_model.dart';
import 'login_controller.dart';
import '../../utils/models/event_object.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final globalKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey();
  final LoginController controller = Modular.get<LoginController>();
  Token? userToken;
  var usernameController = TextEditingController(text: "");
  var passwordController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.init(),
      builder: (context, isUserLoggedIn) => isUserLoggedIn.hasData
          ? Scaffold(
              key: globalKey,
              backgroundColor: Colors.white,
              body: _loginContainer(context),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _loginContainer(BuildContext context) {
    return ListView(
      children: <Widget>[
        Center(
          child: Column(
            children: <Widget>[
              _appIcon(),
              _loginNowLabel(),
              _formContainer(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _appIcon() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: const Image(
        image: AssetImage("assets/icon/ufuIcon.png"),
        height: 170.0,
        width: 170.0,
      ),
    );
  }

  Widget _loginNowLabel() {
    return const Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0),
      child: Center(
        child: Text(
          Texts.PLEASE_LOGIN,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Widget _formContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
      child: Column(children: <Widget>[
        FormBuilder(
          key: _formKey,
          child: Column(
            children: <Widget>[_usernameContainer(), _passwordContainer()],
          ),
        ),
        _loginButtonContainer(context),
      ]),
    );
  }

  Widget _usernameContainer() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: Center(
        child: FormBuilderTextField(
          name: 'username',
          controller: usernameController,
          decoration: InputDecoration(
            labelText: Texts.USERNAME,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            prefixIcon: Icon(
              Icons.email,
              color: Colors.blue[500],
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordContainer() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Center(
        child: FormBuilderTextField(
          name: 'password',
          controller: passwordController,
          decoration: InputDecoration(
            labelText: Texts.PASSWORD,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            prefixIcon: Icon(
              Icons.vpn_key,
              color: Colors.blue[500],
            ),
          ),
          keyboardType: TextInputType.text,
          obscureText: true,
        ),
      ),
    );
  }

  Widget _loginButtonContainer(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(25.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.blue[500],
              borderRadius: BorderRadius.circular(5.0)),
          margin: const EdgeInsets.only(bottom: 30.0),
          child: MaterialButton(
            textColor: Colors.white,
            padding: const EdgeInsets.all(15.0),
            onPressed: () => _loginButtonAction(context),
            child: const Text(
              Texts.LOGIN,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
          ),
        ));
  }

  void _loginButtonAction(BuildContext context) {
    if (usernameController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(SnackBarText.ENTER_USERNAME),
      ));
      return;
    }

    if (passwordController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(SnackBarText.ENTER_PASS),
      ));
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Iniciando conexão!!')),
    );
    _getUserToken(context, usernameController.text, passwordController.text);
  }

  void _getUserToken(
      BuildContext context, String username, String password) async {
    EventObject eventObject =
        await controller.moodleProvider.getTokenByLogin(username, password);
    switch (eventObject.id) {
      case EventConstants.LOGIN_USER_SUCCESSFUL:
        {
          setState(() {
            userToken = eventObject.object as Token;
            controller.moodleLocalStorage.setUserToken(userToken!);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(SnackBarText.LOGIN_SUCCESSFUL)),
            );
            _userDetailsAction();
          });
        }
        break;
      case EventConstants.LOGIN_USER_UN_SUCCESSFUL:
        {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(SnackBarText.LOGIN_UN_SUCCESSFUL),
            ));
          });
        }
        break;
      case EventConstants.NO_INTERNET_CONNECTION:
        {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(SnackBarText.NO_INTERNET_CONNECTION),
            ));
          });
        }
        break;
    }
  }

  void _userDetailsAction() {
    FocusScope.of(context).requestFocus(FocusNode());
    _getUserDetails();
  }

  void _getUserDetails() async {
    EventObject eventObject =
        await controller.moodleProvider.fetchUserDetail(userToken!);
    switch (eventObject.id) {
      case EventConstants.LOGIN_USER_SUCCESSFUL:
        {
          controller.moodleLocalStorage.setUserLoggedIn(true);
          controller.moodleLocalStorage
              .setUserProfile(eventObject.object as User);
          Modular.to.pushNamed("/home/");
        }
        break;
      case EventConstants.LOGIN_USER_UN_SUCCESSFUL:
        {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(SnackBarText.LOGIN_UN_SUCCESSFUL),
            ));
          });
        }
        break;
      case EventConstants.NO_INTERNET_CONNECTION:
        {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(SnackBarText.NO_INTERNET_CONNECTION),
            ));
          });
        }
        break;
    }
  }
}
