import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reservasi_app/component/TextFieldLogin.dart';
import 'package:reservasi_app/component/genButton.dart';
import 'package:reservasi_app/component/genPreferrence.dart';
import 'package:reservasi_app/component/genText.dart';

import 'component/commonPadding.dart';
import 'component/genColor.dart';
import 'component/genRadioMini.dart';
import 'component/genToast.dart';
import 'component/request.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool readyToHit = true;
  final req = new GenRequest();
  var name, email, password, passwordkonf, stateKelas;
  List listkelas = [
    {"kelas": "A"},
    {"kelas": "B"},
    {"kelas": "C"},
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Image.network(
                "https://itbaas.ac.id/wp-content/uploads/2021/02/cropped-Logo-ITB-AAS-1.png",
                fit: BoxFit.fitWidth,
                height: 100.0,
                width: 100.0,
                alignment: Alignment.topCenter,
              ),
              SizedBox(
                height: 30,
              ),
              GenText(
                "Daftar",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),
              TextLoginField(
                initVal: "",
                width: double.infinity,
                label: "Nama",
                keyboardType: TextInputType.text,
//                                    controller: tecNumber,
                onChanged: (val) {
                  name = val;
                },
                validator: (val) {
                  if (val.length < 1) {
                    return "Isi Nama Dengan Benar";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(width: double.infinity,child: GenText("Kelas", textAlign: TextAlign.start,)),
              CommonPadding(
                child: GenRadioGroupMiniString(
                  listData: listkelas,
                  ontap: (val) {
                    setState(() {
                      stateKelas = val["id"];
                    });
                  },
                  id: "kelas",
                  initValue: "A",
                ),
              ),
              SizedBox(
                height: 20,
              ),
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
              SizedBox(
                height: 20,
              ),
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
              SizedBox(
                height: 20,
              ),
              TextLoginField(
                initVal: "",
                width: double.infinity,
                label: "konfirmasi password",
                keyboardType: TextInputType.visiblePassword,
//                                    controller: tecNumber,
                obscureText: true,
                onChanged: (val) {
                  passwordkonf = val;
                },
                validator: (val) {
                  if (val.length < 7) {
                    return "Minimal 8 karakter";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 30,
              ),
              readyToHit
                  ? GenButton(
                      text: "DAFTAR",
                      ontap: () {
                        reg();
                      },
                    )
                  : CircularProgressIndicator(),
              SizedBox(
                height: 30,
              ),
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "login");
                  },
                  child: GenText(
                    "Jika Sudah Punya akun login disini",
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void reg() async {
    setState(() {
      readyToHit = false;
    });
    dynamic data;
    data = await req.postRegisterForm("register", {
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": passwordkonf,
      "roles": "USER",
      "kelas": stateKelas
    });

    print("DATA $data");
    setState(() {
      readyToHit = true;
    });
    if (data["meta"] != Null) {
      await setPrefferenceToken(data["data"]["acces_token"]);
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
