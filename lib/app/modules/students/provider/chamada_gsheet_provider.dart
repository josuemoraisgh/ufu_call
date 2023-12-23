import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChamadaGsheetProvider {
  late final Dio provider;
  final String baseUrl = 'https://script.google.com';
  //static int _countConnection = 0;

  ChamadaGsheetProvider({Dio? provider}) {
    this.provider = provider ?? Modular.get<Dio>();
  }

  Future<dynamic> sendGet(
      {required String table,
      required String func,
      required String userName,
      required String date,
      String? value}) async {
    //while (_countConnection >= 15) {
    //so faz 10 requisições por vez.
    // await Future.delayed(const Duration(milliseconds: 500));
    //}
    //_countConnection++;
    var response = await provider.get(
      '$baseUrl/macros/s/AKfycbz4YPsxKO5R9y5hWo0WRaRIEdRxcsjdRWKc_7ktlmdDghXiuy2CzJCjaNhSrNyVF4mg/exec',
      queryParameters: {
        "table": table,
        "func": func,
        "userName": userName,
        "date": date,
        "value": value ?? "",
      },
    );
    try {
      if (response.data is Map) {
        var map = response.data as Map;
        if ((map["status"] ?? "ERROR") == "SUCCESS") {
          return map["items"];
        } else {
          debugPrint("ChamadaGsheetProvider - sendGet - ${map["status"]}");
        }
      } else {
        debugPrint("ChamadaGsheetProvider - sendGet - $response");
      }
    } catch (e) {
      debugPrint("ChamadaGsheetProvider - sendGet - $response");
    }
    //_countConnection--;
    return null;
  }

  Future<String> putItem(
      {required String table,
      required String userName,
      required String date,
      required String value}) async {
    final resp = await sendGet(
      table: table,
      func: 'put',
      userName: userName,
      date: date,
      value: value,
    );
    return resp.toString();
  }

  Future<List<String>> getItem(
      {required String table,
      required String userName,
      required String date}) async {
    final List resp = await sendGet(
      table: table,
      func: 'get',
      userName: userName,
      date: date,
    );
    return resp.map((e) => e.toString()).toList();
  }

  Future<Uint8List?> getFile(String url) async {
    var response = await provider.get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    if (response.statusCode == 200) {
      final uil = response.data;
      return uil;
    }
    return null;
  }
}
