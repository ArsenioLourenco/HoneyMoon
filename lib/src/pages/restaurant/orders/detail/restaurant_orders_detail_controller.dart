import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:honeymoon_delicious/src/models/order.dart';
import 'package:honeymoon_delicious/src/models/product.dart';
import 'package:honeymoon_delicious/src/pages/login/utils/shared_pref.dart';

class RestaurantOrdersDetailController {
  BuildContext context;
  Function refresh;
  Product product;

  int counter = 1;
  double productPrice;

  SharedPref _sharedPref = SharedPref();

  double total = 0;
  Order order;

  Future init(BuildContext context, Function refresh, Order order) async {
    this.context = context;
    this.refresh = refresh;
    this.order = order;

    getTotal();
    refresh;
  }

  void getTotal() {
    total = 0;
    order.products.forEach((product) {
      total = total + (product.price * product.quantity);
    });

    refresh();
  }
}
