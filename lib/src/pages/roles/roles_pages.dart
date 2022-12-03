import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:honeymoon_delicious/src/pages/roles/roles_controller.dart';

import '../../models/rol.dart';

class RolesPages extends StatefulWidget {
  @override
  State<RolesPages> createState() => _RolesPagesState();
}

class _RolesPagesState extends State<RolesPages> {
  RolesController _con = RolesController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Seleciona uma funcao'),
        ),
        body: Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.14),
          child: ListView(
              children: _con.user != null
                  ? _con.user.roles.map((Rol rol) {
                      return _cardRol(rol);
                    }).toList()
                  : []),
        ));
  }

  Widget _cardRol(Rol rol) {
    return GestureDetector(
      onTap: () {
        _con.goToPage(rol.route);
      },
      child: Column(
        children: [
          Container(
              height: 100,
              child: FadeInImage(
                image: rol.image != null
                    ? NetworkImage(rol.image)
                    : AssetImage('assets/img/no-image.png'),
                fit: BoxFit.contain,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage('assets/img/no-image.png'),
              )),
          SizedBox(
            height: 15,
          ),
          Text(rol.name ?? '',
              style: TextStyle(fontSize: 16, color: Colors.black)),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  void refresh() {
    if (this.mounted) {
      setState(() {});
    }
  }
}
