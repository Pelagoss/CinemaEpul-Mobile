import 'package:cinemaepulmobile/cubit/users_cubit.dart';
import 'package:cinemaepulmobile/repository/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cinemaepulmobile/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'CinEpul.',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: BlocProvider(
        create: (context) => UsersCubit(UsersRepository()),
        child: const LoginPage(),
      ),
    );
  }
}
