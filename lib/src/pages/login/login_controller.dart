import 'package:flutter/material.dart';
import 'package:honeymoon_delicious/src/api/response_api.dart';
import 'package:honeymoon_delicious/src/pages/login/utils/my_snackbar.dart';
import 'package:honeymoon_delicious/src/pages/login/utils/shared_pref.dart';
import 'package:honeymoon_delicious/src/provider/users_provider.dart';
import '../../models/user.dart';

class LoginController {
  BuildContext context;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();
  //PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();
  SharedPref _sharedPref = SharedPref();

  Future init(BuildContext context) async {
    this.context = context;
    _sharedPref = SharedPref();
    await usersProvider.init(context);

    User user = User.fromJson(await _sharedPref.read('user') ?? {});

    //print('Usuario: ${user.toJson()}');

    if (user?.sessionToken != null) {
      if (user.roles.length > 1) {
        Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, user.roles[0].route, (route) => false);
      }
    }
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context, 'register');
  }

  void login(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    ResponseApi responseApi = await usersProvider.login(email, password);

    print('Resposta object: $responseApi');
    print('Resposta: ${responseApi.toJson()}');

    if (responseApi.success) {
      User user = User.fromJson(responseApi.data);
      _sharedPref.save('user', user.toJson());

      //pushNotificationsProvider.saveToken(user.id);

      print('USUARIO FEZ O LOGUIN: ${user.toJson()}');
      if (user.roles.length > 1) {
        Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, user.roles[0].route, (route) => false);
      }
    } else {
      MySnackBar.show(context, responseApi.message);
    }
  }
}
