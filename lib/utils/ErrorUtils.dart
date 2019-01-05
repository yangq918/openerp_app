import 'package:flutter/material.dart';
import 'package:openerp_app/exception/ReLoginError.dart';
import 'package:openerp_app/ui/LoginPage.dart';
import 'package:path/path.dart';

class ErrorUtils {
  static void onError(e, BuildContext context) {
    if (e.runtimeType == ReLoginError) {
      print("relogin");
      Navigator.of(context).push(
          new MaterialPageRoute(
              fullscreenDialog: true, builder: (context) {
            return new Scaffold(
              body: new LoginPage(),
            );
          }));
    }

  }
}