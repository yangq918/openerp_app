import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:openerp_app/remote/ProdInventoryRemote.dart';
import 'package:openerp_app/ui/LoginPage.dart';
import 'package:openerp_app/ui/MainPage.dart';

class FirstPage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return new AFirstPage();
  }
}

class AFirstPage extends State<FirstPage> {


  @override
  Widget build(BuildContext context) {
    Widget w = layout(context);
    ProdInventoryRemote.checkLogin().then((flag) {
      Widget c = null;
      if (flag) {
        c = new MainPage();
      }
      else {
        c = new LoginPage();
      }
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
              fullscreenDialog: true, builder: (context) {
            return new Scaffold(
              body: c,
            );
          }), (route) {
        return null == route;
      });
    });
    return w;
  }

  Widget layout(BuildContext context) {
    List<Widget> list = <Widget>[
      SizedBox(height: 150.0),
      buildLoading(),
      buildDescField(context)

    ];
    return new Scaffold(
        body: Padding(padding: EdgeInsets.fromLTRB(2.0, 10.0, 2.0, 2.0),
          child: new ListView(children: list,),)
    );
  }


  buildLoading() {
    return new Stack(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 35.0),
          child: new Center(
            child: SpinKitCubeGrid(
              color: Colors.orangeAccent,
              size: 60.0,

            ),
          ),
        ),
      ],
    );
  }


  buildDescField(BuildContext context) {
    String desc = "库存管理";


    return Center(
      child: Text(desc, softWrap: true,
          style: TextStyle(
              color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w700)),
    );
  }
}