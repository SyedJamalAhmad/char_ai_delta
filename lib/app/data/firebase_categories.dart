import 'package:character_ai_delta/app/data/firbase_charecters.dart';

class FirebaseCatagory {
  List<FirebaseCharecter> characters;
  int priority;
  String id;

  FirebaseCatagory({
    this.characters = const [],
    this.priority = 100,
    required this.id,
  });

  // Convert the model to a Map for Firebase
  Map<String, dynamic> toJson() => {
        'characters': characters.map((char) => char.toJson()).toList(),
        'priority': priority,
      };

  // Create a Category from a Map
  factory FirebaseCatagory.fromJson(Map<String, dynamic> json, String id) =>
      FirebaseCatagory(
        id: id,
        characters: (json['characters'] as List)
            .map((charJson) => FirebaseCharecter.fromJson(charJson))
            .toList(),
        priority: json['priority'] ?? 100,
      );
}
