import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nickys_crochet_designs/presentation/screens/orders_page.dart';
import 'package:nickys_crochet_designs/presentation/screens/order_history.dart';
import 'package:nickys_crochet_designs/providers/pages_provider.dart';
import 'package:nickys_crochet_designs/presentation/resources/font_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/asset_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/color_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/route_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/string_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/value_manager.dart';
import 'package:nickys_crochet_designs/presentation/screens/stock.dart';

class Menu extends StatelessWidget {
  Menu({Key key}) : super(key: key);

  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    Pages currentPage = Provider.of<Pages>(context);

    return SizedBox(
      width: size.width * SizeManager.s0_17,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //logo + main menu
          Column(
            children: <Widget>[
              FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(
                    PaddingManager.p_8,
                  ),
                  child: CircleAvatar(
                    backgroundImage: const AssetImage(
                      AssetManager.logo,
                    ),
                    radius: size.width * RadiusManager.r0_09,
                  ),
                ),
              ),
              menuItem(
                size,
                icon: FontAwesomeIcons.cubes,
                label: StringManager.allOrders,
                navigate: () {
                  currentPage.changeCurrentPage(const OrdersPage());
                },
              ),
              menuItem(
                size,
                icon: FontAwesomeIcons.history,
                label: StringManager.orderHistory,
                navigate: () {
                  currentPage.changeCurrentPage(OrderHistory());
                },
              ),
              menuItem(
                size,
                icon: FontAwesomeIcons.boxes,
                label: StringManager.stock,
                navigate: () {
                  currentPage.changeCurrentPage(const Stock());
                },
              ),
            ],
          ),

          menuItem(
            size,
            icon: FontAwesomeIcons.signOutAlt,
            label: StringManager.logout,
            navigate: () {
              _firebaseAuth.signOut();

              Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.login,
                    (Route<dynamic> route) => false,
              );
            },
          ),

          SizedBox(
            height: size.height * SizeManager.s0_01,
          ),
        ],
      ),
    );
  }

  TextButton menuItem(Size size,
      {@required IconData icon,
        @required String label,
        @required VoidCallback navigate}) {
    return TextButton(
      onPressed: navigate,
      style: TextButton.styleFrom(
        foregroundColor: ColorManager.black,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: PaddingManager.p_20,
          bottom: PaddingManager.p_25,
        ),
        child: Row(
          children: <Widget>[
            FaIcon(
              icon,
              size: SizeManager.s_30,
            ),
            SizedBox(
              width: size.width * SizeManager.s0_01,
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: FontSizeManager.f_16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
