import 'dart:ui';

import 'package:cinemaepulmobile/constant.dart';
import 'package:cinemaepulmobile/cubit/data_cubit.dart';
import 'package:cinemaepulmobile/loading_component.dart';
import 'package:cinemaepulmobile/model/categorie.dart';
import 'package:cinemaepulmobile/model/film.dart';
import 'package:cinemaepulmobile/model/realisateur.dart';
import 'package:cinemaepulmobile/repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FormFilm extends StatefulWidget {
  final Film? film;
  const FormFilm({Key? key, this.film}) : super(key: key);

  @override
  State<FormFilm> createState() => _FormFilmState();
  static GlobalKey<FormState> _FormKey = GlobalKey<FormState>();
}

class _FormFilmState extends State<FormFilm> {
  String titre = "";
  String pageTitre = "";
  String actionPage = "";
  String textFinished = "";
  Categorie? cat = null;
  Realisateur? real = null;
  int duree = 0;
  String dateSortie = "";
  int budget = 0;
  int montantRecette = 0;
  int noRea = 0;
  String codeCat = "";

  var loadingCreate = false;

  late void Function() action;

  void create() {
    Film film = Film(
        titre: titre,
        duree: duree,
        dateSortie: DateTime.parse(dateSortie),
        budget: budget,
        montantRecette: montantRecette,
        noRea: noRea,
        codeCat: codeCat);
    context.read<DataCubit>().createFilm(film);
  }

  void update() {
    Film film = Film(
        noFilm: widget.film!.noFilm,
        titre: titre,
        duree: duree,
        dateSortie: DateTime.parse(dateSortie),
        budget: budget,
        montantRecette: montantRecette,
        noRea: noRea,
        codeCat: codeCat);
    context.read<DataCubit>().createFilm(film);
  }

