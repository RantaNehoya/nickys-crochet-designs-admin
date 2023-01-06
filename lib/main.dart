import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:nickys_crochet_designs/presentation/resources/route_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/string_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/font_manager.dart';
import 'firebase_options.dart';
import 'package:nickys_crochet_designs/providers/pages_provider.dart';
import 'package:nickys_crochet_designs/utilities/palette.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Pages(),
      child: MaterialApp(
        title: StringManager.title,
        scrollBehavior: CustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: ColorPalette.colorPalette,
          fontFamily: FontFamilies.fontFamily,
        ),
        initialRoute: Routes.login,
        onGenerateRoute: RouteGenerator.getRoute,
      ),
    );
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}
