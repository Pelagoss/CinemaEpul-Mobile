class Realisateur {
  final int noRea;
  final String nomRea;
  final String prenRea;

  Realisateur({this.noRea = -1, required this.nomRea, required this.prenRea});

  factory Realisateur.create(noRea, nomRea, prenRea) {
    return Realisateur(noRea: noRea, nomRea: nomRea, prenRea: prenRea);
  }

  factory Realisateur.fromJson(Map<String, dynamic> json) {
    return Realisateur(
      noRea: json["noRea"],
      nomRea: json["nomRea"],
      prenRea: json["prenRea"],
    );
  }

  Map<String, dynamic> toJson() {
    return {'noRea': noRea, 'nomRea': nomRea, 'prenRea': prenRea};
  }
}
