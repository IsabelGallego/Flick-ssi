// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:flickssi/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flickssi/models/profile_list_tile_model.dart';
import 'package:flickssi/widgets/icon_widget.dart';
import 'package:flickssi/widgets/text1.dart';
import 'package:flickssi/widgets/text2.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    Future<void> _signOut() async {
      try {
        await _googleSignIn.signOut();

        Navigator.pushReplacementNamed(context, '/login');
      } catch (error) {
        ('Error al cerrar sesión: $error');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text1(
          text: 'Profile',
          fontSize: 22,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 40,
                      backgroundImage: const AssetImage(
                          'assets/images/imagenes-pinguinos-emperadores.png'),
                    ),
                    const SizedBox(width: 20),
                    FutureBuilder<String?>(
                      future: FirebaseService.getUserName(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String?> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Mientras se carga el nombre del usuario, se muestra un indicador de carga
                          return const CircularProgressIndicator();
                        } else {
                          if (snapshot.hasData && snapshot.data != null) {
                            // Si se obtiene el nombre del usuario correctamente, se muestra en el Text widget
                            return Row(
                              children: [
                                Text(
                                  snapshot.data!,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            // Si no se puede obtener el nombre del usuario, se muestra un mensaje alternativo
                            return const Text(
                              'Hola, Usuario',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: profileListTile.length,
              itemBuilder: (context, index) {
                final tile = profileListTile[index];
                return ListTile(
                  leading: IconWidget(
                    iconPath: tile.iconPath,
                  ),
                  title: Text1(
                    text: tile.title,
                    isBold: false,
                  ),
                  subtitle: Text2(text: tile.subtitle),
                  onTap: () {
                    if (tile.title == 'Cerrar sesión') {
                      _signOut(); // Llama a la función _signOut para cerrar sesión
                    } else {
                      // Lógica para manejar otros elementos de la lista
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
