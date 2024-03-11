import 'dart:convert';
import 'dart:developer';
import 'dart:io';


import 'package:fakestore/keep/localstorage.dart';
import 'package:http/http.dart' as http;
class ServerHelper {
 
  static const ip = 'https://fakestoreapi.com';
  static Future<dynamic> post(url, data) async {
    var token = await LocalStorage.getToken();
    log(url.toString());

    Map sendData = {};
    if (data?.isNotEmpty ?? false) {
      sendData.addAll(data);
    }
    var body = json.encode(sendData);
    dynamic response;
    try {
      response = await http.post(Uri.parse(ip + url),
          headers: {"Content-Type": "application/json", "token": token ?? ""},
          body: body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        var error = {
          "status": false,
          "msg": "Invalid Request - statusCode ${response.statusCode}"
        };
        return error;
      }
    } on Exception catch (e) {
      log('Server exception $e');
  
    }
  }

  static Future<dynamic> get(url) async {
    try {
      var token = await LocalStorage.getToken();

      log(url.toString());
      var response = await http.get(
        Uri.parse(ip + url),
        headers: {"Content-Type": "application/json", "token": token ?? ""},
      );
      if (response.statusCode == 200) {
        log(response.contentLength.toString());
        return jsonDecode(response.body);
      } else {
        var error = {
          "status": false,
          "msg": "Invalid Request",
        };
        return error;
      }
    } on Exception catch (e) {
      log(e.toString());
      // throw NoHostException();
    }
  }

 


}
