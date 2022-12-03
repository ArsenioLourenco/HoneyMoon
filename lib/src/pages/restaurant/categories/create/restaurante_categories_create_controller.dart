import 'package:flutter/material.dart';
import 'package:honeymoon_delicious/src/api/response_api.dart';
import 'package:honeymoon_delicious/src/models/category.dart';
import 'package:honeymoon_delicious/src/models/user.dart';
import 'package:honeymoon_delicious/src/pages/login/utils/my_snackbar.dart';
import 'package:honeymoon_delicious/src/pages/login/utils/shared_pref.dart';
import 'package:honeymoon_delicious/src/provider/categories_provider.dart';

class RestaurantCategoriesCreateController {
  BuildContext context;
  Function refresh;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  CategoriesProvider _categoriesProvider = CategoriesProvider();
  User user;
  SharedPref sharedPref = SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.read('user'));
    _categoriesProvider.init(context, user);
  }

  void createCategory() async {
    String name = nameController.text;
    String description = descriptionController.text;

    if (name.isEmpty || description.isEmpty) {
      MySnackBar.show(context, 'Deves preencher todos os campos');
      return;
    }

    Category category = Category(name: name, description: description);

    ResponseApi responseApi = await _categoriesProvider.create(category);

    MySnackBar.show(context, responseApi.message);

    if (responseApi.success) {
      nameController.text = '';
      descriptionController.text = '';
    }
  }
}
