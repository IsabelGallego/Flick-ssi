import 'package:flickssi/widgets/botonGithub.dart';
import 'package:flickssi/widgets/botonGoogle.dart';
import 'package:flutter/material.dart';
import 'package:flickssi/widgets/text1.dart';
import 'package:flickssi/widgets/text2.dart';

void main() {
  runApp(const MaterialApp(
    title: 'login',
    home: LoginPage(),
  ));
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 110),
                const SizedBox(height: 10),
                const Text(
                  'Flick-SSI',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 30),
                const Text1(
                  text: 'inicia sesión para continuar',
                  fontSize: 20,
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                const botonGoogle(),
                const botonGithub(),
                const SizedBox(height: 10),
                
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text2(text: 'Flick-SSI - Desarrollo móvil '),
                    
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
