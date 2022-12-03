import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:honeymoon_delicious/src/api/response_api.dart';
import 'package:honeymoon_delicious/src/models/user.dart';
import 'package:honeymoon_delicious/src/pages/login/utils/my_snackbar.dart';
import 'package:honeymoon_delicious/src/pages/login/utils/shared_pref.dart';
import 'package:honeymoon_delicious/src/provider/users_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ClientUpdateController {
  BuildContext context;

  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  UsersProvider usersprovider = UsersProvider();

  PickedFile pickedFile;
  File imageFile;
  Function refresh;

  ProgressDialog _progressDialog;

  bool isEnable = true;
  User user;
  SharedPref _sharedPref = SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _progressDialog = ProgressDialog(context: context);
    user = User.fromJson(await _sharedPref.read('user'));

    print('TOKEN ENVIADO: ${user.sessionToken}');
    usersprovider.init(context, sessionUser: user);

    nameController.text = user.name;
    lastnameController.text = user.lastname;
    phoneController.text = user.phone;
    refresh();
  }

  void update() async {
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text.trim();

    if (name.isEmpty || lastname.isEmpty || phone.isEmpty) {
      MySnackBar.show(context, 'Preencha todos os campos');
      return;
    }

    _progressDialog.show(max: 100, msg: 'Espere um momento...');
    isEnable = false;

    User myUser = User(
        id: user.id,
        name: name,
        lastname: lastname,
        phone: phone,
        image: user.image);

    Stream stream = await usersprovider.update(myUser, imageFile);
    if (stream != null) {
      stream.listen((res) async {
        _progressDialog.close();

        //ResponseApi responseApi = await usersprovider.create(user);
        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
        Fluttertoast.showToast(msg: responseApi.message);

        //Faz o registro e nos leva a pagina de login depois de 3 segundos
        if (responseApi.success) {
          user = await usersprovider
              .getById(myUser.id); //OBTENDO O USUARIO DA BASE DE DADOS
          print('Usuario obtido: ${user.toJson()}');

          _sharedPref.save('user', user.toJson()); // GUARDAR SESSAO

          Navigator.pushNamedAndRemoveUntil(
              context, 'client/products/list', (route) => false);
        } else {
          isEnable = true;
        }
      });
    }
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
