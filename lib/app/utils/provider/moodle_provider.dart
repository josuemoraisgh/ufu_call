import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ufu_call/app/utils/models/course.dart';
import '../models/event_object.dart';
import '../constants.dart';
import '../models/token_model.dart';
import '../models/user_model.dart';

class MoodleProvider {
  late final Dio providerHttp;
  MoodleProvider({Dio? providerHttp}) {
    this.providerHttp = providerHttp ?? Modular.get<Dio>();
  }

  Future<EventObject> getTokenByLogin(String username, String password) async {
    String currentUrl =
        APIConstants.API_BASE_URL + APIOperations.getTokenByLogin;

    try {
      final response = await providerHttp.post(
        currentUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: {'username': username, 'password': password},
      );

      if (response.statusCode == APIResponseCode.SC_OK) {
        Token result = Token.fromJson(response.data);
        return EventObject(
            id: EventConstants.LOGIN_USER_SUCCESSFUL, object: result);
      } else {
        return EventObject(id: EventConstants.LOGIN_USER_UN_SUCCESSFUL);
      }
    } on Exception {
      return EventObject();
    }
  }

  Future<EventObject> fetchUserDetail(Token token) async {
    String currentUrl =
        '${APIConstants.API_BASE_URL}${APIOperations.fetchUserDetail}&wstoken=${token.token}';

    try {
      final response = await providerHttp.get(currentUrl);
      if (response.statusCode == APIResponseCode.SC_OK) {
        User user = User.fromJson(response.data);
        return EventObject(
            id: EventConstants.LOGIN_USER_SUCCESSFUL, object: user);
      } else {
        return EventObject(id: EventConstants.LOGIN_USER_UN_SUCCESSFUL);
      }
    } on Exception {
      return EventObject();
    }
  }

  Future<EventObject> getUserCourses(Token token, User user) async {
    String currentUrl =
        '${APIConstants.API_BASE_URL}${APIOperations.getUserCourses}&userid=${user.userid}&wstoken=${token.token}';

    try {
      final response = await providerHttp.get(currentUrl);
      if (response.statusCode == APIResponseCode.SC_OK) {
        List<Course> courses = <Course>[];
        for (var e in (response.data as List)) {
          courses.add(
            Course.fromJson(e),
          );
        }
        return EventObject(
            id: EventConstants.LOGIN_USER_SUCCESSFUL, object: courses);
      } else {
        return EventObject(id: EventConstants.LOGIN_USER_UN_SUCCESSFUL);
      }
    } on Exception {
      return EventObject();
    }
  }

  Future<EventObject> getUsersByCourseId(
      String courseId, Token token) async {
    String currentUrl =
        '${APIConstants.API_BASE_URL}${APIOperations.getUsersByCourseId}&courseid=$courseId&wstoken=${token.token}';

    try {
      final response = await providerHttp.get(currentUrl);
      if (response.statusCode == APIResponseCode.SC_OK) {
        List<Course> courses = <Course>[];
        for (var e in (response.data as List)) {
          courses.add(
            Course.fromJson(e),
          );
        }
        return EventObject(
            id: EventConstants.LOGIN_USER_SUCCESSFUL, object: courses);
      } else {
        return EventObject(id: EventConstants.LOGIN_USER_UN_SUCCESSFUL);
      }
    } on Exception {
      return EventObject();
    }
  }
  /*Future<EventObject> registerUser(
    String name, String emailId, String password) async {
 UserRequest userRequest = new UserRequest();
  User user = new User(firstname: name, lastname: emailId, username: password);

  userRequest.operation = APIOperations.REGISTER;
  userRequest.user = user;

  try {
    final encoding = APIConstants.OCTET_STREAM_ENCODING;
    final response = await http.post(APIConstants.API_BASE_URL,
        body: json.encode(userRequest.toJson()),
        encoding: Encoding.getByName(encoding));
    if (response != null) {
      if (response.statusCode == APIResponseCode.SC_OK &&
          response.body != null) {
        final responseJson = json.decode(response.body);
        UserResponse apiResponse = UserResponse.fromJson(responseJson);
        if (apiResponse.result == APIOperations.SUCCESS) {
          return new EventObject(
              id: EventConstants.USER_REGISTRATION_SUCCESSFUL, object: null);
        } else if (apiResponse.result == APIOperations.FAILURE) {
          return new EventObject(id: EventConstants.USER_ALREADY_REGISTERED);
        } else {
          return new EventObject(
              id: EventConstants.USER_REGISTRATION_UN_SUCCESSFUL);
        }
      } else {
        return new EventObject(
            id: EventConstants.USER_REGISTRATION_UN_SUCCESSFUL);
      }
    } else {
      return new EventObject();
    }
  } catch (Exception) {
    return EventObject();
  }
}

Future<EventObject> changePassword(
    String emailId, String oldPassword, String newPassword) async {
  UserRequest userRequest = new UserRequest();
  User user = new User(
      firstname: emailId, lastname: oldPassword, username: newPassword);

  userRequest.operation = APIOperations.CHANGE_PASSWORD;
  userRequest.user = user;

  try {
    final encoding = APIConstants.OCTET_STREAM_ENCODING;
    final response = await http.post(APIConstants.API_BASE_URL,
        body: json.encode(userRequest.toJson()),
        encoding: Encoding.getByName(encoding));
    if (response != null) {
      if (response.statusCode == APIResponseCode.SC_OK &&
          response.body != null) {
        final responseJson = json.decode(response.body);
        UserResponse apiResponse = UserResponse.fromJson(responseJson);
        if (apiResponse.result == APIOperations.SUCCESS) {
          return new EventObject(
              id: EventConstants.CHANGE_PASSWORD_SUCCESSFUL, object: null);
        } else if (apiResponse.result == APIOperations.FAILURE) {
          return new EventObject(id: EventConstants.INVALID_OLD_PASSWORD);
        } else {
          return new EventObject(
              id: EventConstants.CHANGE_PASSWORD_UN_SUCCESSFUL);
        }
      } else {
        return new EventObject(
            id: EventConstants.CHANGE_PASSWORD_UN_SUCCESSFUL);
      }
    } else {
      return new EventObject();
    }
  } catch (Exception) {
    return EventObject();
  }
}*/
}
