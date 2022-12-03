import 'package:flutter/cupertino.dart';
import 'package:honeymoon_delicious/src/api/response_api.dart';
import 'package:honeymoon_delicious/src/models/address.dart';
import 'package:honeymoon_delicious/src/models/order.dart';
import 'package:honeymoon_delicious/src/models/product.dart';
import 'package:honeymoon_delicious/src/models/user.dart';
import 'package:honeymoon_delicious/src/pages/login/utils/shared_pref.dart';
import 'package:honeymoon_delicious/src/provider/address_provider.dart';
import 'package:honeymoon_delicious/src/provider/orders_provider.dart';

class ClientAddressListController {
  BuildContext context;
  Function refresh;

  List<Address> address = [];
  AddressProvider _addressProvider = AddressProvider();
  User user;
  SharedPref _sharedPref = SharedPref();

  int radioValue = 0;

  bool isCreated;

  Map<String, dynamic> dataIsCreated;

  OrdersProvider _ordersProvider = OrdersProvider();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _addressProvider.init(context, user);
    _ordersProvider.init(context, user);

    refresh();
  }

  void createOrder() async {
    Address a = Address.fromJson(await _sharedPref.read('address') ?? '');
    List<Product> selectedProducts =
        Product.fromJsonList(await _sharedPref.read('order')).toList;
    Order order =
        Order(idClient: user.id, idAddress: a.id, products: selectedProducts);

    ResponseApi responseApi = await _ordersProvider.create(order);

    print('Resposta ordem: ${responseApi.message}');
  }

  void handleRadioValueChange(int value) async {
    radioValue = value;
    _sharedPref.save('address', address[value]);

    refresh();

    print('Valor selecionado: $radioValue');
  }

  Future<List<Address>> getAddress() async {
    address = await _addressProvider.getByUser(user.id);

    Address a = Address.fromJson(await _sharedPref.read('address') ?? '');
    int index = address.indexWhere((ad) => ad.id == a.id);
    if (index != -1) {
      radioValue = index;
    }
    print(' A direcao foi guardada a direcao: ${a.toJson()}');
    return address;
  }

  void goToNewAddress() async {
    var result = await Navigator.pushNamed(context, 'client/address/create');

    if (result != null) {
      if (result) {
        refresh();
      }
    }
  }
}
