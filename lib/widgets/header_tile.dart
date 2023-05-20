import 'package:flickssi/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flickssi/widgets/text2.dart';

class HeaderTile extends StatelessWidget {
  const HeaderTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 12, right: 12, bottom: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<String?>(
                    future: FirebaseService.getUserName(),
                    builder: (BuildContext context,
                        AsyncSnapshot<String?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Mientras se carga el nombre del usuario, se muestra un indicador de carga
                        return CircularProgressIndicator();
                      } else {
                        if (snapshot.hasData && snapshot.data != null) {
                          // Si se obtiene el nombre del usuario correctamente, se muestra en el Text widget
                          return Row(
                            children: [
                              Text(
                                'Hola, ',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyLarge
                                      ?.color,
                                ),
                              ),
                              Text(
                                snapshot.data!,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        } else {
                          // Si no se puede obtener el nombre del usuario, se muestra un mensaje alternativo
                          return Text(
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
                  const SizedBox(height: 10),
                  const Text2(
                    text: "¿Que quieres mirar?",
                    fontSize: 15,
                  ),
                ],
              ),
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: 30,
                backgroundImage: const AssetImage(
                    'assets/images/imagenes-pinguinos-emperadores.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
