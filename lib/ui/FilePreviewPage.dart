import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:openerp_app/remote/ProdInventoryRemote.dart';
import 'package:openerp_app/utils/Global.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FilePreviewPage extends StatefulWidget {

  String fileName;

  FilePreviewPage(this.fileName);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return new FilePage(this.fileName);
  }
}

class FilePage extends State<FilePreviewPage> {

  String _fileName;

  bool isExist = false;

  bool downloading = false;

  bool canView = false;

  String downTile = "下载";


  FilePage(this._fileName);

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  Widget layout(BuildContext context) {
    List<Widget> list = <Widget>[
      SizedBox(height: 60.0),
      new Center(child: new Icon(
        Icons.insert_drive_file, size: 100.0, color: Colors.black12,),),
      SizedBox(height: 20.0),
      Center(child: Text(_fileName),),
      SizedBox(height: 60.0),
      buildLoading(),
      buildDownLoadBtn(context),
      SizedBox(height: 20.0),
      buildOpenFileBtn(context),
      SizedBox(height: 20.0),
      buildDescField(context)

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
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.redAccent)),
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(title: const Text('文件预览'));
  }

  Widget header(BuildContext context) {
    return new Image.network(
      'http://i2.yeyou.itc.cn/2014/huoying/hd_20140925/hyimage06.jpg',

    );
  }

  buildDownLoadBtn(BuildContext context) {
    downTile = "下载";

    ProdInventoryRemote remote = new ProdInventoryRemote(context);
    remote.checkFile(_fileName).then((value) {
      if (this.isExist != value) {
        setState(() {
          this.isExist = value;
        });
      }
    });
    Color sideColor = this.downloading ? Colors.black12 : Colors.blueAccent;
    return Align(
      child: SizedBox(
        height: 40.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            downTile,
            style: Theme
                .of(context)
                .primaryTextTheme
                .headline,
          ),
          color: Colors.blueAccent,
          onPressed: this.downloading ? null : () {
            setState(() {
              this.downloading = true;
              this.canView = false;
            });
            ProdInventoryRemote remote = new ProdInventoryRemote(context);
            remote.downloadFile(
                Global.SITE + "/api/proInventory/downDesc?fileName=" +
                    _fileName, _fileName).then(
                    (path) {
                  if (null != path && path.length > 0) {
                    setState(() {
                      this.downloading = false;
                      this.canView = true;
                      this.isExist = true;
                    });
                  }
                  else {
                    setState(() {
                      this.downloading = false;
                      this.canView = false;
                      this.isExist = false;
                    });
                  }
                });
          },
          shape: RoundedRectangleBorder(
              side: BorderSide(color: sideColor)),
        ),
      ),
    );
  }

  buildLoading() {
    if (!this.downloading) {
      return SizedBox(height: 5.0);
    }
    return new Stack(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 35.0),
          child: new Center(
            child: SpinKitFadingCircle(
              color: Colors.blueAccent,
              size: 30.0,
            ),
          ),
        ),
        new Padding(
          padding: new EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
          child: new Center(
            child: new Text('正在下载中~'),
          ),
        ),
      ],
    );
  }


  buildOpenFileBtn(BuildContext context) {
    print(this.isExist);
    bool activeFlag = this.isExist && (!this.downloading);
    Color sideColor = activeFlag ? Colors.blueAccent : Colors.black12;
    return Align(
      child: SizedBox(
        height: 40.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            "打开文件",
            style: Theme
                .of(context)
                .primaryTextTheme
                .headline,
          ),
          color: Colors.blueAccent,
          onPressed: activeFlag ? openFile : null,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: sideColor)),
        ),
      ),
    );
  }

  openFile() {
    ProdInventoryRemote remote = new ProdInventoryRemote(context);
    remote.openFile(_fileName).then((flag) {
      if (!flag) {
        Fluttertoast.showToast(msg: "打开文件失败!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            bgcolor: "#e74c3c",
            textcolor: '#ffffff');
        return;
      }
    });
  }

  buildDescField(BuildContext context) {
    String desc = "";
    Color textColor = Colors.redAccent;
    if (!this.isExist) {
      desc = "文件在手机中不存在，请先下载再打开！";
    }
    else {
      desc = "文件已经下载至手机，如果需要更新文件内容，可以重新下载！";
      textColor = Colors.green;
    }
    if (this.downloading) {
      desc = "文件下载中!";
      textColor = Colors.green;
    }
    return Align(
      child: SizedBox(
        width: 270.0,
        child: Text(desc, softWrap: true, style: TextStyle(color: textColor),),
      ),
    );
  }
}