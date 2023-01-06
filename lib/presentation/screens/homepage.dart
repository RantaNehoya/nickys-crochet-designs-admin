import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nickys_crochet_designs/presentation/resources/value_manager.dart';
import 'package:nickys_crochet_designs/presentation/screens/menu.dart';
import 'package:nickys_crochet_designs/providers/pages_provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    Pages currentPage = Provider.of<Pages>(context);

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: <Widget>[
            //menu
            Menu(),

            SizedBox(
              width: size.width * SizeManager.s0_022,
            ),

            currentPage.getCurrentPage
          ],
        ),
      ),
    );
  }
}
