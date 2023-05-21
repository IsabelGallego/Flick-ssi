// ignore: file_names
import 'package:flickssi/pages/main_page.dart';
import 'package:flutter/material.dart';

import 'package:flickssi/services/firebase_service.dart';



// ignore: camel_case_types
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
                    // ignore: use_build_context_synchronously
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
