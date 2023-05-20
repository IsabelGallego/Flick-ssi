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

class botonGithub extends StatelessWidget {
  const botonGithub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
                      MaterialPageRoute(builder: (context) => const MainPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red, // Color del texto del botón
                  ),
                  child: const Text("Iniciar con Github"),
                ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
