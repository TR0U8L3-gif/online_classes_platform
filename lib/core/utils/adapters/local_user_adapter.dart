import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_classes_platform/src/auth/data/models/local_user_model.dart';

class LocalUserAdapter {
  const LocalUserAdapter._();

  static LocalUserModel fromFirebaseUser(User user) {
    return LocalUserModel(
      uid: user.uid,
      email: user.email ?? '',
      points: 0,
      fullName: user.displayName ?? '',
    );
  }
}
