import 'package:flutter/material.dart';
import 'package:openerp_app/remote/ProdInventoryRemote.dart';
import 'package:openerp_app/ui/AccountPage.dart';
import 'package:openerp_app/ui/HomePage.dart';
import 'package:openerp_app/utils/OpenUtils.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false, home: new MainPageWidget());
  }

}

class MainPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPageWidget> {

  int _tabIndex = 0;
  var tabImages;
  var appBarTitles = ['库存','我的'];
  var _pageList;
  var icons;
  var _pageController = new PageController(initialPage: 0);

  Image getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  Text getTabTitle(int curIndex) {
    if (curIndex == _tabIndex) {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 14.0, color: const Color(0xff1296db)));
    } else {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 14.0, color: const Color(0xff515151)));
    }
  }

  void initData() {
    icons =
    [new Icon(Icons.table_chart), new Icon(Icons.account_box)
    ];
    _pageList = [new HomePage(), new AccountPage()];
  }

  void _pageChange(int index) {
    setState(() {
      if (_tabIndex != index) {
        _tabIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //ProdInventoryRemote.checkLogin(context);
    return _build(context);
  }



  Widget _build(BuildContext context) {
    initData();
    return Scaffold(body: new PageView.builder(
        itemBuilder: (BuildContext context, int index) {
          return _pageList[index];
        },
        itemCount: 2,
        controller: _pageController,
        onPageChanged: _pageChange),
        bottomNavigationBar: new BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(icon: icons[0], title: getTabTitle(0)),
            new BottomNavigationBarItem(icon: icons[1], title: getTabTitle(1))
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _tabIndex,
          iconSize: 24.0,
          onTap: (index) {
            _pageController.animateToPage(
                index, duration: new Duration(seconds: 2),
                curve: new ElasticOutCurve(0.8));
            _pageChange(index);
          },));
  }

}