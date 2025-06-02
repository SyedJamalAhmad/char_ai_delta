class DBMessage {
  final String userId;
  final String characterId;
  final String message;
  final String senderType;
  final bool isVoiceResponse;

  DBMessage(
      {required this.userId,
      required this.characterId,
      required this.message,
      required this.senderType,
      required this.isVoiceResponse});

  factory DBMessage.fromMap(Map<String, dynamic> map) {
    return DBMessage(
      userId: map['user_id'] as String,
      characterId: map['character_id'] as String,
      message: map['message'] as String,
      senderType: map['type'] as String,
      isVoiceResponse: map['isVoiceResponse'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'character_id': characterId,
      'message': message,
      'type': senderType,
      'isVoiceResponse': isVoiceResponse ? 1 : 0,
    };
  }
}
