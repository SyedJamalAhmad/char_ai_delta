class FirebaseCharecter {
  String title;
  String description;
  String? animationUrl;
  String firstMessage;
  String intro;
  String category;
  String imageUrl;
  int priority;
  String? historyMessages;
  int? star1;
  int? star2;
  int? star3;
  int? star4;
  int? star5;
  int? chatters;
  int? lovedBy;
  bool? isActive;

  FirebaseCharecter(
      {required this.title,
      required this.description,
      this.animationUrl,
      required this.firstMessage,
      required this.intro,
      required this.category,
      required this.imageUrl,
      this.priority = 100,
      required this.historyMessages,
      this.star1,
      this.star2,
      this.star3,
      this.star4,
      this.star5,
      this.chatters,
      this.lovedBy,
      this.isActive});

  // Convert the model to a Map for Firebase
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'animationUrl': animationUrl ?? "",
        'firstMessage': firstMessage,
        'intro': intro,
        'category': category,
        'imageUrl': imageUrl,
        'priority': priority,
        'history': imageUrl,
        'star1': star1 ?? 0,
        'star2': star2 ?? 0,
        'star3': star3 ?? 0,
        'star4': star4 ?? 0,
        'star5': star5 ?? 0,
        'chatters': chatters ?? 0,
        'lovedBy': lovedBy ?? 0,
        'isActive': isActive ?? true,
      };

  // Create a FirebaseCharecter from a Map
  factory FirebaseCharecter.fromJson(Map<String, dynamic> json) =>
      FirebaseCharecter(
        title: json['title'],
        description: json['description'],
        animationUrl: json['animationUrl'] ?? "",
        firstMessage: json['firstMessage'],
        intro: json['intro'],
        category: json['category'],
        imageUrl: json['imageUrl'],
        priority: json['priority'] ?? 100,
        historyMessages: json['history'] ?? null,
        star1: json['star1'] ?? 1000,
        star2: json['star2'] ?? 2500,
        star3: json['star3'] ?? 5020,
        star4: json['star4'] ?? 770,
        star5: json['star5'] ?? 100276,
        chatters: json['chatters'] ?? 0,
        lovedBy: json['lovedBy'] ?? 0,
        isActive: json['isActive'] ?? true,
      );
}
