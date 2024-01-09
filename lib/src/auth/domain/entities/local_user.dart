import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.uid,
    required this.email,
    required this.points,
    required this.fullName,
    required this.groupsId,
    required this.enrolledCourses,
    required this.following,
    required this.followers,
    this.profilePhotoUrl,
    this.bio,
  });

  factory LocalUser.empty(){
    return const LocalUser(
      uid: '',
      email: '',
      points: 0,
      fullName: '',
      groupsId: [],
      enrolledCourses: [],
      following: [],
      followers: [],
    );
  }

  final String uid;
  final String email;
  final String? profilePhotoUrl;
  final String? bio;
  final int points;
  final String fullName;
  final List<String> groupsId;
  final List<String> enrolledCourses;
  final List<String> following;
  final List<String> followers;

  @override
  List<Object?> get props => [uid, email];

  @override
  String toString() {
    return 'LocalUser{uid: $uid, email: $email, bio: $bio, points: $points}';
  }
}
