import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:cinemaepulmobile/model/categorie.dart';
import 'package:cinemaepulmobile/model/film.dart';
import 'package:cinemaepulmobile/model/realisateur.dart';
import 'package:meta/meta.dart';
import 'package:cinemaepulmobile/repository/data_repository.dart';

part 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  final DataRepository _dataRepository;

  DataCubit(this._dataRepository) : super(const DataInitial());

  Future<void> getFilms() async {
    try {
      emit(const DataLoading());
      final films = await _dataRepository.getFilms();
      final reals = await _dataRepository.getRealisateurs();
      final cats = await _dataRepository.getCategories();

      if (films != null && reals != null && cats != null) {
        emit(DataLoaded(films, reals, cats));
      } else {
        emit(const DataError("Pas de film enregistrées !"));
      }
    } on NetworkException {
      emit(const DataError("Pas de film détectés !"));
    }
  }

  Future<void> deleteReal(Realisateur? real) async {
    try {
      _dataRepository.deleteReal(real);
    } on NetworkException {
      emit(const DataError("Pas de realisateur détectés !"));
    }
  }

  Future<void> deleteFilm(Film? film) async {
    try {
      _dataRepository.deleteFilm(film);
    } on NetworkException {
      emit(const DataError("Pas de film détectés !"));
    }
  }

  Future<void> deleteCategorie(Categorie? categorie) async {
    try {
      _dataRepository.deleteCategorie(categorie);
    } on NetworkException {
      emit(const DataError("Pas de catégorie détectés !"));
    }
  }

  Future<void> createFilm(Film film) async {
    try {
      bool created = await _dataRepository.createFilm(film);
      if (created) {
        emit(const DataCreated());
      } else {
        emit(const DataError("Film non créé !"));
      }
    } on NetworkException {
      emit(const DataError("Pas de catégorie détectés !"));
    }
  }

  Future<void> createRealisateur(Realisateur realisateur) async {
    try {
      bool created = await _dataRepository.createRealisateur(realisateur);
      if (created) {
        emit(const DataCreated());
      } else {
        emit(const DataError("Film non créé !"));
      }
    } on NetworkException {
      emit(const DataError("Pas de catégorie détectés !"));
    }
  }
}
