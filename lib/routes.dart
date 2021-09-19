import 'package:provider/provider.dart';
import 'package:reservasi_app/CariRuangan.dart';
import 'package:reservasi_app/login.dart';
import 'package:reservasi_app/profil.dart';
import 'package:reservasi_app/register.dart';
import 'package:reservasi_app/splashScreen.dart';


import 'base.dart';
import 'blocks/baseBloc.dart';

class GenProvider {
  static var providers = [
    ChangeNotifierProvider<BaseBloc>.value(value: BaseBloc()),

  ];

  static routes(context) {
    return {
//           '/': (context) {
//        return Base();
//      },

      '/': (context) {
        return SplashScreen();
      },


      'login': (context) {
        // return Login();
        return Login();
      },


      'register': (context) {
        // return Login();
        return Register();
      },
      'base': (context) {
        return Base();
      },

      'cariruangan': (context) {
        return CariRuangan();
      },

      'profil': (context) {
        return Profil();
      },
    };
  }
}
