import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:online_classes_platform/core/helpers/tab_navigator.dart';

void main() {
  late TabNavigator tabNavigator;

  setUp(() {
    tabNavigator = TabNavigator(initialPage: const SuperWidgetOne());
  });

  test('initial tab should be [SuperWidgetOne]', () {
    expect(
      tabNavigator.currentTab.page.runtimeType,
      const SuperWidgetOne().runtimeType,
    );
  });

  test('should add [SuperWidgetTwo]', () {
    tabNavigator.push(const SuperWidgetTwo());

    expect(
      tabNavigator.currentTab.page.runtimeType,
      const SuperWidgetTwo().runtimeType,
    );
  });

  test('should pop until initial page', () {
    tabNavigator.push(const SuperWidgetTwo());
    tabNavigator.push(const SuperWidgetThree());

    tabNavigator.popUntilPage(const SuperWidgetOne());

    expect(
      tabNavigator.currentTab.page.runtimeType,
      tabNavigator.initialTab.page.runtimeType,
    );
  });

  test('should pop to page', () {
    tabNavigator.push(const SuperWidgetTwo());
    tabNavigator.push(const SuperWidgetThree());
    tabNavigator.push(const SuperWidgetThree());

    tabNavigator.popUntilPage(const SuperWidgetTwo());

    expect(
      tabNavigator.currentTab.page.runtimeType,
      const SuperWidgetTwo().runtimeType,
    );
  });

  test('should pop until initial tab', () {
    tabNavigator.push(const SuperWidgetTwo());
    tabNavigator.push(const SuperWidgetThree());

    tabNavigator.popUntilTab(TabItem(page: const SuperWidgetOne()));

    expect(
      tabNavigator.currentTab,
      tabNavigator.initialTab,
    );
  });

  test('should pop to tab', () {
    tabNavigator.push(const SuperWidgetTwo());
    final tab = tabNavigator.push(const SuperWidgetThree());
    tabNavigator.push(const SuperWidgetThree());
    tabNavigator.push(const SuperWidgetThree());

    tabNavigator.popUntilTab(tab);

    expect(
      tabNavigator.currentTab,
      tab,
    );
  });
}

class SuperWidgetOne extends StatelessWidget {
  const SuperWidgetOne({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SuperWidgetTwo extends StatelessWidget {
  const SuperWidgetTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SuperWidgetThree extends StatelessWidget {
  const SuperWidgetThree({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
