import 'package:flutter/material.dart';
import 'package:flutter_app_project1/db/database_helper.dart';
import 'package:flutter_app_project1/model/memo.dart';
import 'package:flutter_app_project1/model/photo.dart';
import 'package:flutter_app_project1/network/fetch_api.dart';
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

final inboxKeyProvider = StateProvider<String>((ref) {
  return '';
});

final pageProvider = StateProvider<int>((ref) {
  return 0;
});

final selectedListProvider = StateProvider<int>((ref) {
  return 0;
});

final isSelectedProvider = StateProvider<int>((ref) {
  return 0;
});

class IsSelectedState extends StateNotifier<int>{
  IsSelectedState() : super(0);

  void change(int i){
    state = i;
  }

}

class IconStateChangeNotifier extends ChangeNotifier {
  int _iconState = 0;

  int get iconState => _iconState;

  void change(int nu) {
    _iconState = nu;
    notifyListeners();
  }
}

class StickySearchIconStateChangeNotifier extends ChangeNotifier {
  int _iconState = 0;

  int get iconState => _iconState;

  void change(int nu) {
    _iconState = nu;
    notifyListeners();
  }
}

class StickySelectIconStateChangeNotifier extends ChangeNotifier {
  int _iconState = 0;

  int get iconState => _iconState;

  void change(int nu) {
    _iconState = nu;
    notifyListeners();
  }
}
class StickySelectAllIconStateChangeNotifier extends ChangeNotifier {
  int _iconState = 0;

  int get iconState => _iconState;

  void change(int nu) {
    _iconState = nu;
    notifyListeners();
  }
}

final memoFetchListState = FutureProvider<List<Memo>>((ref) {
  Future<List<Memo>> _memoList;
  _memoList = DBHelper().getAllMemos();
  return _memoList;
});

class SearchInboxState extends StateNotifier<List<Memo>>{
  SearchInboxState([List<Memo> state, String key, int id]) : super(state);

  void make(String key){
    state = state.where((element) => element.title.contains(key));
  }

  void selected(int id){
    state.where((element) => element.id == id);
  }
}

final streamMemo = StreamProvider<List<Memo>>((ref) {
  Stream<List<Memo>> memos = DBHelper().getAllMemosStream();
  return memos;
});

class MemoListStateNotifier extends StateNotifier<List<Memo>> {
  MemoListStateNotifier(List<Memo> memoList) : super(memoList);

  void reset(List<Memo> memoList) {
    state = memoList;
  }
}



