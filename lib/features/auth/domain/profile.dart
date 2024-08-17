class Profile {
  Profile({
    required this.id,
    required this.username,
    required this.status,
  });

  final String id;

  final String username;

  final String status;

  Profile.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        username = map['username'],
        status = map['status'];
}
