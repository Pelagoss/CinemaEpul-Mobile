import 'dart:ui';

import 'package:cinemaepulmobile/constant.dart';
import 'package:cinemaepulmobile/cubit/data_cubit.dart';
import 'package:cinemaepulmobile/loading_component.dart';
import 'package:cinemaepulmobile/model/acteur.dart';
import 'package:cinemaepulmobile/model/categorie.dart';
import 'package:cinemaepulmobile/model/film.dart';
import 'package:cinemaepulmobile/model/personnage.dart';
import 'package:cinemaepulmobile/model/realisateur.dart';
import 'package:cinemaepulmobile/repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FormActeur extends StatefulWidget {
  final Acteur? acteur;
  const FormActeur({Key? key, this.acteur}) : super(key: key);

  @override
  State<FormActeur> createState() => _FormActeurState();
  static GlobalKey<FormState> _FormKey = GlobalKey<FormState>();
}

class _FormActeurState extends State<FormActeur> {
  String pageTitre = "";
  int noAct = 0;
  String nomAct = "";
  String prenAct = "";
  DateTime? dateNaiss = null;
  DateTime? dateDeces = null;
  String actionPage = "";
  String textFinished = "";

  var loadingCreate = false;

  late void Function() action;

  void create() {
    Acteur acteur = Acteur(
        noAct: noAct,
        nomAct: nomAct,
        prenAct: prenAct,
        dateNaiss: dateNaiss!,
        dateDeces: dateDeces);
    context.read<DataCubit>().createActeur(acteur);
  }

  void update() {
    Acteur acteur = Acteur(
        noAct: widget.acteur!.noAct,
        nomAct: nomAct,
        prenAct: prenAct,
        dateNaiss: dateNaiss!,
        dateDeces: dateDeces);
    context.read<DataCubit>().createActeur(acteur);
  }

  @override
  void initState() {
    super.initState();

    context.read<DataCubit>().getFilms();

    if (widget.acteur != null) {
      nomAct = widget.acteur!.nomAct;
      prenAct = widget.acteur!.prenAct;
      dateNaiss = widget.acteur!.dateNaiss;
      dateDeces = widget.acteur!.dateDeces;
      pageTitre = "Modifier";
      actionPage = "Enregistrer";
      textFinished = "Modification";
      action = update;
    } else {
      pageTitre = "Ajouter un acteur";
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
                                    Flexible(
                                      child: Text(
                                        pageTitre,
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        style: GoogleFonts.poppins(
                                            color: textColor,
                                            fontSize: 30,
                                            height: 1),
                                      ),
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
      key: FormActeur._FormKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: nomAct,
            onChanged: (value) => nomAct = value,
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
              hintText: "Nom de l'acteur",
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
                return "Le nom est requis";
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            initialValue: prenAct,
            onChanged: (value) => prenAct = value,
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
              hintText: "Prénom de l'acteur",
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
                return "Le prénom est requis";
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            initialValue: dateNaiss == null
                ? ''
                : DateFormat('yyyy-MM-dd').format(dateNaiss!),
            keyboardType: TextInputType.datetime,
            onChanged: (value) => dateNaiss = DateTime.parse(value),
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
              hintText: "Date de naissance",
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
                return "La date de naissance est requise";
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            initialValue: dateDeces == null
                ? ''
                : DateFormat('yyyy-MM-dd').format(dateDeces!),
            keyboardType: TextInputType.datetime,
            onChanged: (value) => dateDeces = DateTime.parse(value),
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
              hintText: "Date de décès",
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
                        if (FormActeur._FormKey.currentState!.validate()) {
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
                          child: Center(
                            child: Text("$textFinished terminée !",
                                style: GoogleFonts.poppins(
                                    color: textColor, fontSize: 20)),
                          )),
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

  List<DropdownMenuItem<Film>> getFilmItems(state) {
    List<Film?> films = state.films;

    List<DropdownMenuItem<Film>> items = [];
    films.forEach((Film? film) {
      var item = DropdownMenuItem<Film>(
        value: film,
        child: Text(film!.titre,
            textAlign: TextAlign.start,
            style: GoogleFonts.poppins(
                color: textColor, fontSize: 15, fontWeight: FontWeight.w500)),
      );
      items.add(item);
    });
    return items;
  }
}
