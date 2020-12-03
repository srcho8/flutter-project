import 'package:flutter/material.dart';
import 'package:flutter_app_project1/menu_dashboard_layout/menu_dashboard_layout.dart';
import 'package:flutter_app_project1/model/photo.dart';
import 'package:flutter_app_project1/network/fetch_api.dart';
import 'package:flutter_app_project1/ui/calendar_page.dart';
import 'package:flutter_app_project1/ui/insfire_page.dart';
import 'package:flutter_app_project1/ui/stat_page.dart';
import 'package:flutter_riverpod/all.dart';

final photoStateFuture = FutureProvider<List<Photos>>((ref) {
  Future<List<Photos>> photoList = fetchPhotos();
  final key = ref.watch(keyProvider).state;

  if (key.isNotEmpty) {
    photoList = searchPhotos(key);
  }
  return photoList;
});

final keyProvider = StateProvider<String>((ref) {
  return '';
});

final pageProvider = StateProvider<int>((ref) {
  return 0;
});

class IconStateChangeNotifier extends ChangeNotifier {
  int _iconState = 0;

  int get iconState => _iconState;

  void change(int nu) {
    _iconState = nu;
    notifyListeners();
  }
}


