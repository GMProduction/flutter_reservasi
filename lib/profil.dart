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

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  bool readyToHit = true;
  final req = new GenRequest();
  var name, email, nim, jurusan, stateKelas;
  dynamic dataUser;
  List listkelas = [
    {"kelas": "A"},
    {"kelas": "B"},
    {"kelas": "C"},
  ];

  @override
  void initState() {
    // TODO: implement initState
    // analytics.
    getUser();
    super.initState();
  }

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
        child: name == null ?  Center(child: CircularProgressIndicator()) : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              GenText(
                "Profil",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),
              TextLoginField(
                initVal: nim,
                width: double.infinity,
                label: "Nim",
                keyboardType: TextInputType.text,
//                                    controller: tecNumber,
                onChanged: (val) {
                  nim = val;
                },
                validator: (val) {
                  if (val.length < 1) {
                    return "Isi Nim Dengan Benar";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextLoginField(
                initVal:  name,
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
                height: 30,
              ),
              TextLoginField(
                initVal: jurusan,
                width: double.infinity,
                label: "Jurusan",
                keyboardType: TextInputType.text,
//                                    controller: tecNumber,
                onChanged: (val) {
                  jurusan = val;
                },
                validator: (val) {
                  if (val.length < 1) {
                    return "Isi Jurusan Dengan Benar";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: double.infinity,
                  child: GenText(
                    "Kelas",
                    textAlign: TextAlign.start,
                  )),
              CommonPadding(
                child: GenRadioGroupMiniString(
                  listData: listkelas,
                  ontap: (val) {
                    setState(() {
                      stateKelas = val["id"];
                    });
                  },
                  id: "kelas",
                  initValue: stateKelas,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextLoginField(
                initVal: email,
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
              readyToHit
                  ? GenButton(
                      text: "UBAH",
                      ontap: () {
                        reg();
                      },
                    )
                  : CircularProgressIndicator(),
              SizedBox(
                height: 30,
              ),
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
    data = await req.postForm("user", {
      "name": name,
      "email": email,
      "nim": nim,
      "jurusan": jurusan,
      "kelas": stateKelas
    });

    print("DATA $data");
    setState(() {
      readyToHit = true;
    });

      setState(() {
        toastShow("Profil Berhasil di ubah ",
            context, Colors.black);
      });
      Navigator.pushReplacementNamed(context, "base");

  }

  void getUser() async {
    dataUser = await req.getApi("user");

    name = dataUser["data"]["name"];
    email = dataUser["data"]["email"];
    stateKelas = dataUser["data"]["kelas"];
    nim = dataUser["data"]["nim"].toString();
    jurusan = dataUser["data"]["jurusan"];

    print(dataUser);
    print(name);
    setState(() {});
  }
}
