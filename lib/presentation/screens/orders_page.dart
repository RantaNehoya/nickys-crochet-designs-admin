import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:badges/badges.dart';
import 'package:intl/intl.dart';
import 'package:nickys_crochet_designs/utilities/palette.dart';
import 'package:nickys_crochet_designs/presentation/resources/string_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/value_manager.dart';
import 'package:nickys_crochet_designs/widgets/statistics.dart';
import 'package:nickys_crochet_designs/utilities/constants.dart';
import 'package:nickys_crochet_designs/widgets/heading_text.dart';
import 'package:nickys_crochet_designs/widgets/page_layout.dart';
import 'package:nickys_crochet_designs/widgets/paginated_table.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final _ordersCollection =
      FirebaseFirestore.instance.collection(StringManager.ordersCollection);
  bool _isAcceptingOrders = true;

  @override
  Widget build(BuildContext context) {
    int newOrders = ValueManager.v_0;
    int dispatchedOrders = ValueManager.v_0;
    List<Widget> alerts = [];
    Size size = MediaQuery.of(context).size;

    return PageLayout(
      child: StreamBuilder<QuerySnapshot>(
        stream: _ordersCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return kProgressIndicator;
          }

          for (var doc in snapshot.data.docs) {
            if (doc[StringManager.accepted] == false) {
              newOrders += 1;

              alerts.add(
                ListTile(
                  title: const Text(
                    StringManager.newOrder,
                  ),
                  subtitle: Text(
                    'Ref Number - ${doc[StringManager.refNum]}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.check,
                    ),
                    onPressed: () {
                      setState(
                        () {
                          try {
                            doc.reference.update(
                              {
                                StringManager.accepted: true,
                              },
                            );
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return kSnackBar;
                              },
                            );
                          }
                        },
                      );
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            }
          }

          for (var doc in snapshot.data.docs) {
            if (doc[StringManager.mapStatus] == 'On The Way') {
              dispatchedOrders += 1;
            }
          }

          return SizedBox(
            height: size.height * SizeManager.s0_91,
            width: size.width * SizeManager.s0_8,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(
                        left: PaddingManager.p_15,
                      ),
                      child: HeadingText(label: StringManager.orderDetails),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: PaddingManager.p_8,
                      ),
                      child: Row(
                        children: [
                          const Text(
                            StringManager.acceptingOrders,
                          ),
                          Switch(
                            value: _isAcceptingOrders,
                            onChanged: (_) {
                              setState(
                                () {
                                  _isAcceptingOrders = !_isAcceptingOrders;
                                },
                              );
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    scrollable: true,
                                    actions: alerts,
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              (alerts.isEmpty)
                                  ? Icons.notifications_outlined
                                  : Icons.notifications_active_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    StatsModel(
                      icon: FontAwesomeIcons.box,
                      number: newOrders.toString(),
                      label: StringManager.newOrders,
                    ),
                    StatsModel(
                      icon: FontAwesomeIcons.dolly,
                      number: snapshot.data.size.toString(),
                      label: StringManager.totalOrders,
                    ),
                    StatsModel(
                      icon: FontAwesomeIcons.truckLoading,
                      number: dispatchedOrders.toString(),
                      label: StringManager.totalDispatch,
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.only(
                    left: PaddingManager.p_15,
                    top: PaddingManager.p_15,
                  ),
                  child: SizedBox(
                      width: double.infinity,
                      child: HeadingText(
                        label: StringManager.orders,
                      )),
                ),

                SizedBox(
                  width: size.width * SizeManager.s0_8,
                  height: size.height * SizeManager.s0_58,
                  child: PaginatedTable(
                    rows: ValueManager.v_5,
                    source: OrdersData(snapshot.data.docs),
                    dataColumns: const [
                      StringManager.id,
                      StringManager.name,
                      StringManager.payment,
                      StringManager.product,
                      StringManager.type,
                      StringManager.status,
                      StringManager.total,
                      StringManager.dateOrdered,
                      StringManager.phone,
                      StringManager.address,
                      StringManager.action,
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class OrdersData extends DataTableSource {
  final _orderHistoryCollection = FirebaseFirestore.instance
      .collection(StringManager.orderHistoryCollection);
  final List<dynamic> _placedOrders;

  OrdersData(this._placedOrders);

  @override
  DataRow getRow(int index) {
    Map<String, String> status = {
      'p': 'Pending',
      'r': 'Ready',
      'o': 'On The Way',
    };

    Color boxColor;
    Color textColor;

    Color setBoxColor() {
      if (_placedOrders[index].data()[StringManager.mapStatus] == status['p']) {
        boxColor = Colors.blue.shade100;
      } else if (_placedOrders[index].data()[StringManager.mapStatus] ==
          status['r']) {
        boxColor = Colors.red.shade200;
      } else {
        boxColor = Colors.purple.shade200;
      }
      return boxColor;
    }

    Color setTextColor() {
      if (_placedOrders[index].data()[StringManager.mapStatus] == status['p']) {
        textColor = Colors.white70;
      } else if (_placedOrders[index].data()[StringManager.mapStatus] ==
          status['r']) {
        textColor = Colors.white70;
      } else {
        textColor = Colors.white70;
      }
      return textColor;
    }

    return DataRow(
      cells: [
        DataCell(
          Text(
            _placedOrders[index].data()[StringManager.refNum].toString(),
          ),
        ),
        DataCell(
          Text(
            _placedOrders[index].data()[StringManager.mapName].toString(),
          ),
        ),
        DataCell(
          Text(
            _placedOrders[index].data()[StringManager.mapPayment].toString(),
          ),
        ),
        DataCell(
          Text(
            _placedOrders[index].data()[StringManager.mapProduct].toString(),
          ),
        ),
        DataCell(
          Text(
            _placedOrders[index].data()[StringManager.mapType].toString(),
          ),
        ),
        DataCell(
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(
                  PaddingManager.p_8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    RadiusManager.r_4,
                  ),
                  color: setBoxColor(),
                ),
                child: Text(
                  _placedOrders[index]
                      .data()[StringManager.mapStatus]
                      .toString(),
                  style: TextStyle(color: setTextColor()),
                ),
              ),
              PopupMenuButton(
                icon: const Icon(
                  Icons.keyboard_arrow_down_outlined,
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Text(status['p']),
                      onTap: () {
                        _placedOrders[index].reference.update({
                          StringManager.mapStatus: status['p'],
                        });
                      },
                    ),
                    PopupMenuItem(
                      child: Text(status['r']),
                      onTap: () {
                        _placedOrders[index].reference.update({
                          StringManager.mapStatus: status['r'],
                        });
                      },
                    ),
                    PopupMenuItem(
                      child: Text(status['o']),
                      onTap: () {
                        _placedOrders[index].reference.update({
                          StringManager.mapStatus: status['o'],
                        });
                      },
                    ),
                  ];
                },
              ),
            ],
          ),
        ),
        DataCell(
          Text(_placedOrders[index].data()[StringManager.mapTotal].toString()),
        ),
        DataCell(
          Text(
            DateFormat.yMMMd().format(
              DateTime.parse(
                _placedOrders[index]
                    .data()[StringManager.mapDateOrdered]
                    .toString(),
              ),
            ),
          ),
        ),
        DataCell(
          Text(_placedOrders[index].data()[StringManager.mapPhone].toString()),
        ),
        DataCell(
          Text(
              _placedOrders[index].data()[StringManager.mapAddress].toString()),
        ),
        DataCell(
          Badge(
            alignment: Alignment.topRight,
            badgeContent: const Icon(
              Icons.priority_high_outlined,
            ),
            showBadge: !_placedOrders[index].data()[StringManager.accepted],
            badgeColor: ColorPalette.colorPalette.shade700,
            child: PopupMenuButton(
              icon: const Icon(
                Icons.more_vert_outlined,
              ),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: const Text(
                      StringManager.completeOrder,
                    ),
                    onTap: () {
                      _placedOrders[index].reference.delete();

                      _orderHistoryCollection.add({
                        StringManager.refNum:
                            _placedOrders[index].data()[StringManager.refNum],
                        StringManager.mapName:
                            _placedOrders[index].data()[StringManager.mapName],
                        StringManager.mapPayment: _placedOrders[index]
                            .data()[StringManager.mapPayment],
                        StringManager.mapProduct: _placedOrders[index]
                            .data()[StringManager.mapProduct],
                        StringManager.mapType:
                            _placedOrders[index].data()[StringManager.mapType],
                        StringManager.mapStatus: StringManager.completed,
                        StringManager.mapTotal:
                            _placedOrders[index].data()[StringManager.mapTotal],
                        StringManager.mapDateOrdered: _placedOrders[index]
                            .data()[StringManager.mapDateOrdered],
                      });
                    },
                  ),
                  PopupMenuItem(
                    child: const Text(StringManager.cancelOrder),
                    onTap: () {
                      _placedOrders[index].reference.delete();

                      _orderHistoryCollection.add(
                        {
                          StringManager.refNum:
                              _placedOrders[index].data()[StringManager.refNum],
                          StringManager.mapName: _placedOrders[index]
                              .data()[StringManager.mapName],
                          StringManager.mapPayment: _placedOrders[index]
                              .data()[StringManager.mapPayment],
                          StringManager.mapProduct: _placedOrders[index]
                              .data()[StringManager.mapProduct],
                          StringManager.mapType: _placedOrders[index]
                              .data()[StringManager.mapType],
                          StringManager.status: StringManager.cancelled,
                          StringManager.mapTotal: _placedOrders[index]
                              .data()[StringManager.mapTotal],
                          StringManager.mapDateOrdered: _placedOrders[index]
                              .data()[StringManager.mapDateOrdered],
                        },
                      );
                    },
                  ),
                ];
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _placedOrders.length;

  @override
  int get selectedRowCount => ValueManager.v_0;
}
