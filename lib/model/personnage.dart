class Personnage {
  final int noFilm;
  final int noAct;
  final String nomPers;

  Personnage(
      {required this.noFilm, required this.noAct, required this.nomPers});

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

  Map<String, dynamic> toJson() {
    return {'noFilm': noFilm, 'noAct': noAct, 'nomPers': nomPers};
  }
}
