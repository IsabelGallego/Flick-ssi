import 'package:flickssi/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flickssi/constants/constants.dart';
import 'package:flickssi/widgets/icon_widget.dart';
import 'package:flickssi/widgets/text1.dart';
import 'package:flickssi/widgets/text2.dart';
import 'package:flickssi/services/firebase_service.dart';

import 'package:flutter/material.dart';
import 'package:flickssi/services/firebase_service.dart';
import 'package:flickssi/home/home.dart';

void main() {
  runApp(const MaterialApp(
    title: 'login',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("home"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: FutureBuilder(
              future: FirebaseService.firebaseIni(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            await FirebaseService.signInWithGoogle();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainPage()),
                            );
                          },
                          child: Text("Iniciar con Google")),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )),
            Center(
              child: ElevatedButton(
                child: const Text('Iniciar con twitter'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                child: const Text('Iniciar con Facebook'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
