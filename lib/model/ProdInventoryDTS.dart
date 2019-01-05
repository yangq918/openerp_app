import 'package:flutter/material.dart';
import 'package:openerp_app/model/ProdInventory.dart';

class ProdInventoryDTS extends DataTableSource {

  List<ProdInventory> drows = [];

  ProdInventoryDTS(List<ProdInventory> drows) {
    this.drows = drows;
  }

  int _selectCount = 0;

  @override
  DataRow getRow(int index) {
    if (null == drows) {
      return null;
    }
    if (index >= drows.length) {
      return null;
    }
    ProdInventory pi = drows[index];
    return DataRow.byIndex(
        cells: [DataCell(Text(pi.productNo)), DataCell(Text(pi.name))],
        index: index,
        onSelectChanged: (isSelected) {

        });
  }

  // TODO: implement isRowCountApproximate
  @override
  bool get isRowCountApproximate => false;

  // TODO: implement rowCount
  @override
  int get rowCount => drows.length;

  // TODO: implement selectedRowCount
  @override
  int get selectedRowCount => 0;

}