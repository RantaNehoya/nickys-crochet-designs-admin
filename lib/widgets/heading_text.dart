import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nickys_crochet_designs/presentation/resources/font_manager.dart';

class HeadingText extends StatelessWidget {
  const HeadingText({
    Key key,
    @required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return SizedBox(
      // width: double.infinity,
      child: Text(
        label,
        style: GoogleFonts.yesevaOne(
          fontWeight: FontWeight.bold,
          fontSize: mediaQuery.textScaleFactor * FontSizeManager.f_25,
        ),
      ),
    );
  }
}
