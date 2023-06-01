import 'package:flickssi/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flickssi/models/profile_list_tile_model.dart';
import 'package:flickssi/widgets/icon_widget.dart';
import 'package:flickssi/widgets/text1.dart';
import 'package:flickssi/widgets/text2.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                    GoogleProfilePhoto(),
                    const SizedBox(width: 20),
                    FutureBuilder<User?>(
                      future: FirebaseAuth.instance.authStateChanges().first,
                      builder: (BuildContext context,
                          AsyncSnapshot<User?> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Mientras se carga el estado de autenticación, se muestra un indicador de carga
                          return const CircularProgressIndicator();
                        } else {
                          if (snapshot.hasData && snapshot.data != null) {
                            final user = snapshot.data!;
                            final displayName = user.displayName;

                            if (displayName != null) {
                              // Si se obtiene el nombre del usuario correctamente, se muestra en el Text widget
                              return Row(
                                children: [
                                  Text(
                                    displayName,
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
                          } else {
                            // Si el usuario no ha iniciado sesión, se muestra un mensaje alternativo
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

class GoogleProfilePhoto extends StatefulWidget {
  @override
  _GoogleProfilePhotoState createState() => _GoogleProfilePhotoState();
}

class _GoogleProfilePhotoState extends State<GoogleProfilePhoto> {
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
    return _isLoading
        ? CircularProgressIndicator()
        : CircleAvatar(
            radius: 40,
            backgroundImage: _user?.photoURL != null
                ? CachedNetworkImageProvider(_user!.photoURL!)
                : const AssetImage(
                        'assets/images/imagenes-pinguinos-emperadores.png')
                    as ImageProvider<Object>,
            backgroundColor: Theme.of(context).primaryColor,
          );
  }
}
