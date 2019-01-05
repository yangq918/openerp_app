import 'package:flutter/material.dart';
import 'package:openerp_app/model/Pager.dart';
import 'package:openerp_app/model/ProdInventory.dart';
import 'package:openerp_app/remote/ProdInventoryRemote.dart';
import 'package:openerp_app/ui/ProDetailPage.dart';
import 'package:openerp_app/ui/SearchPage.dart';
import 'package:openerp_app/utils/ErrorUtils.dart';
import 'package:openerp_app/utils/Global.dart';
import 'package:openerp_app/utils/OpenUtils.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return new Page();
  }
}

class Page extends State<HomePage> {

  DataTable dt;
  List<DataRow> drows = [];

  bool stop = false;

  Pager<ProdInventory> pager = new Pager();

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  Widget layout(BuildContext context) {
    if (!stop) {
      toPage(0, context);
    }
    dt = new DataTable(
      columns: <DataColumn>[
        DataColumn(label: Text('物资编码')), DataColumn(label: Text('物资名称'))
        , DataColumn(label: Text('库存值'))
      ], rows: drows,);
    IconButton leftBtn = IconButton(
        icon: Icon(Icons.arrow_left),
        tooltip: '',
        onPressed: () {
          toPage(pager.number - 1, context);
        });
    if (pager.number <= 0) {
      leftBtn = IconButton(
          icon: Icon(Icons.arrow_left),
          tooltip: '',
          onPressed: null);
    }

    IconButton rightBtn = IconButton(
      icon: Icon(Icons.arrow_right),
      tooltip: '',
      onPressed: () {
        toPage(pager.number + 1, context);
      },
    );

    if ((pager.number + 1) >= pager.totalPages) {
      rightBtn = IconButton(
        icon: Icon(Icons.arrow_right),
        tooltip: '',
        onPressed: null,
      );
    }
    Row page = new Row(children: <Widget>[Text(
      "共" + pager.totalElements.toString() + "条," +
          (pager.number + 1).toString() + "/" + pager.totalPages.toString() +
          "页",)
    , leftBtn, rightBtn
    ],);

    return new Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(child: Column(
        children: <Widget>[
          dt,
          Padding(
            child: page, padding: EdgeInsets.fromLTRB(100.0, 4.0, 0.0, 0.0),)
        ],)
        ,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        heroTag: null,
        elevation: 7.0,
        highlightElevation: 14.0,
        onPressed: () {
          toPage(0, context);
        },
        mini: true,
        shape: new CircleBorder(),
        isExtended: false,),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,);
  }

  void toPage(int pageNumber, BuildContext context) {
    ProdInventoryRemote remote = new ProdInventoryRemote(context);
    remote.search(
        pageNumber, 10, "",
        Global.SITE + "/api/proInventory/list")
        .then((pager) {
      stop = true;
      List<ProdInventory> pis = pager.datas;
      List<DataRow> trows = [];
      if (null == pis) {
        return;
      }
      pis.forEach((pi) {
        DataRow row = new DataRow(cells: <DataCell>[
          new DataCell(new Text(pi.productNo), onTap: () {
            toDetail(pi, context);
          }),
          new DataCell(new Text(pi.name), onTap: () {
            toDetail(pi, context);
          }),
          new DataCell(new Text(
              null == pi.inventoryNum ? "" : pi.inventoryNum.toString()),
              onTap: () {
                toDetail(pi, context);
              })
        ]);
        trows.add(row);
      });
      setState(() {
        this.drows = trows;
        this.pager = pager;
      });
    });
  }


  Widget buildAppBar(BuildContext context) {
    return new AppBar(title: const Text('库存管理'), actions: <Widget>[IconButton(
      icon: Icon(Icons.search),
      tooltip: '搜索',
      onPressed: _search,
    )
    ]);
  }

  void _search() {
    Navigator.of(context).push(
        new MaterialPageRoute(fullscreenDialog: false, builder: (context) {
          return new Scaffold(
            body: new SearchPage(),
          );
        }));
  }


  Widget header(BuildContext context) {
    return new Image.network(
      'http://i2.yeyou.itc.cn/2014/huoying/hd_20140925/hyimage06.jpg',

    );
  }

  void toDetail(ProdInventory pi, BuildContext context) {
    Navigator.of(context).push(
        new MaterialPageRoute(fullscreenDialog: false, builder: (context) {
          return new Scaffold(
            body: new ProDetailPage(pi),
          );
        }));
  }
}