import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:honeymoon_delicious/src/api/environment.dart';
import 'package:honeymoon_delicious/src/api/response_api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:honeymoon_delicious/src/models/order.dart';
import 'package:honeymoon_delicious/src/models/user.dart';
import 'package:honeymoon_delicious/src/pages/login/utils/shared_pref.dart';
import 'package:http/http.dart' as http;

class OrdersProvider {
  String _url = Environment.API_DELIVERY;
  String _api = '/api/orders';
  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, User sessionUser) {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<List<Order>> getByStatus(String status) async {
    try {
      print('SESSION TOKEN: ${sessionUser.sessionToken}');
      Uri url = Uri.http(_url, '$_api/findByStatus/$status');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };

      final res = await http.get(url, headers: headers);
      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sessao expirada');
        SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body); //OBTENDO CATEGORIAS
      Order order = Order.fromJsonList(data);
      return order.toList;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<ResponseApi> create(Order order) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };

      final res = await http.post(url, headers: headers, body: bodyParams);
      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sessao expirada');
        SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
