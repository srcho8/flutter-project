import 'package:flutter/material.dart';

class Counter with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count+= 2;
    notifyListeners();
  }

  void decrement() {
    _count-= 2;
    notifyListeners();
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}
