import 'package:flutter/material.dart';
import 'package:honeymoon_delicious/src/pages/client/address/create/client_address_create_page.dart';
import 'package:honeymoon_delicious/src/pages/client/address/list/client_address_list_page.dart';
import 'package:honeymoon_delicious/src/pages/client/address/map/client_address_map_page.dart';
import 'package:honeymoon_delicious/src/pages/client/orders/create/client_orders_create_page.dart';
import 'package:honeymoon_delicious/src/pages/client/products/list/client_products_list_page.dart';
import 'package:honeymoon_delicious/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:honeymoon_delicious/src/pages/login/login_page.dart';
import 'package:honeymoon_delicious/src/pages/login/utils/my_colors.dart';
import 'package:honeymoon_delicious/src/pages/register/register_page.dart';
import 'package:honeymoon_delicious/src/pages/restaurant/products/create/restaurant_products_create_page.dart';

import 'src/pages/client/update/client_update_page.dart';
import 'src/pages/restaurant/categories/create/restaurante_categories_create_page.dart';
import 'src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'src/pages/roles/roles_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  //const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HoneyMoon Delicious',
      initialRoute: 'login',
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'register': (BuildContext context) => RegisterPage(),
        'roles': (BuildContext context) => RolesPages(),
        'client/products/list': (BuildContext context) =>
            ClientProductListPage(),
        'client/update': (BuildContext context) => ClientUpdatePage(),
        'client/orders/create': (BuildContext context) =>
            ClientOrdersCreatePage(),
        'client/address/map': (BuildContext context) => ClientAddressMapPage(),
        'client/address/list': (BuildContext context) =>
            ClientAddressListPage(),
        'client/address/create': (BuildContext context) =>
            ClientAddressCreatePage(),
        'restaurant/orders/list': (BuildContext context) =>
            RestaurantOrdersListPage(),
        'restaurant/categories/create': (BuildContext context) =>
            RestaurantCategoriesCreatePage(),
        'restaurant/products/create': (BuildContext context) =>
            RestaurantProductsCreatePage(),
        'delivery/orders/list': (BuildContext context) =>
            DeliveryOrdersListPage(),
      },
      theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: MyColors.primaryColor,
          ),
          appBarTheme: AppBarTheme(elevation: 0)),
    );
  }
}
