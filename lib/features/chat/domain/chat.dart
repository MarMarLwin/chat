class Message {
  Message({
    required this.id,
    required this.userId,
    required this.message,
    required this.insertedAt,
    required this.channelId,
    required this.isMine,
  });

  /// ID of the message
  final int id;

  /// ID of the user who posted the message
  final String userId;

  /// Text content of the message
  final String message;

  /// Date and time when the message was inserted
  final DateTime insertedAt;

  final int channelId;

  /// Whether the message is sent by the user or not.
  final bool isMine;

  Message.fromMap({
    required Map<String, dynamic> map,
    required String myUserId,
  })  : id = map['id'],
        userId = map['user_id'],
        channelId = map['channel_id'],
        message = map['message'],
        insertedAt = DateTime.parse(map['inserted_at']),
        isMine = myUserId == map['user_id'];
}
