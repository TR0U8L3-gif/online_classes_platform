class LocalUser {
  const LocalUser({
    required this.uid,
    required this.email,
    required this.points,
    required this.fullName,
    required this.groupId,
    required this.enrolledCourses,
    required this.following,
    required this.followers,
    this.profilePhotoUrl,
    this.bio,
  });

  final String uid;
  final String email;
  final String? profilePhotoUrl;
  final String? bio;
  final int points;
  final String fullName;
  final List<String> groupId;
  final List<String> enrolledCourses;
  final List<String> following;
  final List<String> followers;
}
