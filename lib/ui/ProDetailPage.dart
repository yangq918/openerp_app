import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:openerp_app/model/ProdInventory.dart';
import 'package:openerp_app/remote/ProdInventoryRemote.dart';
import 'package:openerp_app/ui/FilePreviewPage.dart';
import 'package:openerp_app/utils/FileOpener.dart';
import 'package:openerp_app/utils/Global.dart';


class ProDetailPage extends StatefulWidget {

  ProdInventory pi;

  ProDetailPage(ProdInventory pi) {
    this.pi = pi;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return new ProPage(pi);
  }
}

class ProPage extends State<ProDetailPage> {

  ProdInventory pis;

  ProPage(ProdInventory pis) {
    this.pis = pis;
  }

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  Widget layout(BuildContext context) {
    Table t = new Table(
      border: TableBorder.all(
          color: Colors.black12, width: 1.0, style: BorderStyle.solid),
      children: <TableRow>[buildTableRow(context, "库存编码", pis.productNo),
      buildTableRow(context, "物资名称", pis.name),
      buildTableRow(context, "数量", pis.num),
      buildTableRow(context, "单位", pis.unit),
      buildTableRow(context, "单位成本", pis.unitCost),
      buildTableRow(context, "存放位置", pis.address),
      buildTableRow(context, "库存值", pis.inventoryNum),
      buildTableRow(context, "型号", pis.productModel),
      buildTableRow(context, "规格", pis.spec),
      buildTableRow(context, "生产厂商", pis.manufacturer),
      buildTableRow(context, "厂家联系电话", pis.mTeleNumber),
      buildTableRow(context, "用途", pis.purpose),
      buildDescTableRow(context, "说明", pis.desc)
      ],);

    return new Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(child: Padding(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0), child: t,)),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(title: const Text('库存详情'));
  }

  Widget buildRow(BuildContext context, String name, var value) {
    String vstr = null == value ? "" : value.toString();
    return Padding(padding: EdgeInsets.fromLTRB(60.0, 0.0, 0.0, 0.0),
        child: Flexible(child: new Row(children: <Widget>[
          Text(name + ":"),
          Text(vstr, softWrap: true, maxLines: 30,)
        ]),));
  }

  Widget header(BuildContext context) {
    return new Image.network(
      'http://i2.yeyou.itc.cn/2014/huoying/hd_20140925/hyimage06.jpg',

    );
  }

  buildTableRow(BuildContext context, String name, value) {
    String vstr = null == value ? "" : value.toString();
    return new TableRow(children: <Widget>[
      Padding(child: Text(name + ":", textAlign: TextAlign.right,),
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 10.0),),
      Padding(
        child: Text(vstr, softWrap: true),
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 2.0, 10.0),)
    ]);
  }

  buildDescTableRow(BuildContext context, String name, value) {
    String vstr = null == value ? "" : value.toString();
    return new TableRow(children: <Widget>[
      Padding(child: Text(name + ":", textAlign: TextAlign.right,),
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 10.0),),
      Padding(
        child: GestureDetector(
          child: Text(
            vstr, softWrap: true, style: TextStyle(color: Colors.blueAccent),),
          onTap: () {
            if (null == vstr || vstr
                .trim()
                .length <= 0) {
              Fluttertoast.showToast(msg: "无文件信息!",toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,bgcolor: "#e74c3c",
                  textcolor: '#ffffff');
              return;
            }
            Navigator.of(context).push(
                new MaterialPageRoute(
                    fullscreenDialog: false, builder: (context) {
                  return new Scaffold(
                      body: new FilePreviewPage(vstr)
                  );
                }));
          },),
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 2.0, 10.0),),

    ]);
  }
}