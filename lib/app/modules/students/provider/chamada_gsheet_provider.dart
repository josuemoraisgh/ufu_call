import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChamadaGsheetProvider {
  late final Dio provider;
  final String baseUrl = 'https://script.google.com';
  static int _countConnection = 0;

  ChamadaGsheetProvider({Dio? provider}) {
    this.provider = provider ?? Modular.get<Dio>();
  }

  Future<dynamic> sendGet(
      {required String table,
      required String func,
      required String userId,
      required String header}) async {
    while (_countConnection >= 10) {
      //so faz 10 requisições por vez.
      await Future.delayed(const Duration(milliseconds: 500));
    }
    _countConnection++;
    var response = await provider.get(
      '$baseUrl/macros/s/AKfycbz4YPsxKO5R9y5hWo0WRaRIEdRxcsjdRWKc_7ktlmdDghXiuy2CzJCjaNhSrNyVF4mg/exec',
      queryParameters: {
        "table": table,
        "func": func,
        "userId": userId,
        "header": header,
      },
    );
    _countConnection--;
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
    return null;
  }

  Future<dynamic> sendPost(
      {required String table,
      required String func,
      dynamic value}) async {
    while (_countConnection >= 15) {
      //faz apenas 15 requisições por vez.
      await Future.delayed(const Duration(milliseconds: 500));
    }
    _countConnection++;
    Response response = await provider.post(
      '$baseUrl/macros/s/AKfycbz4YPsxKO5R9y5hWo0WRaRIEdRxcsjdRWKc_7ktlmdDghXiuy2CzJCjaNhSrNyVF4mg/exec',
      queryParameters: {
        "table": table,
        "func": func,
      },
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          }),
      /*options: Options(
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
      ),*/
      //data: FormData.fromMap({'p3': await MultipartFile.fromFile('./text.txt',filename: 'upload.txt')}),
      data: jsonEncode(value ?? ""),
    );
    _countConnection--;
    if (response.statusCode == 302) {
      var location = response.headers["location"];
      while (_countConnection >= 15) {
        //faz apenas 15 requisições por vez.
        await Future.delayed(const Duration(milliseconds: 500));
      }
      _countConnection++;
      response = await provider.get(location![0]);
      _countConnection--;
    }
    dynamic resp;
    if (response.statusCode == 200) {
      var map = response.data as Map;
      if ((map["status"] ?? "Error") == "SUCCESS") {
        resp = map["items"];
      } else {
        debugPrint("POST ERROR - ${map["status"]}");
      }
    } else {
      debugPrint("POST ERROR - $response");
    }
    return resp;
  }

//Funcão "put" pode inserir valores de cinco formas diferentes
//1º Se variável nome e date forem vazios, insere conforme o Map enviado.
//2º Se variável nome for vazio, insere a coluna de date da tabela.
//3º Se variável date for vazio, insere a linha de nome da tabela.
//4º Se tem todas as variáveis, insere no lugar específico.
//5º Se tem a Variável "nome" e/ou "date" mas não tem "value", insere apenas a coluna "nome" e/ou "date".
  Future<bool> put(
      {required String table,
      String userName = "",
      String date = "",
      dynamic value = ""}) async {
    final resp = await sendPost(
      table: table,
      func: 'put',
      value: value,
    );
    return resp;
  }

//Funcão "get" pode retornar valores de quatro formas diferentes
//1º Se variável nome e date forem vazios, retorna o JSON das linha de toda a tabela.
//2º Se variável nome for vazio, retorna o JSON da coluna de date da tabela.
//3º Se variável date for vazio, retorna o JSON da linha de nome da tabela.
//4º Se tem todas as variáveis, retorna o JSON "value" do item escolhido.
  Future<Map<String, dynamic>> get(
      {required String table, String userId = "", String header = ""}) async {
    final resp = await sendGet(
      table: table,
      func: 'get',
      userId: userId,
      header: header,
    );
    return resp;
  }

//Funcão "dell" pode deletar valores de quatro formas diferentes
//1º Se variável nome e date forem vazios, limpa a tabela.
//2º Se variável nome for vazio, limpa a coluna de date da tabela.
//3º Se variável date for vazio, limpa a linha de nome da tabela.
//4º Se tem todas as variáveis, limpa um lugar específico.
  Future<bool> del(
      {required String table, String userId = "", String header = ""}) async {
    final resp = await sendGet(
      table: table,
      func: 'del',
      userId: "",
      header: header,
    );
    return resp;
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
