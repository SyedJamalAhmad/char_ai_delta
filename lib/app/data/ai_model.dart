class AIChatModel {
  String name;
  List<String> stringList;
  String image;
  bool premium;
  String discription;
  String route;
  mainContainerType type;
  String? history;
  String category;

  AIChatModel(this.name, this.stringList, this.image, this.premium,
      this.discription, this.route, this.type, this.history, this.category);
}

enum mainContainerType { normal, suggestions, avatar }
