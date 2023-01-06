import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nickys_crochet_designs/utilities/palette.dart';
import 'package:nickys_crochet_designs/presentation/resources/value_manager.dart';

class PageLayout extends StatelessWidget {
  final Widget child;

  const PageLayout({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return Container(
      height: size.height * SizeManager.s0_91,
      width: size.width * SizeManager.s0_8,
      decoration: BoxDecoration(
        color: ColorPalette.colorPalette.shade50,
        borderRadius: BorderRadius.circular(
          RadiusManager.r_25,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          PaddingManager.p_15,
        ),
        child: child,
      ),
    );
  }
}
