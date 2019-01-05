import 'package:flutter/material.dart';
import 'package:openerp_app/remote/ProdInventoryRemote.dart';

class AccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return new APage();
  }


}

class APage extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    //ProdInventoryRemote.checkLogin(context);
    return layout(context);
  }



  Widget layout(BuildContext context) {
    List<Widget> list = <Widget>[

      SizedBox(height: 120.0),
      buildLoginOut(context),

    ];
    return new Scaffold(
        appBar: buildAppBar(context),
        body: Padding(padding: EdgeInsets.fromLTRB(2.0, 10.0, 2.0, 2.0),
          child: new ListView(children: list,),)
    );
  }

  buildLoginOut(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 40.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '退出系统',
            style: Theme
                .of(context)
                .primaryTextTheme
                .headline,
          ),
          color: Colors.redAccent,
          onPressed: () {
            ProdInventoryRemote remote = new ProdInventoryRemote(context);
            remote.logout();
          },
          shape: RoundedRectangleBorder(side: BorderSide(color: Colors.redAccent)),
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(title: const Text('账号'));
  }

  Widget header(BuildContext context) {
    return new Image.network(
      'http://i2.yeyou.itc.cn/2014/huoying/hd_20140925/hyimage06.jpg',

    );
  }
}