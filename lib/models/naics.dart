class Naics {
  String naicscode;
  String title;
  Naics({required this.naicscode, required this.title});

  factory Naics.fromJson(Map<String, dynamic> json) {
    return Naics(
      naicscode: json['naicscode'],
      title: json['title'],
    );
  }
  static List<Naics> fromJsonList(List list) {
    return list.map((item) => Naics.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.naicscode} ${this.title}';
  }

  ///this method will prevent the override of toString
  /*  bool userFilterByCreationDate(String filter) {
    return this.createdAt.toString().contains(filter);
  } */

  ///custom comparing function to check if two users are equal
  bool isEqual(Naics model) {
    return naicscode == model.naicscode;
  }

  @override
  String toString() => title;
}
