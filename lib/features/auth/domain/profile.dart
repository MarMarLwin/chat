class Profile {
  Profile(
      {required this.id,
      required this.username,
      required this.status,
      required this.isTyping});

  final String id;

  final String username;

  final String status;

  final bool isTyping;

  Profile.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        username = map['username'],
        status = map['status'],
        isTyping = map['isTyping'];
}
