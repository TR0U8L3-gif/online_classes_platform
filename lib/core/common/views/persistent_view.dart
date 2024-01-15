import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_classes_platform/core/helpers/tab_navigator.dart';

class PersistentView extends StatefulWidget {
  const PersistentView({this.body, super.key});

  final Widget? body;

  @override
  State<PersistentView> createState() => _PersistentViewState();
}

class _PersistentViewState extends State<PersistentView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.body ?? context.watch<TabNavigator>().currentTab.page;
  }

  @override
  bool get wantKeepAlive => true;
}
