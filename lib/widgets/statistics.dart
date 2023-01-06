import 'package:flutter/material.dart';
import 'package:nickys_crochet_designs/presentation/resources/color_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/font_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/value_manager.dart';

class StatsModel extends StatelessWidget {
  final IconData icon;
  final String number;
  final String label;

  const StatsModel(
      {Key key,
      @required this.icon,
      @required this.number,
      @required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Container(
      padding: const EdgeInsets.only(
        top: PaddingManager.p_15,
        bottom: PaddingManager.p_15,
        left: PaddingManager.p_20,
        right: PaddingManager.p_80,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            RadiusManager.r_10,
          ),
          border: Border.all(
            color: ColorManager.grey300,
          )),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: SizeManager.s_35,
          ),
          const SizedBox(
            width: SizeManager.s_20,
          ),
          Column(
            children: <Widget>[
              Text(
                number,
                style: TextStyle(
                    fontSize: mediaQuery.textScaleFactor * FontSizeManager.f_30,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                label,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
