import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:online_classes_platform/src/auth/data/models/local_user_model.dart';
import 'package:online_classes_platform/src/auth/domain/entities/local_user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tLocalUseModel = LocalUserModel.fromMap(
    jsonDecode(fixture('/local_user/local_user.json')) as Map<String, dynamic>,
  );

  test(
    'should be a subclass of [LocalUser] entity',
    () => expect(tLocalUseModel, isA<LocalUser>()),
  );

  group('fromMap', () {});
  group('toMap', () {});
  group('copyWith', () {});
}
