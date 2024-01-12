import 'package:online_classes_platform/core/helpers/input_converter.dart';
import 'package:online_classes_platform/src/auth/domain/entities/local_user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.uid,
    required super.email,
    required super.points,
    required super.fullName,
    super.groupsId,
    super.enrolledCourses,
    super.following,
    super.followers,
    super.profilePhotoUrl,
    super.bio,
  });

  factory LocalUserModel.fromMap(Map<String, dynamic> map) {
    return LocalUserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      profilePhotoUrl: map['profilePhotoUrl'] as String?,
      bio: map['bio'] as String?,
      points: InputConverter.getInt(map['points']).fold(
        (l) => 0,
        (r) => r,
      ),
      fullName: map['fullName'] as String,
      groupsId: InputConverter.getList<String>(map['groupsId']).fold(
        (l) => [],
        (r) => r,
      ),
      enrolledCourses:
          InputConverter.getList<String>(map['enrolledCourses']).fold(
        (l) => [],
        (r) => r,
      ),
      following: InputConverter.getList<String>(map['following']).fold(
        (l) => [],
        (r) => r,
      ),
      followers: InputConverter.getList<String>(map['followers']).fold(
        (l) => [],
        (r) => r,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'profilePhotoUrl': profilePhotoUrl,
      'bio': bio,
      'points': points,
      'fullName': fullName,
      'groupsId': groupsId,
      'enrolledCourses': enrolledCourses,
      'following': following,
      'followers': followers,
    };
  }

  LocalUserModel copyWith({
    String? uid,
    String? email,
    String? profilePhotoUrl,
    String? bio,
    int? points,
    String? fullName,
    List<String>? groupsId,
    List<String>? enrolledCourses,
    List<String>? following,
    List<String>? followers,
  }) {
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      bio: bio ?? this.bio,
      points: points ?? this.points,
      fullName: fullName ?? this.fullName,
      groupsId: groupsId ?? this.groupsId,
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }
}
