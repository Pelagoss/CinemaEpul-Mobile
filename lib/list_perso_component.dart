import 'dart:io';

import 'package:cinemaepulmobile/constant.dart';
import 'package:cinemaepulmobile/cubit/data_cubit.dart';
import 'package:cinemaepulmobile/form/film_form.dart';
import 'package:cinemaepulmobile/form/perso_form.dart';
import 'package:cinemaepulmobile/loading_component.dart';
import 'package:cinemaepulmobile/model/acteur.dart';
import 'package:cinemaepulmobile/model/categorie.dart';
import 'package:cinemaepulmobile/model/film.dart';
import 'package:cinemaepulmobile/model/personnage.dart';
import 'package:cinemaepulmobile/model/realisateur.dart';
import 'package:cinemaepulmobile/repository/data_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

class ListPersos extends StatefulWidget {
  const ListPersos({Key? key}) : super(key: key);

  @override
  State<ListPersos> createState() => _ListPersosState();
}

class _ListPersosState extends State<ListPersos> with RouteAware {
  Future<void> _pullRefresh() async {
    context.read<DataCubit>().getFilms();
  }

  void _deletePerso(Personnage? personnage) async {
    context.read<DataCubit>().deletePersonnage(personnage);
    sleep(const Duration(milliseconds: 1000));
    _pullRefresh();
  }

  @override
  void initState() {
    super.initState();
    context.read<DataCubit>().getFilms();
  }

  List<Widget> getFilmTiles(state) {
    List<Film?> films = state.films;
    List<Realisateur?> reals = state.reals;
    List<Categorie?> cats = state.cats;
    List<Personnage?> persos = state.persos;
    List<Acteur?> acteurs = state.acteurs;

    List<Widget> list = [];
    if (persos != null) {
      persos.forEach((Personnage? perso) {
        var film = films
            .where((element) => element?.noFilm == perso?.noFilm)
            .take(1)
            .toList()[0];

        var act = acteurs
            .where((element) => element?.noAct == perso?.noAct)
            .take(1)
            .toList()[0];
        var row = Padding(
          padding:
              const EdgeInsets.only(left: 15.0, right: 15.0, top: 7, bottom: 7),
          child: Container(
            decoration: BoxDecoration(
              color: textColor,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Slidable(
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                        onPressed: (context) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return BlocProvider(
                                create: (context) =>
                                    DataCubit(DataRepository()),
                                child: FormPerso(personnage: perso));
                          }));
                        },
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Modifier'),
                    SlidableAction(
                      // An action can be bigger than the others.
                      onPressed: (context) => _deletePerso(perso),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Supprimer',
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(perso!.nomPers,
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.poppins(
                                      color: accentColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  "${act!.nomAct.toUpperCase()} ${act.prenAct}",
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.poppins(
                                      color: backColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500)),
                              Text(film!.titre,
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.poppins(
                                      color: backColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold))
                            ]),
                      ]),
                ),
              ),
            ),
          ),
        );
        list.add(row);
      });
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, DataState>(
      builder: (context, state) {
        if (state is DataLoaded) {
          return BlocConsumer<DataCubit, DataState>(
            listener: (context, state) {
              if (state is DataError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Expanded(
                child: RefreshIndicator(
                    onRefresh: _pullRefresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        GridView.count(
                          shrinkWrap: true,
                          childAspectRatio: 3 / 1,
                          dragStartBehavior: DragStartBehavior.down,
                          primary: false,
                          addSemanticIndexes: false,
                          addRepaintBoundaries: false,
                          addAutomaticKeepAlives: false,
                          padding: const EdgeInsets.only(bottom: 10),
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          crossAxisCount: 1,
                          children: getFilmTiles(state),
                        ),
                      ],
                    )),
              );
            },
          );
        } else if (state is DataLoading) {
          return buildLoadingData();
        } else if (state is DataInitial) {
          return buildInitial();
        } else {
          return buildInitial();
        }
      },
    );
  }

  Widget buildInitial() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Center(
              child: Text(
                "Aucun personnage enregistr??.",
                style: GoogleFonts.poppins(color: textColor, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
