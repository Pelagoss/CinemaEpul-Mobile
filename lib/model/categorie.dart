class Categorie {
  final String codeCat;
  final String libelleCat;
  final String image;

  Categorie({this.codeCat = "", required this.libelleCat, required this.image});

  factory Categorie.create(codeCat, libelleCat, image) {
    return Categorie(codeCat: codeCat, libelleCat: libelleCat, image: image);
  }

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      codeCat: json["codeCat"],
      libelleCat: json["libelleCat"],
      image: json["image"],
    );
  }
}
