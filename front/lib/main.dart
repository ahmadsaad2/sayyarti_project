import 'package:flutter/material.dart';
import 'Screens/Welcome/welcome_screen.dart';
import 'package:sayyarti/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final theme = ThemeData(
  primaryColor: const Color.fromARGB(255, 8, 75, 219),
  scaffoldBackgroundColor: Colors.white,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 7, 44, 146),
      shape: const StadiumBorder(),
      maximumSize: const Size(double.infinity, 56),
      minimumSize: const Size(double.infinity, 56),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: kPrimaryLightColor,
    iconColor: Color.fromRGBO(13, 11, 134, 1),
    prefixIconColor: Color.fromARGB(255, 0, 24, 161),
    contentPadding: EdgeInsets.symmetric(
        horizontal: defaultPadding, vertical: defaultPadding),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide.none,
    ),
  ),
);

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sayyarti',
        theme: theme,
        home: const WelcomeScreen(),
      ),
    );
  }
}
