import 'dart:ui';

import 'package:cinemaepulmobile/brand_logo.dart';
import 'package:cinemaepulmobile/constant.dart';
import 'package:cinemaepulmobile/cubit/data_cubit.dart';
import 'package:cinemaepulmobile/cubit/users_cubit.dart';
import 'package:cinemaepulmobile/form/film_form.dart';
import 'package:cinemaepulmobile/form/real_form.dart';
import 'package:cinemaepulmobile/list_film_component.dart';
import 'package:cinemaepulmobile/list_real_component.dart';
import 'package:cinemaepulmobile/loading_component.dart';
import 'package:cinemaepulmobile/login_page.dart';
import 'package:cinemaepulmobile/repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List plants = [];
  String username = "";
  String password = "";

  int index = 0;

  List<String> titles = ["Nos Films", "Les Réal's"];
  List<Widget> forms = [
    BlocProvider(
      create: (context) => DataCubit(DataRepository()),
      child: const FormFilm(),
    ),
    BlocProvider(
      create: (context) => DataCubit(DataRepository()),
      child: const FormReal(),
    ),
  ];
  List<Widget> widgets = [
    const ListFilms(),
    const ListReals(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, state) {
        if (state is UsersSigned) {
          return buildInitialInput();
        } else if (state is UsersLoading) {
          return buildLoading(context);
        } else if (state is UsersInitial) {
          return const LoginPage();
        } else {
          return buildInitialInput();
        }
      },
    );
  }

  Widget buildInitialInput() {
    return BlocConsumer<UsersCubit, UsersState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: backColor,
            drawer: SafeArea(
              child: Drawer(
                backgroundColor: backColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: brand_logo(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  index = 0;
                                });
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => accentColor),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  )),
                              child: Text(
                                titles[0],
                                style: GoogleFonts.poppins(
                                  color: textColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  index = 1;
                                });
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => accentColor),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  )),
                              child: Text(
                                titles[1],
                                style: GoogleFonts.poppins(
                                  color: textColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ]),
                    )
                  ], // Populate the Drawer in the next step.
                ),
              ),
            ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Builder(builder: (context) {
                                  return TextButton(
                                      onPressed: () =>
                                          {Scaffold.of(context).openDrawer()},
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
                                        Icons.menu,
                                        color: textColor,
                                      ));
                                }),
                                Text(
                                  titles[index],
                                  style: GoogleFonts.poppins(
                                      color: textColor,
                                      fontSize: 30,
                                      height: 1),
                                ),
                                TextButton(
                                    onPressed: () async {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return forms[index];
                                      }));
                                    },
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
                                    child: Icon(Icons.add, color: textColor)),
                              ],
                            ),
                            BlocProvider(
                              create: (context) => DataCubit(DataRepository()),
                              child: widgets[index],
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
  }
}
