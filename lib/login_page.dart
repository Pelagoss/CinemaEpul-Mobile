import 'package:cinemaepulmobile/brand_logo.dart';
import 'package:cinemaepulmobile/constant.dart';
import 'package:cinemaepulmobile/cubit/users_cubit.dart';
import 'package:cinemaepulmobile/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
  static GlobalKey<FormState> _loginScreenFormKey = GlobalKey<FormState>();
  static GlobalKey<FormState> _registerScreenFormKey = GlobalKey<FormState>();
}

class _LoginPageState extends State<LoginPage> {
  String username = "";
  String pseudo = "";
  String password = "";

  var loadingLogin = false;
  var loadingRegister = false;
  var loadingGoogle = false;

  var login = true;

  void signInWithEmailPwd() {
    context
        .read<UsersCubit>()
        .signInUser(username, password)
        .then((value) => reinitState());
  }

  void reinitState() {
    loadingLogin = false;
    username = "";
    password = "";
  }

  @override
  Widget build(BuildContext context) {
    //var currentUser = FirebaseAuth.instance.currentUser;

    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, state) {
        if (state is UsersSigned) {
          return const HomePage();
        } else {
          return buildInitialInput();
        }
      },
    );
  }

  Widget buildInitialInput() {
    return BlocConsumer<UsersCubit, UsersState>(listener: (context, state) {
      if (state is UsersError) {
        loadingLogin = false;
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
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [brand_logo()],
                    ),
                    const SizedBox(
                      height: 90,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: Builder(builder: (context) {
                        return loginScreen();
                      }),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      );
    });
  }

  Widget loginScreen() {
    return Form(
      key: LoginPage._loginScreenFormKey,
      child: Column(
        children: [
          TextFormField(
            onChanged: (value) => username = value,
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
                child: Icon(Icons.email, color: textColor),
              ),
              hintText: "Nom d'utilisateur",
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
            height: 15,
          ),
          TextFormField(
            obscureText: true,
            onChanged: (value) => password = value,
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
                child: Icon(Icons.vpn_key, color: textColor),
              ),
              hintText: "Mot de passe",
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
                onPressed: loadingLogin
                    ? () => {}
                    : () {
                        setState(() {
                          loadingLogin = true;
                        });
                        signInWithEmailPwd();
                      },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateColor.resolveWith((states) => accentColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )),
                child: loadingLogin
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
                        "Se connecter",
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
}
