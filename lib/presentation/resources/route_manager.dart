import 'package:flutter/material.dart';
import 'package:nickys_crochet_designs/presentation/screens/homepage.dart';
import 'package:nickys_crochet_designs/presentation/screens/login.dart';

class Routes {
  static const String login = '/';
  static const String home = '/home';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => Login(),
        );

      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => const Homepage(),
        );

      default:
        return RouteGenerator.undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('Page not found'),
        ),
      ),
    );
  }
}
