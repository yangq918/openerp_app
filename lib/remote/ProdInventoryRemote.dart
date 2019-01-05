import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:openerp_app/exception/ReLoginError.dart';
import 'package:openerp_app/ui/LoginPage.dart';
import 'package:openerp_app/utils/FileOpener.dart';
import 'package:path_provider/path_provider.dart';

import 'package:dio/dio.dart';
import 'package:openerp_app/model/Pager.dart';
import 'package:openerp_app/model/ProdInventory.dart';

import 'package:localstorage/localstorage.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_permissions/simple_permissions.dart';

class ProdInventoryRemote {

  BuildContext context;


  ProdInventoryRemote(this.context);


  Future<Pager<ProdInventory>> search(int pageNumber, int pageSize,
      String searchValue, String url) async
  {
    print("do Search");
    Dio dio = new Dio();
    String cookiePath = await getCookiePath();
    PersistCookieJar cookieJar = new PersistCookieJar(cookiePath);
    dio.cookieJar = cookieJar;
    FormData formData = new FormData.from({
      "pageNumber": pageNumber,
      "pageSize": pageSize,
    });

    if (null != searchValue && searchValue.length > 0) {
      formData = new FormData.from({
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "searchValue": searchValue,
        "searchType": "all"
      });
    }
    Response response = null;
    try {
      dio.options.connectTimeout = 150000; //5s
      dio.options.receiveTimeout = 300000;
      response = await dio.post(url, data: formData);
    } on DioError catch (e) {
      print(e);
      if (null == e.response) {
        return new Pager();
      }
      checkSession(e.response);
      return new Pager();
    }
    print("xxx2");
    //print(response.data);
    Pager<ProdInventory> pager = new Pager();
    Map<String, dynamic> resultData = response.data;

    print(resultData["code"]);
    if (resultData["code"] == '0') {
      //print("ok");
      Map<String, dynamic> insideData = resultData["data"];
      List<dynamic> content = insideData["content"];
      pager.totalPages = insideData['totalPages'];
      pager.totalElements = insideData['totalElements'];
      pager.size = insideData['size'];
      pager.number = insideData["number"];
      List<ProdInventory> pis = [];
      if (null != content) {
        content.forEach((ele) {
          //print(ele["id"]);
          ProdInventory pi = new ProdInventory();
          pi.id = ele["id"];
          pi.address = ele["address"];
          pi.desc = ele["desc"];
          pi.inventoryNum = ele["inventoryNum"];
          pi.manufacturer = ele["manufacturer"];
          pi.mTeleNumber = ele["mTeleNumber"];
          pi.name = ele["name"];
          pi.num = ele["num"];
          pi.productModel = ele["productModel"];
          pi.productNo = ele["productNo"];
          pi.purpose = ele["purpose"];
          pi.spec = ele["spec"];
          pi.unit = ele["unit"];
          pi.unitCost = ele["unitCost"];
          pis.add(pi);
        });
      }
      pager.datas = pis;
    }
    return pager;
  }

  Future<String> downloadFile(String url, String fileName) async
  {
    try {
      PermissionStatus status = await SimplePermissions.requestPermission(
          Permission.WriteExternalStorage);
      if (PermissionStatus.authorized != status) {
        Fluttertoast.showToast(msg: "权限不足，请授权!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            bgcolor: "#e74c3c",
            textcolor: '#ffffff');
        return null;
      }
      Dio dio = new Dio();
      Directory tempDir = await getExternalStorageDirectory();
      String tempPath = tempDir.path + "/openerp";
      print(tempPath);
      Directory dir = new Directory(tempPath);
      bool b = await dir.exists();
      if (!b) {
        dir.createSync(recursive: true);
      }
      File f = new File(tempPath + "/" + fileName);
      if (await f.exists()) {
        f.deleteSync(recursive: true);
      }
      Response response = await dio.download(url, tempPath + "/" + fileName);

      String contents = await f.readAsString();
      print(contents);
      return tempPath + "/" + fileName;
    }
    catch (e) {
      return null;
    }
  }

  Future<bool> login(String account, String password, String url) async
  {
    Dio dio = new Dio();
    String cookiePath = await getCookiePath();
    PersistCookieJar cookieJar = new PersistCookieJar(cookiePath);
    dio.cookieJar = cookieJar;
    FormData formData = new FormData.from({
      "account": account,
      "password": password,
      "remember-me": "true"
    });
    Response response = null;
    try {
      response = await dio.post(url, data: formData);
    } catch (e) {
      print(e);
      cookieJar.deleteAll();
      return await false;
    }

    Map<String, dynamic> resultData = response.data;
    if (resultData["code"] == '0') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("loginFlag", "login");
      return await true;
    }
    return await false;
  }


  Future<String> getCookiePath() async
  {
    Directory tempDir = await getApplicationDocumentsDirectory();
    String tempPath = tempDir.path + "/openerp_cookie";
    Directory dir = new Directory(tempPath);
    bool b = await dir.exists();
    if (!b) {
      dir.createSync(recursive: true);
    }
    return await tempPath;
  }

  void checkSession(Response response) async {
    print(response.statusCode);
    List<String> values = response.headers[HttpHeaders.setCookieHeader];
    print(values);
    if (302 == response.statusCode) {
      print("xxxxx");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("loginFlag", "noLogin");
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
              fullscreenDialog: true, builder: (context) {
            return new Scaffold(
              body: new LoginPage(),
            );
          }), (route) {
        return null == route;
      });
    }
  }


  void logout() async {
    String cookiePath = await getCookiePath();
    PersistCookieJar cookieJar = new PersistCookieJar(cookiePath);
    cookieJar.deleteAll();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("loginFlag", "noLogin");
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(
            fullscreenDialog: true, builder: (context) {
          return new Scaffold(
              body: new LoginPage(),
              resizeToAvoidBottomPadding: false
          );
        }), (route) {
      return null == route;
    });
  }


  Future<bool> checkFile(String fileName) async {
    try {
      Directory tempDir = await getExternalStorageDirectory();
      String tempPath = tempDir.path + "/openerp";
      print(tempPath);
      Directory dir = new Directory(tempPath);
      bool b = await dir.exists();
      if (!b) {
        dir.createSync(recursive: true);
      }
      String filePath = tempPath + "/" + fileName;
      File f = new File(filePath);
      if (await f.exists()) {
        return true;
      }
      return false;
    }
    catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> openFile(String fileName) async {
    try {
      Directory tempDir = await getExternalStorageDirectory();
      String tempPath = tempDir.path + "/openerp";

      String filePath = tempPath + "/" + fileName;

      FileOpener.open(filePath);
      return true;
    }
    catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String flag = prefs.getString("loginFlag");
    print("flag");
    print(flag);
    if ("login" != flag) {
      return false;
    }
    return true;
  }


}