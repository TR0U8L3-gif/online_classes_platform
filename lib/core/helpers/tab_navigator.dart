import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TabNavigator extends ChangeNotifier {
  TabNavigator({required Widget initialPage})
      : _initialTab = TabItem(page: initialPage);

  final TabItem _initialTab;
  final List<TabItem> _tabStack = [];

  TabItem get initialTab => _initialTab;

  TabItem get currentTab => _tabStack.isEmpty ? _initialTab : _tabStack.last;

  TabItem push(Widget page) {
    final tab = TabItem(page: page);
    _tabStack.add(tab);
    notifyListeners();
    return tab;
  }

  void add(TabItem tab){
    _tabStack.add(tab);
    notifyListeners();
  }

  void pop() {
    if (_tabStack.isNotEmpty) {
      _tabStack.removeLast();
    }
    notifyListeners();
  }

  void reset() {
    _tabStack.clear();
    notifyListeners();
  }

  void popUntilPage(Widget page) {
    if (_tabStack.last.page.runtimeType == page.runtimeType) return;

    TabItem? lastTab;
    while (lastTab?.page.runtimeType != page.runtimeType) {
      _tabStack.removeLast();
      if (_tabStack.isNotEmpty) {
        lastTab = _tabStack.last;
      } else {
        break;
      }
    }
    notifyListeners();
  }

  void popUntilTab(TabItem tab) {
    if (_tabStack.last == tab) return;

    TabItem? lastTab;
    while (lastTab != tab) {
      _tabStack.removeLast();
      if (_tabStack.isNotEmpty) {
        lastTab = _tabStack.last;
      } else {
        break;
      }
    }
    notifyListeners();
  }

  void removePage(Widget page) {
    TabItem? tabItem;
    for(final tab in _tabStack){
      if(tab.page.runtimeType == page.runtimeType){
        tabItem = tab;
        break;
      }
    }
    if(tabItem != null){
      _tabStack.remove(tabItem);
    }
    notifyListeners();
  }

  void removeTab(TabItem tab) {
    _tabStack.remove(tab);
    notifyListeners();
  }

  TabItem pushAndRemoveAllPage(Widget page){
    _tabStack.clear();
    final tab = TabItem(page: page);
    _tabStack.add(tab);
    notifyListeners();
    return tab;
  }

  void pushAndRemoveAllTab(TabItem tab){
    _tabStack.clear();
    _tabStack.add(tab);
    notifyListeners();
  }
}

class TabItem extends Equatable {
  TabItem({required this.page}) : id = const Uuid().v1();

  final Widget page;
  final String id;

  @override
  List<Object?> get props => [id, page];
}
