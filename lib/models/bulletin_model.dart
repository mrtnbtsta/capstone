class BulletinModel {
  final int id;
  final String title;
  final String image;
  final String description;
  final String type;

  BulletinModel(
      {required this.id,
      required this.title,
      required this.image,
      required this.description,
      required this.type});

  static BulletinModel fromJson(json) => BulletinModel(
      id: json["id"],
      title: json["title"],
      image: json["image"],
      description: json["description"],
      type: json["type"]);
}

class BulletinNews {
  final int id;
  final String title;
  final String image;
  final String description;

  BulletinNews(
      {required this.id,
      required this.title,
      required this.image,
      required this.description});

  factory BulletinNews.fromJson(Map<String, dynamic> json) => BulletinNews(
      id: json["id"],
      title: json["title"],
      image: json["image"],
      description: json["description"]);
}

class AllReports {
  final int id;
  final String title;
  final String image;
  final String description;

  AllReports(
      {required this.id,
      required this.title,
      required this.image,
      required this.description});

  factory AllReports.fromJson(Map<String, dynamic> json) {
    return AllReports(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        description: json["description"]);
  }
}

class BulletinEvents {
  final int id;
  final String title;
  final String image;
  final String description;

  BulletinEvents(
      {required this.id,
      required this.title,
      required this.image,
      required this.description});

  factory BulletinEvents.fromJson(Map<String, dynamic> json) => BulletinEvents(
      id: json["id"],
      title: json["title"],
      image: json["image"],
      description: json["description"]);
}

class BulletinUserReports {
  final int id;
  final String title;
  final String image;
  final String description;

  BulletinUserReports(
      {required this.id,
      required this.title,
      required this.image,
      required this.description});

  factory BulletinUserReports.fromJson(Map<String, dynamic> json) =>
      BulletinUserReports(
          id: json["id"],
          title: json["title"],
          image: json["image"],
          description: json["description"]);
}
