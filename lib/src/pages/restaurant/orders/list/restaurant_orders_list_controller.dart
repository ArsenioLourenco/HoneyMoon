import 'package:flutter/material.dart';
import 'package:honeymoon_delicious/src/models/order.dart';
import 'package:honeymoon_delicious/src/models/user.dart';
import 'package:honeymoon_delicious/src/pages/login/utils/shared_pref.dart';
import 'package:honeymoon_delicious/src/pages/restaurant/orders/detail/restaurant_orders_detail_page.dart';
import 'package:honeymoon_delicious/src/provider/orders_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RestaurantOrdersListController {
  BuildContext context;
  SharedPref _sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  Function refresh;
  User user;

  List<String> status = ['PAGO', 'DESPACHADO', 'A CAMINHO', 'ENTREGUE'];
  OrdersProvider _ordersProvider = OrdersProvider();

  Future init(BuildContext context, Function refresh) async {
    this.context;
    this.refresh;
    user = User.fromJson(await _sharedPref.read('user'));

    _ordersProvider.init(context, user);
    refresh();
  }

  Future<List<Order>> getOrders(String status) async {
    return await _ordersProvider.getByStatus(status);
  }

  void openBottomSheet(Order order, context) {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => RestaurantOrdersDetailPage(order: order));
  }

  void logout(BuildContext context) {
    _sharedPref.logout(context, user.id);
  }

  void goToCategoryCreate(BuildContext context) {
    Navigator.pushNamed(context, 'restaurant/categories/create');
  }

  void goToProductCreate(BuildContext context) {
    Navigator.pushNamed(context, 'restaurant/products/create');
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  void goToRoles(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }
}
