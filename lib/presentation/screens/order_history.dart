import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:nickys_crochet_designs/presentation/resources/string_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/value_manager.dart';
import 'package:nickys_crochet_designs/utilities/constants.dart';
import 'package:nickys_crochet_designs/widgets/heading_text.dart';
import 'package:nickys_crochet_designs/widgets/page_layout.dart';
import 'package:nickys_crochet_designs/widgets/paginated_table.dart';

class OrderHistory extends StatelessWidget {
  OrderHistory({Key key}) : super(key: key);

  final _orderHistoryCollection = FirebaseFirestore.instance
      .collection(StringManager.orderHistoryCollection);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return PageLayout(
      child: StreamBuilder(
        stream: _orderHistoryCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return kProgressIndicator;
          }

          return Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(
                  left: PaddingManager.p_15,
                  bottom: PaddingManager.p_15,
                ),
                child: HeadingText(label: StringManager.orderHistory),
              ),
              SizedBox(
                width: size.width * SizeManager.s0_8,
                child: PaginatedTable(
                  rows: ValueManager.v_7,
                  source: OrderHistoryData(snapshot.data.docs),
                  dataColumns: const [
                    StringManager.id,
                    StringManager.name,
                    StringManager.payment,
                    StringManager.product,
                    StringManager.type,
                    StringManager.status,
                    StringManager.total,
                    StringManager.dateOrdered,
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class OrderHistoryData extends DataTableSource {
  final List<dynamic> _orderHistory;

  OrderHistoryData(this._orderHistory);

  @override
  DataRow getRow(int index) {
    return DataRow(
      cells: [
        DataCell(
          Text(_orderHistory[index].data()[StringManager.refNum].toString()),
        ),
        DataCell(
          Text(_orderHistory[index].data()[StringManager.mapName].toString()),
        ),
        DataCell(
          Text(_orderHistory[index]
              .data()[StringManager.mapPayment]
              .toString()),
        ),
        DataCell(
          Text(_orderHistory[index]
              .data()[StringManager.mapProduct]
              .toString()),
        ),
        DataCell(
          Text(_orderHistory[index].data()[StringManager.mapType].toString()),
        ),
        DataCell(
          Text(
              _orderHistory[index].data()[StringManager.mapStatus].toString()),
        ),
        DataCell(
          Text(_orderHistory[index].data()[StringManager.mapTotal].toString()),
        ),
        DataCell(
          Text(
            DateFormat.yMMMd().format(
              DateTime.parse(
                _orderHistory[index]
                    .data()[StringManager.mapDateOrdered]
                    .toString(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _orderHistory.length;

  @override
  int get selectedRowCount => ValueManager.v_0;
}
