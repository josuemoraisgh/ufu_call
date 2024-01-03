import 'package:flutter/cupertino.dart';

final Map<String, String> caracterMap = {
  "â": "a",
  "à": "a",
  "á": "a",
  "ã": "a",
  "ê": "e",
  "è": "e",
  "é": "e",
  "î": "i",
  "ì": "i",
  "í": "i",
  "õ": "o",
  "ô": "o",
  "ò": "o",
  "ó": "o",
  "ü": "u",
  "û": "u",
  "ú": "u",
  "ù": "u",
  "ç": "c"
};

class Styles {
  static const TextStyle linhaProdutoNomeDoItem = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontSize: 15,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle linhaProdutoTotal = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle linhaProdutoPrecoDoItem = TextStyle(
    color: Color(0xFF8E8E93),
    fontSize: 13,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle textoTempoEntrega = TextStyle(
    color: Color(0xFFC2C2C2),
    fontWeight: FontWeight.w300,
  );

  static const TextStyle tempoEntrega = TextStyle(
    color: CupertinoColors.inactiveGray,
  );

  static const Color linhaProdutoDivisor = Color(0xFFD9D9D9);

  static const Color fundoScaffold = Color(0xfff0f0f0);
}

class APIConstants {
  // ignore: constant_identifier_names
  static const String OCTET_STREAM_ENCODING = "application/octet-stream";
  // ignore: constant_identifier_names
  static const String API_BASE_URL = "https://moodle.ufu.br/";
}

class APIOperations {
  // ignore: constant_identifier_names
  static const String LOGIN = "login";
  // ignore: constant_identifier_names
  static const String REGISTER = "register";
  // ignore: constant_identifier_names
  static const String CHANGE_PASSWORD = "chgPass";
  // ignore: constant_identifier_names
  static const String SUCCESS = "success";
  // ignore: constant_identifier_names
  static const String FAILURE = "failure";

