import 'package:flutter/material.dart';
import 'package:openerp_app/remote/ProdInventoryRemote.dart';
import 'package:openerp_app/ui/HomePage.dart';
import 'package:openerp_app/ui/MainPage.dart';
import 'package:openerp_app/utils/Global.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:openerp_app/utils/OpenUtils.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String account;
  String password;
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }


  Widget _build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomPadding: false, body: Form(key: _formKey,
      child: ListView(padding: EdgeInsets.symmetric(horizontal: 22.0),
        children: <Widget>[SizedBox(height: kToolbarHeight),
        buildTitle(),
        buildTitleLine(),
        SizedBox(height: 70.0),
        buildAccountTextField(),
        SizedBox(height: 30.0),
        buildPasswordTextField(context),
        SizedBox(height: 60.0),
        buildLoginButton(context)
        ],),),);
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(title: const Text('登陆'));
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '库存管理',
        style: TextStyle(fontSize: 42.0,color: Colors.blue),
      ),
    );
  }

  Padding buildTitleLine() {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black,
          width: 40.0,
          height: 2.0,
        ),
      ),
    );
  }

  TextFormField buildAccountTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '账号',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入账号';
        }
      },
      onSaved: (String value) => account = value,
    );
  }

  buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => password = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
      },
      decoration: InputDecoration(
          labelText: '密码',
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure
                      ? Colors.grey
                      : Theme
                      .of(context)
                      .iconTheme
                      .color;
                });
              })),
    );
  }

  buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '登陆',
            style: Theme
                .of(context)
                .primaryTextTheme
                .headline,
          ),
          color: Colors.blue,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              //TODO 执行登录方法
              print('account:$account , password:$password');
              ProdInventoryRemote remote = new ProdInventoryRemote(context);
              remote.login(account, password, Global.SITE + "/api/user/login")
                  .then((result) {
                if (result) {
                  Navigator.of(context).pushAndRemoveUntil(
                      new MaterialPageRoute(
                          fullscreenDialog: true, builder: (context) {
                        return new Scaffold(
                          body: new MainPage(),
                        );
                      }), (route) => route == null);
                }
                else {
                  Fluttertoast.showToast(msg: "登陆失败!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      bgcolor: "#e74c3c",
                      textcolor: '#ffffff');
                }
              });
            }
          },
          shape: RoundedRectangleBorder(side: BorderSide(color: Colors.blue)),
        ),
      ),
    );
  }

}