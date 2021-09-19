import 'package:flutter/material.dart';
import 'package:reservasi_app/component/TextFieldLogin.dart';
import 'package:reservasi_app/component/genButton.dart';
import 'package:reservasi_app/component/genText.dart';

import 'component/genColor.dart';
import 'component/genPreferrence.dart';
import 'component/genToast.dart';
import 'component/request.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool readyToHit = true;
  final req = new GenRequest();

  var email, password;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(padding: EdgeInsets.all(30),width: double.infinity,
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100,),
          Image.network(
            "https://itbaas.ac.id/wp-content/uploads/2021/02/cropped-Logo-ITB-AAS-1.png",
            fit: BoxFit.fitWidth,
            height: 200.0,
            width: 200.0,
            alignment: Alignment.topCenter,
          ),
            SizedBox(height: 30,),
            GenText("Aplikasi Reservasi Ruang", style: TextStyle(fontSize: 20),),
            GenText("Institude Teknologi Bisnis AAS Indonesia", style: TextStyle(fontSize: 20),),
            SizedBox(height: 100,),
            TextLoginField(
              initVal: "",
              width: double.infinity,
              label: "Email",
              keyboardType: TextInputType.emailAddress,
//                                    controller: tecNumber,
              onChanged: (val) {
                email = val;
              },
              validator: (val) {
                if (val.length < 1) {
                  return "Isi Email Dengan Benar";
                } else {
                  return null;
                }
              },
            ),
            SizedBox(height: 20,),
            TextLoginField(
              initVal: "",
              width: double.infinity,
              label: "password",
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
//                                    controller: tecNumber,
              onChanged: (val) {
                password = val;
              },
              validator: (val) {
                if (val.length < 7) {
                  return "Minimal 8 karakter";
                } else {
                  return null;
                }
              },
            ),
            SizedBox(height: 30,),
            readyToHit
                ? GenButton(
              text: "SIGN IN",
              ontap: () {
                reg();
              },
            )
                : CircularProgressIndicator(),
            SizedBox(height: 30,),
            InkWell(onTap: (){
              Navigator.pushNamed(context, "register");
            },child: GenText("Jika Belum punya akun klik daftar di sini",)),

      ],),
        ),),
    );
  }

  void login(id) async {
    setState(() {
      readyToHit = false;
    });
    dynamic data;
    data =
    await req.postApi("login", {"lottery": id});

    print("DATA $data");
    setState(() {
      readyToHit = true;
    });
    if (data["code"] == 200) {
      setState(() {
        toastShow("Berhasil membeli kupon", context, Colors.black);
      });
      Navigator.pushReplacementNamed(context, "point");
    }  else if(data["code"] == 202){
      setState(() {
        toastShow(data["payload"]["msg"], context, GenColor.red);
      });
    }else {
      setState(() {
        toastShow("Terjadi kesalahan coba cek koneksi internet kamu", context,
            GenColor.red);
      });
    }
  }

  void reg() async {
    setState(() {
      readyToHit = false;
    });
    dynamic data;
    data = await req.postRegisterForm("login", {
      "email": email,
      "password": password,
      "roles": "USER"
    });

    print("DATA $data");
    setState(() {
      readyToHit = true;
    });
    if (data["meta"] != Null) {
      await setPrefferenceToken(data["data"]["access_token"]);
      await setPrefferenceKelas(data["data"]["user"]["kelas"]);
      setState(() {
        toastShow(
            "Selamat Datang " + data["data"]["user"]["name"].toString(), context, Colors.black);
      });
      Navigator.pushReplacementNamed(context, "base");
    } else if (data["meta"]["code"] == 202) {
      setState(() {
        toastShow(data.toString(), context, GenColor.red);
      });
    } else {
      setState(() {
        toastShow(data.toString(), context, GenColor.red);
      });
    }
  }
}
