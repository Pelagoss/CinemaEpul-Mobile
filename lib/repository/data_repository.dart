import 'dart:collection';
import 'dart:convert';
import 'package:cinemaepulmobile/model/acteur.dart';
import 'package:cinemaepulmobile/model/categorie.dart';
import 'package:cinemaepulmobile/model/film.dart';
import 'package:cinemaepulmobile/model/personnage.dart';
import 'package:cinemaepulmobile/model/realisateur.dart';
import 'package:cinemaepulmobile/request.dart';
import 'package:http/http.dart' as http;

class DataRepository {
  Future<List<Film?>?> getFilms() async {
    try {
      var responseBody = await fetchData("film/");

      List<Film?> films = [];
      for (var film in responseBody) {
        Film f = Film.fromJson(film);
        films.add(f);
      }
      return films;
    } catch (e) {
      return null;
    }
  }

  Future<List<Realisateur?>?> getRealisateurs() async {
    try {
      var responseBody = await fetchData("realisateur/");
      List<Realisateur?> realisateurs = [];
      for (var real in responseBody) {
        Realisateur r = Realisateur.fromJson(real);
        realisateurs.add(r);
      }
      return realisateurs;
    } catch (e) {
      return null;
    }
  }

  Future<List<Categorie?>?> getCategories() async {
    try {
      var responseBody = await fetchData("categorie/");

      List<Categorie?> categories = [];

      for (var cat in responseBody) {
        Categorie c = Categorie.fromJson(cat);
        categories.add(c);
      }
      return categories;
    } catch (e) {
      return null;
    }
  }

  Future<List<Personnage?>?> getPersonnages() async {
    try {
      var responseBody = await fetchData("personnage/");
      List<Personnage?> personnages = [];

      for (var perso in responseBody) {
        Personnage p = Personnage.fromJson(perso);
        personnages.add(p);
      }
      return personnages;
    } catch (e) {
      return null;
    }
  }

  Future<List<Acteur?>?> getActeurs() async {
    try {
      var responseBody = await fetchData("acteur/");
      List<Acteur?> acteurs = [];

      for (var act in responseBody) {
        Acteur a = Acteur.fromJson(act);
        acteurs.add(a);
      }
      return acteurs;
    } catch (e) {
      return null;
    }
  }

  void deleteReal(Realisateur? real) {
    deleteData("realisateur", real!.noRea);
  }

  void deleteFilm(Film? film) {
    deleteData("film", film!.noFilm);
  }

  void deleteCategorie(Categorie? categorie) {
    deleteData("categorie", categorie!.codeCat);
  }

  void deletePersonnage(Personnage? personnage) {
    deleteData("personnage", "${personnage!.noAct}/${personnage.noFilm}");
  }

  void deleteActeur(Acteur? acteur) {
    deleteData("acteur", acteur!.noAct);
  }

  Future<bool> createFilm(Film film) async {
    return await createData("film", film);
  }

  Future<bool> createRealisateur(Realisateur realisateur) async {
    return await createData("realisateur", realisateur);
  }

  Future<bool> createPersonnage(Personnage personnage) async {
    return await createData("personnage", personnage);
  }

  Future<bool> createActeur(Acteur acteur) async {
    return await createData("acteur", acteur);
  }
}

class NetworkException implements Exception {}
