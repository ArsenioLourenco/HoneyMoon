import 'package:flutter/material.dart';
import 'package:honeymoon_delicious/src/models/category.dart';
import 'package:honeymoon_delicious/src/models/product.dart';
import 'package:honeymoon_delicious/src/models/user.dart';
import 'package:honeymoon_delicious/src/pages/client/products/details/client_products_detail_page.dart';
import 'package:honeymoon_delicious/src/pages/login/utils/shared_pref.dart';
import 'package:honeymoon_delicious/src/provider/categories_provider.dart';
import 'package:honeymoon_delicious/src/provider/products_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientProductListController {
  BuildContext context;
  SharedPref _sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  Function refresh;
  User user;

  CategoriesProvider _categoriesProvider = CategoriesProvider();
  ProductsProvider _productsProvider = ProductsProvider();
  List<Category> categories = [];

  Future init(BuildContext context, Function refresh) async {
    this.context;
    this.refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _categoriesProvider.init(context, user);
    _productsProvider.init(context, user);
    getCategories();
    refresh();
  }

  Future<List<Product>> getProducts(String idCategory) async {
    return await _productsProvider.getByCategory(idCategory);
  }

  void getCategories() async {
    categories = await _categoriesProvider.getAll();
    //refresh();
  }

  void openBottomSheet(BuildContext context, Product product) {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => ClientProductsDetailPage(
              product: product,
            ));
  }

  void logout(BuildContext context) {
    _sharedPref.logout(context, user.id);
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  void goToUpdatePage(BuildContext context) {
    Navigator.pushNamed(context, 'client/update');
  }

  void goToOrdersCreatePage(BuildContext context) {
    Navigator.pushNamed(context, 'client/orders/create');
  }

  void goToRoles(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }
}
