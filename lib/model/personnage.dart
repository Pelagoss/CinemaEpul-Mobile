class Personnage {
  final int noFilm;
  final int noAct;
  final String nomPers;

  Personnage({this.noFilm = -1, required this.noAct, required this.nomPers});

  factory Personnage.create(noFilm, noAct, nomPers) {
    return Personnage(noFilm: noFilm, noAct: noAct, nomPers: nomPers);
  }

  factory Personnage.fromJson(List<dynamic> json) {
    return Personnage(
      noFilm: json[1],
      noAct: json[0],
      nomPers: json[2],
    );
  }
}
