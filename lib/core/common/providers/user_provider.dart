import 'package:flutter/cupertino.dart';
import 'package:online_classes_platform/src/auth/data/models/local_user_model.dart';

class UserProvider extends ChangeNotifier {
  LocalUserModel? _user;

  void initUser(LocalUserModel? user) {
    if (_user != user) {
      _user = user;
    }
  }

  LocalUserModel? get user => _user;

  set user(LocalUserModel? user) {
    if (_user != user) {
      _user = user;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }
}
