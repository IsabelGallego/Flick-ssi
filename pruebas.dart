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
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Column(
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
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainPage()),
                            );
                          },
                          child: const Text("Iniciar con Google")),
                    ],
                  );
                  //
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )),
            //
          ],
        ),
      ),
    ));
  }

  @override
  Widget build2(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("home"),
        ),
        //
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          //
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
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainPage()),
                            );
                          },
                          child: const Text("Iniciar con Google")),
                    ],
                  );
                  //
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )),
            //
          ],
        ));
  }
}







import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flickssi/constants/constants.dart';
import 'package:flickssi/widgets/icon_widget.dart';
import 'package:flickssi/widgets/text1.dart';
import 'package:flickssi/widgets/text2.dart';

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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: Theme.of(context).primaryColor)),
                  child: Center(
                    child: TextFormField(
                      cursorColor:
                          Theme.of(context).primaryTextTheme.bodyLarge?.color,
                      decoration: InputDecoration(
                        hintText: 'Ingresa tu correo',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: const IconWidget(iconPath: MyIcons.mail),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: Theme.of(context).primaryColor)),
                  child: TextFormField(
                    obscureText: true,
                    cursorColor: MyColors.kPrimaryLightTextcolor,
                    decoration: InputDecoration(
                      hintText: 'Ingresa tu contraseña',
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const IconWidget(iconPath: MyIcons.eye),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: (() {
                    Get.toNamed('/main');
                  }),
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 0, 0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text2(text: '¿Olvidaste tu contraseña?'),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text2(text: '¿No tienes una cuenta? '),
                    Text2(
                        text: 'Registrate',
                        //  fontColor: MyColors.kPrimaryLightTextcolor,
                        isBold: true),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}








class botonGoogle extends StatelessWidget {
  const botonGoogle({Key ?key}):super (key: key);
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
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainPage()),
                            );
                          },
                          child: const Text("Iniciar con Google")),
                    ],
                  );
                  //
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )),
            //
          ],
        ),
      ),
    ));
  }
}







InkWell(
                  onTap: (() {
                    Get.toNamed('/main');
                  }),
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 0, 0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),