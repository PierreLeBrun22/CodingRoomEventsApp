class Event {
  final String author;
  final String endDate;
  final String img;
  final int interesses;
  final int nbLike;
  final String startDate;
  final String texte;
  final String date;
  final String mail;
  final String title;

  Event(
      {this.author,
      this.endDate,
      this.img,
      this.interesses,
      this.nbLike,
      this.startDate,
      this.texte,
      this.date,
      this.mail,
      this.title});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      author: json['author'] as String,
      endDate: json['endDate'] as String,
      img: json['img'] as String,
      interesses: json['interesses'] as int,
      nbLike: json['nbLike'] as int,
      startDate: json['startDate'] as String,
      texte: json['texte'] as String,
      date: json['date'] as String,
      mail: json['mail'] as String,
      title: json['title'] as String,
    );
  }
}
