part of 'data_cubit.dart';

@immutable
abstract class DataState {
  const DataState();
}

class DataInitial extends DataState {
  const DataInitial();
}

class DataLoading extends DataState {
  const DataLoading();
}

class DataLoaded extends DataState {
  final List<Film?> films;
  final List<Categorie?> cats;
  final List<Realisateur?> reals;
  final List<Personnage?> persos;
  final List<Acteur?> acteurs;
  const DataLoaded(
      this.films, this.reals, this.cats, this.persos, this.acteurs);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DataLoaded && o.films == films;
  }

  @override
  int get hashCode => films.hashCode;
}

class DataCreated extends DataState {
  const DataCreated();
}

class DataError extends DataState {
  final String message;
  const DataError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DataError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
