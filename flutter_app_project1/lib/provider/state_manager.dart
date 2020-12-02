import 'package:flutter/material.dart';
import 'package:flutter_app_project1/model/photo.dart';
import 'package:flutter_app_project1/provider/provider_pexels.dart';
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
  String _str = '';

  return _str;
});

class IconStateChangeNotifier extends ChangeNotifier {
  int _iconState = 0;

  int get iconState => _iconState;

  void change(int nu) {
    _iconState = nu;
    notifyListeners();
  }
}