  @override
  void initState() {
    super.initState();

    context.read<DataCubit>().getFilms();

    if (widget.film != null) {
      titre = widget.film!.titre;
      duree = widget.film!.duree;
      dateSortie = DateFormat("yyyy-MM-dd").format(widget.film!.dateSortie);
      budget = widget.film!.budget;
      montantRecette = widget.film!.montantRecette;
      noRea = widget.film!.noRea;
      codeCat = widget.film!.codeCat;
      pageTitre = "Modifier";
      actionPage = "Enregistrer";
      textFinished = "Modification";
      action = update;
    } else {
      pageTitre = "Ajouter un film";
      actionPage = "Créer";
      textFinished = "Création";
      action = create;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, DataState>(
      builder: (context, state) {
        if (state is DataLoaded) {
          return BlocConsumer<DataCubit, DataState>(listener: (context, state) {
            if (state is DataError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          }, builder: (context, state) {
            cat = (state as DataLoaded)
                .cats
                .where((element) => element!.codeCat == widget.film!.codeCat)
                .take(1)
                .toList()[0];

            real = (state as DataLoaded)
                .reals
                .where((element) => element!.noRea == widget.film!.noRea)
                .take(1)
                .toList()[0];
            return Scaffold(
              backgroundColor: backColor,
              body: SingleChildScrollView(
                child: Builder(builder: (context) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration:
                            BoxDecoration(color: Colors.white.withOpacity(0.0)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Builder(builder: (context) {
                                      return TextButton(
                                          onPressed: () =>
                                              {Navigator.pop(context)},
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateColor
                                                      .resolveWith((states) =>
                                                          accentColor),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              )),
                                          child: Icon(
                                            Icons.arrow_back,
                                            color: textColor,
                                          ));
                                    }),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      pageTitre,
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.poppins(
                                          color: textColor,
                                          fontSize: 30,
                                          height: 1),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: getForm(state),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          });
        } else if (state is DataLoading) {
          return buildLoading(context);
        } else if (state is DataInitial) {
          return buildInitial();
        } else if (state is DataCreated) {
          return buildFinished();
        } else {
          return buildInitial();
        }
      },
    );
  }

  Widget getForm(state) {
    return Form(
      key: FormFilm._FormKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: titre,
            onChanged: (value) => titre = value,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 1),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 2),
              ),
              prefixIcon: Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Icon(Icons.title, color: textColor),
              ),
              hintText: "Titre",
              hintStyle: TextStyle(
                color: textColor,
                fontSize: 15,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w300,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 1),
              ),
            ),
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
            ),
            autovalidateMode: AutovalidateMode.disabled,
            validator: (value) {
              if (!(value == null) && value.isEmpty) {
                return "Le titre est requis";
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            initialValue: duree.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) => duree = int.parse(value),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 1),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 2),
              ),
              prefixIcon: Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Icon(Icons.watch_later, color: textColor),
              ),
              hintText: "Durée (min)",
              hintStyle: TextStyle(
                color: textColor,
                fontSize: 15,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w300,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 1),
              ),
            ),
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
            ),
            autovalidateMode: AutovalidateMode.disabled,
            validator: (value) {
              if (!(value == null) && value.isEmpty) {
                return "La durée est requise";
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            initialValue: dateSortie,
            keyboardType: TextInputType.datetime,
            onChanged: (value) => dateSortie = value,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 1),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 2),
              ),
              prefixIcon: Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Icon(Icons.calendar_today, color: textColor),
              ),
              hintText: "Date de sortie",
              hintStyle: TextStyle(
                color: textColor,
                fontSize: 15,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w300,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 1),
              ),
            ),
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
            ),
            autovalidateMode: AutovalidateMode.disabled,
            validator: (value) {
              if (!(value == null) && value.isEmpty) {
                return "La date de sortie est requise";
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            initialValue: budget.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) => budget = int.parse(value),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 1),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 2),
              ),
              prefixIcon: Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Icon(Icons.attach_money, color: textColor),
              ),
              hintText: "Budget",
              hintStyle: TextStyle(
                color: textColor,
                fontSize: 15,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w300,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 1),
              ),
            ),
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
            ),
            autovalidateMode: AutovalidateMode.disabled,
            validator: (value) {
              if (!(value == null) && value.isEmpty) {
                return "Le budget est requis";
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            initialValue: montantRecette.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) => montantRecette = int.parse(value),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 1),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 2),
              ),
              prefixIcon: Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Icon(Icons.money, color: textColor),
              ),
              hintText: "Montant recette",
              hintStyle: TextStyle(
                color: textColor,
                fontSize: 15,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w300,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 1),
              ),
            ),
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
            ),
            autovalidateMode: AutovalidateMode.disabled,
            validator: (value) {
              if (!(value == null) && value.isEmpty) {
                return "Le montant des recette est requis";
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          DropdownButtonFormField<Realisateur>(
            value: real,
            items: getRealItems(state),
            onChanged: (real) => noRea = real!.noRea,
            dropdownColor: backColor,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 1),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 2),
              ),
              prefixIcon: Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Icon(Icons.account_circle, color: textColor),
              ),
              errorText: "Le réalisateur est requis",
              hintText: "Réalisateur",
              hintStyle: TextStyle(
                color: textColor,
                fontSize: 15,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w300,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 1),
              ),
            ),
            autovalidateMode: AutovalidateMode.disabled,
            validator: (value) {
              if (!(value == null) && value.noRea == null) {
                return "Le réalisateur est requis";
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          DropdownButtonFormField<Categorie>(
            value: cat,
            items: getCatItems(state),
            onChanged: (categorie) => codeCat = categorie!.codeCat,
            autovalidateMode: AutovalidateMode.disabled,
            validator: (value) {
              if (!(value == null) && value.codeCat.isEmpty) {
                return "La catégorie est requise";
              }
            },
            dropdownColor: backColor,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 1),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 2),
              ),
              prefixIcon: Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Icon(Icons.category, color: textColor),
              ),
              hintText: "Catégorie",
              errorText: "La catégorie est requise",
              hintStyle: TextStyle(
                color: textColor,
                fontSize: 15,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w300,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 1),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: loadingCreate
                    ? () {}
                    : () {
                        if (FormFilm._FormKey.currentState!.validate()) {
                          setState(() {
                            loadingCreate = true;
                          });
                          action();
                        }
                      },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateColor.resolveWith((states) => accentColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )),
                child: loadingCreate
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            )),
                      )
                    : Text(
                        actionPage,
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<Realisateur>> getRealItems(state) {
    List<Realisateur?> reals = state.reals;

    List<DropdownMenuItem<Realisateur>> items = [];
    reals.forEach((Realisateur? real) {
      var item = DropdownMenuItem<Realisateur>(
        value: real,
        child: Text("${real!.prenRea} ${real.nomRea}",
            textAlign: TextAlign.start,
            style: GoogleFonts.poppins(
                color: textColor, fontSize: 15, fontWeight: FontWeight.w500)),
      );
      items.add(item);
    });
    return items;
  }

  List<DropdownMenuItem<Categorie>> getCatItems(state) {
    List<Categorie?> cats = state.cats;

    List<DropdownMenuItem<Categorie>> items = [];
    cats.forEach((Categorie? categorie) {
      var item = DropdownMenuItem<Categorie>(
        value: categorie,
        child: Text(categorie!.libelleCat,
            textAlign: TextAlign.start,
            style: GoogleFonts.poppins(
                color: textColor, fontSize: 15, fontWeight: FontWeight.w500)),
      );
      items.add(item);
    });
    return items;
  }

  Widget buildInitial() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Center(
          child: Text(
            "Aucun film enregistré.",
            style: GoogleFonts.poppins(color: textColor, fontSize: 20),
          ),
        )
      ],
    );
  }

  Widget buildFinished() {
    return Scaffold(
      backgroundColor: backColor,
      body: SingleChildScrollView(
        child: Builder(builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Builder(builder: (context) {
                              return TextButton(
                                  onPressed: () => {Navigator.pop(context)},
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => accentColor),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      )),
                                  child: Icon(
                                    Icons.close,
                                    color: textColor,
                                  ));
                            }),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text("$textFinished terminée !")),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
