class Personnage {
  final int noFilm;
  final int noAct;
  final String nomPers;

  Personnage({this.noFilm = -1, required this.noAct, required this.nomPers});

  factory Personnage.create(noFilm, noAct, nomPers) {
    return Personnage(noFilm: noFilm, noAct: noAct, nomPers: nomPers);
  }

  factory Personnage.fromJson(Map<String, dynamic> json) {
    return Personnage(
      noFilm: json["noFilm"],
      noAct: json["noAct"],
      nomPers: json["nomPers"],
    );
  }
}
