import 'package:flickssi/constants/constants.dart';

class ProfileListTileModel {
  final String iconPath, title, subtitle;

  ProfileListTileModel(this.title, this.subtitle, this.iconPath);
}

List<ProfileListTileModel> profileListTile = [
  ProfileListTileModel('Cuenta', 'Gestiona tu cuenta', MyIcons.key),
  ProfileListTileModel('Notificaciones', 'Mensajes', MyIcons.bell),
  ProfileListTileModel(
      'Datos y almacenamiento', 'Gestión de favoritos', MyIcons.data),
  ProfileListTileModel('Sobre nosotros', 'Flick-SSI', MyIcons.earth),
  ProfileListTileModel('Cerrar sesión', '', MyIcons.apagar),
];
