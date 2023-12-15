import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../utils/constants.dart';
import 'login_controller.dart';
import '../../utils/models/event_object.dart';
import 'models/user_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final globalKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey();
  final LoginController controller = Modular.get<LoginController>();
  String userToken = "";
  var usernameController = TextEditingController(text: "");
  var passwordController = TextEditingController(text: "");

  Future<bool> init() async {
    await controller.moodleLocalStorage.init();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: false,
        future: init(),
        builder: (context, isInit) => Scaffold(
              key: globalKey,
              backgroundColor: Colors.white,
              body: isInit.data == true
                  ? _loginContainer()
                  : const Center(child: CircularProgressIndicator()),
            ));
  }

  Widget _loginContainer() {
    return ListView(
      children: <Widget>[
        Center(
          child: Column(
            children: <Widget>[
              _appIcon(),
              _loginNowLabel(),
              _formContainer(),
              _notRegisterdLabel(),
              _registerNowLabel(),
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

  Widget _formContainer() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
      child: Column(children: <Widget>[
        FormBuilder(
          key: _formKey,
          child: Column(
            children: <Widget>[_usernameContainer(), _passwordContainer()],
          ),
        ),
        _loginButtonContainer(),
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

  Widget _loginButtonContainer() {
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
            onPressed: _loginButtonAction,
            child: const Text(
              Texts.LOGIN,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
          ),
        ));
  }

  Widget _notRegisterdLabel() {
    return const Text(
      Texts.NEW_USER,
      style: TextStyle(fontSize: 25.0),
    );
  }

  Widget _registerNowLabel() {
    return GestureDetector(
      onTap: null,
      child: Container(
          margin: const EdgeInsets.only(bottom: 30.0),
          child: Text(
            Texts.REGISTER_NOW,
            style: TextStyle(fontSize: 25.0, color: Colors.blue[500]),
          )),
    );
  }

  void _loginButtonAction() {
    if (usernameController.text == "") {
      //globalKey.currentState.showSnackBar(new SnackBar(
      //  content: new Text(SnackBarText.ENTER_USERNAME),
      //));
      return;
    }

    if (passwordController.text == "") {
      // globalKey.currentState.showSnackBar(new SnackBar(
      //  content: new Text(SnackBarText.ENTER_PASS),
      //));
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    _getUserToken(usernameController.text, passwordController.text);
  }

  void _getUserToken(String username, String password) async {
    EventObject eventObject =
        await controller.moodleProvider.getTokenByLogin(username, password);
    switch (eventObject.id) {
      case EventConstants.LOGIN_USER_SUCCESSFUL:
        {
          setState(() async {
            userToken = eventObject.object as String;
            await controller.moodleLocalStorage.setUserToken(userToken);
            // globalKey.currentState.showSnackBar(new SnackBar(
            ///  content: new Text(SnackBarText.LOGIN_SUCCESSFUL),
            // ));
            _userDetailsAction();
          });
        }
        break;
      case EventConstants.LOGIN_USER_UN_SUCCESSFUL:
        {
          setState(() {
            //globalKey.currentState.showSnackBar(new SnackBar(
            //   content: new Text(SnackBarText.LOGIN_UN_SUCCESSFUL),
            //));
          });
        }
        break;
      case EventConstants.NO_INTERNET_CONNECTION:
        {
          setState(() {
            // globalKey.currentState.showSnackBar(new SnackBar(
            //  content: new Text(SnackBarText.NO_INTERNET_CONNECTION),
            // ));
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
        await controller.moodleProvider.fetchUserDetail(userToken);
    switch (eventObject.id) {
      case EventConstants.LOGIN_USER_SUCCESSFUL:
        {
          setState(() async {
            await controller.moodleLocalStorage.setUserLoggedIn(true);
            await controller.moodleLocalStorage
                .setUserProfile(eventObject.object as User);
            //globalKey.currentState.showSnackBar(new SnackBar(
            //  content: new Text(SnackBarText.LOGIN_SUCCESSFUL),
            //));
            Modular.to.pushNamed("/home/");
          });
        }
        break;
      case EventConstants.LOGIN_USER_UN_SUCCESSFUL:
        {
          setState(() {
            //globalKey.currentState.showSnackBar(new SnackBar(
            //  content: new Text(SnackBarText.LOGIN_UN_SUCCESSFUL),
            //));
          });
        }
        break;
      case EventConstants.NO_INTERNET_CONNECTION:
        {
          setState(() {
            // globalKey.currentState.showSnackBar(new SnackBar(
            //   content: new Text(SnackBarText.NO_INTERNET_CONNECTION),
            // ));
          });
        }
        break;
    }
  }
}
