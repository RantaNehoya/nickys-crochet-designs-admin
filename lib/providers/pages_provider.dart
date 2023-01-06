import 'package:flutter/material.dart';
import 'package:nickys_crochet_designs/presentation/screens/orders_page.dart';

class Pages with ChangeNotifier {
  Widget _currentPage = const OrdersPage();

  //getter
  Widget get getCurrentPage => _currentPage;

  //setter
  void changeCurrentPage(Widget newPage) {
    _currentPage = newPage;
    notifyListeners();
  }
}
