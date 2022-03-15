import 'package:intl/intl.dart';

class Film {
  final int noFilm;
  final String titre;
  final int duree;
  final DateTime dateSortie;
  final int budget;
  final int montantRecette;
  final int noRea;
  final String codeCat;

  Film(
      {this.noFilm = -1,
      required this.titre,
      required this.duree,
      required this.dateSortie,
      required this.budget,
      required this.montantRecette,
      required this.noRea,
      required this.codeCat});

  factory Film.create(
      titre, duree, dateSortie, budget, montantRecette, noRea, codeCat) {
    return Film(
        titre: titre,
        duree: duree,
        dateSortie: dateSortie,
        budget: budget,
        montantRecette: montantRecette,
        noRea: noRea,
        codeCat: codeCat);
  }

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
        noFilm: json["noFilm"],
        titre: json["titre"],
        duree: json["duree"],
        dateSortie: DateTime.parse(json["dateSortie"]),
        budget: json["budget"],
        montantRecette: json["montantRecette"],
        noRea: json["noRea"],
        codeCat: json["codeCat"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'noFilm': noFilm,
      'titre': titre,
      'duree': duree,
      'dateSortie': DateFormat('yyyy-MM-dd').format(dateSortie),
      'budget': budget,
      'montantRecette': montantRecette,
      'noRea': noRea,
      'codeCat': codeCat,
    };
  }
}
