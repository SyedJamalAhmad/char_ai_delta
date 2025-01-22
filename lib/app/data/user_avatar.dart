class UserPersonalizedAvatar {
  int id = 0; // Add the id property
  String imageAsset = '';
  String avatarName = '';
  String avatarFirstMessage = '';
  String avatarDescription = '';

  // Constructor to initialize all properties
  UserPersonalizedAvatar({
    required this.id,
    required this.imageAsset,
    required this.avatarName,
    required this.avatarFirstMessage,
    required this.avatarDescription,
  });

  // ... (constructor remains the same)

  // Convert the model to a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'imageAsset': imageAsset,
      'avatarName': avatarName,
      'avatarFirstMessage': avatarFirstMessage,
      'avatarDescription': avatarDescription,
    };
  }

  // Create a UserPersonalizedAvatar object from a Map (retrieved from the database)
  static UserPersonalizedAvatar fromMap(Map<String, dynamic> map) {
    return UserPersonalizedAvatar(
      id: map['id'],
      imageAsset: map['imageAsset'],
      avatarName: map['avatarName'],
      avatarFirstMessage: map['avatarFirstMessage'],
      avatarDescription: map['avatarDescription'],
    );
  }
}
