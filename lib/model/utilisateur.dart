class Utilisateur {
  final int numUtil;
  final int nomUtil;
  final String motPasse;
  final String role;

  Utilisateur(
      {this.numUtil = -1,
      required this.nomUtil,
      required this.motPasse,
      required this.role});

  factory Utilisateur.create(numUtil, nomUtil, motPasse, role) {
    return Utilisateur(
        numUtil: numUtil, nomUtil: nomUtil, motPasse: motPasse, role: role);
  }

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
        numUtil: json["numUtil"],
        nomUtil: json["nomUtil"],
        motPasse: json["motPasse"],
        role: json["role"]);
  }
}
