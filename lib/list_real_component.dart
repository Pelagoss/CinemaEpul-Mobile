import 'package:cinemaepulmobile/constant.dart';
import 'package:cinemaepulmobile/cubit/data_cubit.dart';
import 'package:cinemaepulmobile/form/real_form.dart';
import 'package:cinemaepulmobile/loading_component.dart';
import 'package:cinemaepulmobile/model/categorie.dart';
import 'package:cinemaepulmobile/model/film.dart';
import 'package:cinemaepulmobile/model/realisateur.dart';
import 'package:cinemaepulmobile/repository/data_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListReals extends StatefulWidget {
  const ListReals({Key? key}) : super(key: key);

  @override
  State<ListReals> createState() => _ListRealsState();
}

class _ListRealsState extends State<ListReals> with RouteAware {
  Future<void> _pullRefresh() async {
    context.read<DataCubit>().getFilms();
  }

  void _deleteReal(Realisateur? real) async {
    context.read<DataCubit>().deleteReal(real);
    _pullRefresh();
  }

  @override
  void initState() {
    super.initState();
    context.read<DataCubit>().getFilms();
  }

  List<Widget> getRealTiles(state) {
    List<Film?> films = state.films;
    List<Realisateur?> reals = state.reals;
    List<Categorie?> cats = state.cats;

    List<Widget> list = [];
    if (reals != null) {
      reals.forEach((Realisateur? real) {
        var row = Padding(
          padding:
              const EdgeInsets.only(left: 15.0, right: 15.0, top: 3, bottom: 3),
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
                              create: (context) => DataCubit(DataRepository()),
                              child: FormReal(realisateur: real));
                        }));
                      },
                      backgroundColor: Color(0xFF0392CF),
                      foregroundColor: Colors.white,
                      icon: Icons.save,
                      label: 'Modifier',
                    ),
                    SlidableAction(
                      // An action can be bigger than the others.
                      onPressed: (context) => _deleteReal(real),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Supprimer',
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(real!.nomRea,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                    color: accentColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(real.prenRea,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                    color: backColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600)),
                          ]),
                    ],
                  ),
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
                          childAspectRatio: 5 / 1,
                          dragStartBehavior: DragStartBehavior.down,
                          primary: false,
                          addSemanticIndexes: false,
                          addRepaintBoundaries: false,
                          addAutomaticKeepAlives: false,
                          padding: const EdgeInsets.only(bottom: 10),
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          crossAxisCount: 1,
                          children: getRealTiles(state),
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
                "Aucun réalisateur enregistré.",
                style: GoogleFonts.poppins(color: textColor, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
