import 'package:flutter/material.dart';
import 'package:online_classes_platform/core/common/views/persistent_view.dart';
import 'package:online_classes_platform/core/helpers/tab_navigator.dart';
import 'package:provider/provider.dart';

class DashboardController extends ChangeNotifier {
  List<int> _indexHistory = [0];
  final List<Widget> _screens = [
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        initialPage: Placeholder(),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        initialPage: Placeholder(),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        initialPage: Placeholder(),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        initialPage: Placeholder(),
      ),
      child: const PersistentView(),
    ),
  ];

  List<Widget> get screens => _screens;

  int _currentIndex = 3;
  int get currentIndex => _currentIndex;

  void changeIndex(int index){
    if(index == _currentIndex) return;
    _currentIndex = index;
    _indexHistory.add(index);
    notifyListeners();
  }

  void goBack() {
    if(_indexHistory.length == 1) return;
    _indexHistory.removeLast();
    _currentIndex = _indexHistory.last;
    notifyListeners();
  }

  void resetIndex(){
    _indexHistory = [0];
        _currentIndex = 0;
        notifyListeners();
  }
}
