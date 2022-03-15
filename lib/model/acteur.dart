import 'package:intl/intl.dart';

class Acteur {
  final int noAct;
  final String nomAct;
  final String prenAct;
  final DateTime dateNaiss;
  final DateTime? dateDeces;

  Acteur(
      {this.noAct = -1,
      required this.nomAct,
      required this.prenAct,
      required this.dateNaiss,
      this.dateDeces});

  factory Acteur.create(
      noAct, nomAct, prenAct, dateNaiss, DateTime? dateDeces) {
    if (dateDeces == null) {
      return Acteur(
          noAct: noAct, nomAct: nomAct, prenAct: prenAct, dateNaiss: dateNaiss);
    }
    return Acteur(
        noAct: noAct,
        nomAct: nomAct,
        prenAct: prenAct,
        dateNaiss: dateNaiss,
        dateDeces: dateDeces);
  }

  factory Acteur.fromJson(Map<String, dynamic> json) {
    if (json["dateDeces"] == null) {
      return Acteur(
          noAct: json["noAct"],
          nomAct: json["nomAct"],
          prenAct: json["prenAct"],
          dateNaiss: DateTime.parse(json["dateNaiss"]));
    }
    return Acteur(
        noAct: json["noAct"],
        nomAct: json["nomAct"],
        prenAct: json["prenAct"],
        dateNaiss: DateTime.parse(json["dateNaiss"]),
        dateDeces: DateTime.parse(json["dateDeces"]));
  }

  Map<String, dynamic> toJson() {
    return {
      'noAct': noAct,
      'prenAct': prenAct,
      'nomAct': nomAct,
      'dateNaiss': DateFormat('yyyy-MM-dd').format(dateNaiss),
      'dateDeces':
          dateDeces != null ? DateFormat('yyyy-MM-dd').format(dateDeces!) : ""
    };
  }
}
