import 'package:flutter/material.dart';
import 'package:flickssi/constants/constants.dart';
import 'package:flickssi/models/profile_list_tile_model.dart';
import 'package:flickssi/widgets/icon_widget.dart';
import 'package:flickssi/widgets/text1.dart';
import 'package:flickssi/widgets/text2.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    const Text1(
                      text: 'Usuario',
                      fontSize: 25,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: SizedBox(
              height: double.maxFinite,
              child: ListView.builder(
                  itemCount: profileListTile.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: IconWidget(
                        iconPath: profileListTile[index].iconPath,
                      ),
                      title: Text1(
                        text: profileListTile[index].title,
                        isBold: false,
                      ),
                      subtitle: Text2(text: profileListTile[index].subtitle),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
