class Acteur {
  final int noAct;
  final String nomAct;
  final String prenAct;
  final DateTime dateNaiss;
  final DateTime dateDeces;

  Acteur(
      {this.noAct = -1,
      required this.nomAct,
      required this.prenAct,
      required this.dateNaiss,
      required this.dateDeces});

  factory Acteur.create(noAct, nomAct, prenAct, dateNaiss, dateDeces) {
    return Acteur(
        noAct: noAct,
        nomAct: nomAct,
        prenAct: prenAct,
        dateNaiss: dateNaiss,
        dateDeces: dateDeces);
  }

  factory Acteur.fromJson(Map<String, dynamic> json) {
    return Acteur(
        noAct: json["noAct"],
        nomAct: json["nomAct"],
        prenAct: json["prenAct"],
        dateNaiss: json["dateNaiss"],
        dateDeces: json["dateDeces"]);
  }
}
