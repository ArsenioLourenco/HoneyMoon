import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:honeymoon_delicious/src/api/response_api.dart';
import 'package:honeymoon_delicious/src/models/user.dart';
import 'package:honeymoon_delicious/src/pages/login/utils/my_snackbar.dart';
import 'package:honeymoon_delicious/src/provider/users_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RegisterController {
  BuildContext context;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  UsersProvider usersprovider = UsersProvider();

  PickedFile pickedFile;
  File imageFile;
  Function refresh;

  ProgressDialog _progressDialog;

  bool isEnable = true;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    usersprovider.init(context);
    _progressDialog = ProgressDialog(context: context);
  }

  void register() async {
    String email = emailController.text.trim();
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty ||
        name.isEmpty ||
        lastname.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      MySnackBar.show(context, 'Preencha todos os campos');
      return;
    }
    if (confirmPassword != password) {
      MySnackBar.show(context, 'Palavaras passes nao coincidem');
      return;
    }
    if (password.length < 6) {
      MySnackBar.show(
          context, 'Palavaras passe deve ter ao menos 6 caracteres');
    }

    if (imageFile == null) {
      MySnackBar.show(context, 'Seleciona uma imagem');
      return;
    }

    _progressDialog.show(max: 100, msg: 'Espere um momento...');
    isEnable = false;

    User user = User(
        email: email,
        name: name,
        lastname: lastname,
        phone: phone,
        password: password);

    Stream stream = await usersprovider.createWithImage(user, imageFile);
    stream?.listen((res) {
      _progressDialog.close();
      //ResponseApi responseApi = await usersprovider.create(user);
      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      print('Resposta: ${responseApi.toJson()}');
      MySnackBar.show(context, responseApi.message);

      //Faz o registro e nos leva a pagina de login depois de 3 segundos
      if (responseApi.success) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushReplacementNamed(context, 'login');
        });
      } else {
        isEnable = true;
      }
    });
  }

  Future selectImage(ImageSource imageSource) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog() {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery);
        },
        child: Text('GALERIA'));

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera);
        },
        child: Text('CAMERA'));

    AlertDialog alertDialog = AlertDialog(
      title: Text('Seleciona a tua imagem'),
      actions: [galleryButton, cameraButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void back() {
    Navigator.pop(context);
  }
}
