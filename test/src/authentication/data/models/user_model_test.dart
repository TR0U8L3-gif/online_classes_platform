import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:online_classes_platform/src/authentication/data/models/user_model.dart';
import 'package:online_classes_platform/src/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tUserModel = UserModel(id: "id", name: "name", avatar: "avatar", createdAt: "createdAt");

  test(
    'should be a subclass of user entity',
    () async {
      // assert
      expect(tUserModel, isA<User>());
    },
  );

  group("from Data", () {
    test(
      'should return valid model from Json Map ',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture("user/user.json"));
        // act
        final result = UserModel.fromMap(jsonMap);
        // assert
        expect(result, tUserModel);
      },
    );

    test(
      'should return valid model from Json String ',
      () async {
        // arrange
        final jsonString = fixture("user/user.json");
        // act
        final result = UserModel.fromJson(jsonString);
        // assert
        expect(result, tUserModel);
      },
    );
  });

  group("to Data", () {
    test(
      'should return valid Map data',
      () async {
        // act
        final result = tUserModel.toMap();
        // assert
        expect(result, isA<Map<String, dynamic>>());
      },
    );

    test(
      'should return valid Map data with values',
      () async {
        // act
        final result = tUserModel.toMap();
        // assert
        expect(result, {"id": "id", "name": "name", "createdAt": "createdAt", "avatar": "avatar"});
      },
    );

    test(
      'should return valid Json data',
      () async {
        // act
        final result = tUserModel.toJson();
        // assert
        expect(result, isA<String>());
      },
    );

    test(
      'should return valid Json data with values',
      () async {
        //arrange
        String tJson = jsonEncode({"id": "id", "name": "name", "avatar": "avatar", "createdAt": "createdAt"});
        // act
        final result = tUserModel.toJson();
        // assert
        expect(result, tJson);
      },
    );
  });

  
}
