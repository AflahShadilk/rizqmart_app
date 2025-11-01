class UserEntity {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  UserEntity({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
  });
}