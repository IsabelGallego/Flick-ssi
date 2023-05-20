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
                  Row(
                    children: [
                      Text(
                        'Hola, ',
                        style: TextStyle(
                            fontSize: 25,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .bodyLarge
                                ?.color),
                      ),
                      const Text(
                        'Patron',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ],
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
