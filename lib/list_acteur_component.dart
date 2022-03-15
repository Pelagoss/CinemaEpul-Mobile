import 'dart:io';

import 'package:cinemaepulmobile/constant.dart';
import 'package:cinemaepulmobile/cubit/data_cubit.dart';
import 'package:cinemaepulmobile/form/acteur_form.dart';
import 'package:cinemaepulmobile/form/film_form.dart';
import 'package:cinemaepulmobile/loading_component.dart';
import 'package:cinemaepulmobile/model/acteur.dart';
import 'package:cinemaepulmobile/model/categorie.dart';
import 'package:cinemaepulmobile/model/film.dart';
import 'package:cinemaepulmobile/model/realisateur.dart';
import 'package:cinemaepulmobile/repository/data_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ListActeurs extends StatefulWidget {
  const ListActeurs({Key? key}) : super(key: key);

  @override
  State<ListActeurs> createState() => _ListActeursState();
}

class _ListActeursState extends State<ListActeurs> with RouteAware {
  Future<void> _pullRefresh() async {
    context.read<DataCubit>().getFilms();
  }

  void _deleteActeur(Acteur? acteur) async {
    context.read<DataCubit>().deleteActeur(acteur);
    sleep(const Duration(milliseconds: 1000));
    _pullRefresh();
  }

  @override
  void initState() {
    super.initState();
    context.read<DataCubit>().getFilms();
  }

  List<Widget> getActeurTiles(state) {
    List<Acteur?> acteurs = state.acteurs;
    List<Widget> list = [];
    if (acteurs != null) {
      acteurs.forEach((Acteur? acteur) {
        int ageCalc = calculateAge(acteur!.dateNaiss);
        String age = "$ageCalc ans";

        if (acteur.dateDeces != null) age = "";

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
                                child: FormActeur(acteur: acteur));
                          }));
                        },
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Modifier'),
                    SlidableAction(
                      // An action can be bigger than the others.
                      onPressed: (context) => _deleteActeur(acteur),
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
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(acteur.nomAct.toUpperCase(),
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.poppins(
                                            color: accentColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(acteur.prenAct,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.poppins(
                                            color: backColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600)),
                                  ]),
                              Text(
                                  "${DateFormat('dd/MM/yyyy').format(acteur.dateNaiss)} ${acteur.dateDeces != null ? '-' : ''} ${acteur.dateDeces != null ? DateFormat('dd/MM/yyyy').format(acteur.dateDeces!) : ''}",
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.poppins(
                                      color: backColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)),
                            ]),
                        Text(age,
                            style: GoogleFonts.poppins(
                                color: backColor, fontSize: 15)),
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

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
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
                          children: getActeurTiles(state),
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
                "Aucun film enregistré.",
                style: GoogleFonts.poppins(color: textColor, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
