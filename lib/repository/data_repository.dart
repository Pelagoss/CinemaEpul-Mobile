import 'dart:collection';
import 'dart:convert';
import 'package:cinemaepulmobile/model/categorie.dart';
import 'package:cinemaepulmobile/model/film.dart';
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

  void deleteReal(Realisateur? real) {
    deleteData("realisateur", real!.noRea);
  }

  void deleteFilm(Film? film) {
    deleteData("film", film!.noFilm);
  }

  void deleteCategorie(Categorie? categorie) {
    deleteData("categorie", categorie!.codeCat);
  }

  Future<bool> createFilm(Film film) async {
    return await createData("film", film);
  }

  Future<bool> createRealisateur(Realisateur realisateur) async {
    return await createData("realisateur", realisateur);
  }
}

class NetworkException implements Exception {}
