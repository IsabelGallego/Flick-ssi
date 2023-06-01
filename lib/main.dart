import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:flickssi/pages/home_page.dart';
import 'package:flickssi/pages/login_page.dart';
import 'package:flickssi/pages/main_page.dart';
import 'package:flickssi/pages/details_page.dart';
import 'package:flickssi/themes/themes.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flick--SSI',
      themeMode: ThemeMode.system,
      theme: MyThemes.lightTheme(context),
      darkTheme: MyThemes.darkTheme(context),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/main', page: () => const MainPage()),
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(
            name: '/deatils',
            page: () => const DetailsPage(
                  movie: {},
                )),
      ],
    );
  }
}
