import 'package:flickssi/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flickssi/widgets/text2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HeaderTile extends StatefulWidget {
  const HeaderTile({Key? key}) : super(key: key);

  @override
  _HeaderTileState createState() => _HeaderTileState();
}

class _HeaderTileState extends State<HeaderTile> {
  User? _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getUserProfilePhoto();
  }

  Future<void> _getUserProfilePhoto() async {
    setState(() {
      _isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

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
                        return const CircularProgressIndicator();
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
                  const SizedBox(height: 10),
                  const Text2(
                    text: "¿Qué quieres mirar?",
                    fontSize: 15,
                  ),
                ],
              ),
              _isLoading
                  ? CircularProgressIndicator()
                  : CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 30,
                      backgroundImage: _user?.photoURL != null
                          ? CachedNetworkImageProvider(_user!.photoURL!)
                          : const AssetImage(
                                  'aassets/images/imagenes-pinguinos-emperadores.png')
                              as ImageProvider<Object>?,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