  static const String fetchUserDetail =
      "webservice/rest/server.php?wsfunction=core_webservice_get_site_info&moodlewsrestformat=json";
  static const String getTokenByLogin =
      "login/token.php?service=moodle_mobile_app&moodlewsrestformat=json";
  static const String getPublicConfig =
      "lib/ajax/service.php?info=tool_mobile_get_public_config";
  static const String getCourseContent =
      "webservice/rest/server.php?wsfunction=core_webservice_get_site_info&moodlewsrestformat=json";
  static const String getUsersByCourseId =
      "webservice/rest/server.php?wsfunction=core_enrol_get_enrolled_users&moodlewsrestformat=json";
  static const String getUserCourses =
      "webservice/rest/server.php?wsfunction=core_enrol_get_users_courses&moodlewsrestformat=json";
  static const String getCourses =
      "webservice/rest/server.php?wsfunction=core_course_get_courses&moodlewsrestformat=json";
  static const String getCategories =
      "webservice/rest/server.php?wsfunction=core_course_get_categories&moodlewsrestformat=json";
}

class EventConstants {
  // ignore: constant_identifier_names
  static const int NO_INTERNET_CONNECTION = 0;
  // ignore: constant_identifier_names
  static const int LOGIN_USER_SUCCESSFUL = 500;
  // ignore: constant_identifier_names
  static const int LOGIN_USER_UN_SUCCESSFUL = 501;
  // ignore: constant_identifier_names
  static const int USER_REGISTRATION_SUCCESSFUL = 502;
  // ignore: constant_identifier_names
  static const int USER_REGISTRATION_UN_SUCCESSFUL = 503;
  // ignore: constant_identifier_names
  static const int USER_ALREADY_REGISTERED = 504;
  // ignore: constant_identifier_names
  static const int CHANGE_PASSWORD_SUCCESSFUL = 505;
  // ignore: constant_identifier_names
  static const int CHANGE_PASSWORD_UN_SUCCESSFUL = 506;
  // ignore: constant_identifier_names
  static const int INVALID_OLD_PASSWORD = 507;
}

class APIResponseCode {
  // ignore: constant_identifier_names
  static const int SC_OK = 200;
}

class ConfigureKeys {
  // ignore: constant_identifier_names
  static const String IS_USER_LOGGED_IN = "is_user_logged_in";
  // ignore: constant_identifier_names
  static const String APP_USER = "app_user";
  // ignore: constant_identifier_names
  static const String USER_TOKEN = "user_token";
  // ignore: constant_identifier_names
  static const String DARK_MODE = "dark_mode";
  // ignore: constant_identifier_names
  static const String SITE_NAME = "site_name";
  // ignore: constant_identifier_names
  static const String SITE_URL = "site_url";
  // ignore: constant_identifier_names
  static const String COURSE_SEL = "course_sel";
  // ignore: constant_identifier_names
  static const String MAP_SYNC = "map_sync";
}

class ProgressDialogTitles {
  // ignore: constant_identifier_names
  static const String IN_PROGRESS = "In Progress...";
  // ignore: constant_identifier_names
  static const String USER_LOG_IN = "Logging In...";
  // ignore: constant_identifier_names
  static const String USER_CHANGE_PASSWORD = "Changing...";
  // ignore: constant_identifier_names
  static const String USER_REGISTER = "Registering...";
  // ignore: constant_identifier_names
  static const String checking_site = "Checking Site";
  // ignore: constant_identifier_names
  static const String login_progress_authenticating = "Authenticating";
  // ignore: constant_identifier_names
  static const String login_progress_fetch_detail = "Fetching user details";
  // ignore: constant_identifier_names
  static const String login_progress_fetch_category_list =
      "Fetching category list";
  // ignore: constant_identifier_names
  static const String login_progress_fetch_course_list = "Fetching course list";
  // ignore: constant_identifier_names
  static const String login_progress_fetch_course_contents =
      "Fetching course contents";
}

class SnackBarText {
  // ignore: constant_identifier_names
  static const String NO_INTERNET_CONNECTION = "No Internet Conenction";
  // ignore: constant_identifier_names
  static const String LOGIN_SUCCESSFUL = "Login Successful";
  // ignore: constant_identifier_names
  static const String LOGIN_UN_SUCCESSFUL = "Login Un Successful";
  // ignore: constant_identifier_names
  static const String CHANGE_PASSWORD_SUCCESSFUL = "Change Password Successful";
  // ignore: constant_identifier_names
  static const String CHANGE_PASSWORD_UN_SUCCESSFUL =
      "Change Password Un Successful";
  // ignore: constant_identifier_names
  static const String REGISTER_SUCCESSFUL = "Register Successful";
  // ignore: constant_identifier_names
  static const String REGISTER_UN_SUCCESSFUL = "Register Un Successful";
  // ignore: constant_identifier_names
  static const String USER_ALREADY_REGISTERED = "User Already Registered";
  // ignore: constant_identifier_names
  static const String ENTER_USERNAME = "Please Enter your Username";
  // ignore: constant_identifier_names
  static const String ENTER_PASS = "Please Enter your Password";
  // ignore: constant_identifier_names
  static const String ENTER_NEW_PASS = "Please Enter your New Password";
  // ignore: constant_identifier_names
  static const String ENTER_OLD_PASS = "Please Enter your Old Password";
  // ignore: constant_identifier_names
  static const String ENTER_EMAIL = "Please Enter your Email Id";
  // ignore: constant_identifier_names
  static const String ENTER_VALID_MAIL = "Please Enter Valid Email Id";
  // ignore: constant_identifier_names
  static const String ENTER_NAME = "Please Enter your Name";
  // ignore: constant_identifier_names
  static const String INVALID_OLD_PASSWORD = "Invalid Old Password";
}

class Texts {
  // ignore: constant_identifier_names
  static const String APP_NAME = "Cursos do Moodle";
  // ignore: constant_identifier_names
  static const String REGISTER_NOW = "Register Now!";
  // ignore: constant_identifier_names
  static const String NEW_USER = "Don't have an account?";
  // ignore: constant_identifier_names
  static const String OLD_USER = "Already Registered?";
  // ignore: constant_identifier_names
  static const String PLEASE_LOGIN =
      "Please enter your username and password to login";
  // ignore: constant_identifier_names
  static const String LOGIN_NOW = "Login Now!";
  // ignore: constant_identifier_names
  static const String LOGIN = "LOGIN";
  // ignore: constant_identifier_names
  static const String REGISTER = "REGISTER";
  // ignore: constant_identifier_names
  static const String PASSWORD = "Password";
  // ignore: constant_identifier_names
  static const String OLD_PASSWORD = "Old Password";
  // ignore: constant_identifier_names
  static const String NEW_PASSWORD = "New Password";
  // ignore: constant_identifier_names
  static const String CHANGE_PASSWORD = "CHANGE PASSWORD";
  // ignore: constant_identifier_names
  static const String LOGOUT = "LOGOUT";
  // ignore: constant_identifier_names
  static const String EMAIL = "Email Address";
  // ignore: constant_identifier_names
  static const String USERNAME = "Username";
  // ignore: constant_identifier_names
  static const String NOT_A_USERNAME = "Enter a valid username";
  // ignore: constant_identifier_names
  static const String NOT_A_PASSWORD = "Enter a valid password";
  // ignore: constant_identifier_names
  static const String NAME = "Name";
}
