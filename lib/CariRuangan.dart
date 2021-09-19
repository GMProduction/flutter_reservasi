import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:reservasi_app/component/commonPadding.dart';
import 'package:reservasi_app/component/genRadioMini.dart';
import 'package:reservasi_app/component/genShadow.dart';
import 'package:reservasi_app/component/genText.dart';
import 'package:reservasi_app/component/textAndTitle.dart';

import 'blocks/baseBloc.dart';
import 'component/NavDrawer.dart';
import 'component/TextFieldLogin.dart';
import 'component/genButton.dart';
import 'component/genColor.dart';
import 'component/genToast.dart';
import 'component/request.dart';

class CariRuangan extends StatefulWidget {
  final String mulai;
  final String selesai;
  final String tanggal;

  CariRuangan({this.mulai, this.selesai, this.tanggal});

  @override
  _CariRuanganState createState() => _CariRuanganState();
}

class _CariRuanganState extends State<CariRuangan> with WidgetsBindingObserver {
  final req = new GenRequest();
  bool readyToHit = true;

  List listData = [
    {"ruang": "R1.1"},
    {"ruang": "R1.2"},
    {"ruang": "R1.3"},
    {"ruang": "R2.1"},
    {"ruang": "R2.2"},
    {"ruang": "R2.3"},
  ];

//  VARIABEL

  bool loading = false;

  // NotifBloc notifbloc;
  bool isLoaded = false;

//  double currentgurulainValue = 0;
  PageController gurulainController = PageController();
  var stateMetodBelajar = 1;
  var bloc;
  var clientId;
  var stateRuangan;
  var keterangan;
  dynamic dataRuangan;

  @override
  void initState() {
    // TODO: implement initState
    // analytics.

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

//  FUNCTION

  var mulai, selesai, tanggal;
  String clienId;

//  getRoom() async {
//    clienId = await getPrefferenceIdClient();
//    return clienId;
//  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    isLoaded = false;
    // notifbloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: GenColor.primaryColor, // status bar color
    ));
    final CariRuangan args = ModalRoute.of(context).settings.arguments;
    mulai = args.mulai;
    selesai = args.selesai;
    tanggal = args.tanggal;

    print(isLoaded);
    getRuangan();

    print(mulai);
    print(selesai);
    print(tanggal);

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    bloc = Provider.of<BaseBloc>(context);
    // notifbloc = Provider.of<NotifBloc>(context);

    // sendAnalyticsEvent(testLogAnalytic);
    // print("anal itik "+testLogAnalytic);

    // notifbloc.getTotalNotif();

    // bloc.util.getActiveOnline();
    // bloc.util.getNotifReview();
    // bloc.util.getRekomendasiAll("district", "level", 1, "limit", "offset");

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: GenColor.primaryColor,
        elevation: 0,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "notifikasi");
                  // sendAnalyticsEvent(testLogAnalytic);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      size: 26.0,
                    ),
                  ],
                ),
              )),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            CommonPadding(
                child: GenText(
              "Informasi Ruangan yang Sedang di Gunakan",
              style: TextStyle(fontSize: 25),
            )),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CommonPadding(
                      child: dataRuangan == null
                          ? Container()
                          : GenRadioGroupMiniWrapRuangan(
                              listData: dataRuangan,
                              ontap: (val) {
                                setState(() {
                                  stateRuangan = val["id"];
                                });
                              },
                              id: "id",
                              fixWidth: 100,
                              title: "nama",
                              status: "status",
                            ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CommonPadding(
                      child: TextLoginField(
                        initVal: "",
                        width: double.infinity,
                        label: "Nama",
                        keyboardType: TextInputType.text,
//                                    controller: tecNumber,
                        onChanged: (val) {
                          keterangan = val;
                        },
                        validator: (val) {
                          if (val.length < 1) {
                            return "Isi Keterangan Dengan Benar";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CommonPadding(
                        child: readyToHit
                            ? GenButton(
                      text: "Reservasi Sekarang",
                      ontap: () {
                        reservasi();
                      },
                    ) : CircularProgressIndicator())
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getRuangan() async {
    dataRuangan = await req.getApi(
        "cari-ruangan?date=" + tanggal + "&start=" + mulai + "&end=" + selesai);
    print(dataRuangan);
    if (!isLoaded) {
      print("hoiii");
      setState(() {});
      isLoaded = true;
    }
  }

  void reg() async {
    setState(() {
      readyToHit = false;
    });
    dynamic data;
    data = await req.postForm("reservation", {
      "tanggal": tanggal,
      "jam": mulai,
      "selesai": selesai,
      "keterangan": keterangan,
      "ruang": stateRuangan,
    });

    print("DATA $data");
    setState(() {
      readyToHit = true;
    });
    if (data["meta"] != Null) {
      setState(() {
        toastShow("Reservasi Berhasil", context, Colors.black);
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

  void reservasi() {
    if (stateRuangan == 0 || stateRuangan == null) {
      toastShow("Harus memilih ruangan dahulu", context, GenColor.red);
    }else if(keterangan == null){
      toastShow("Harus mengisi keterangan dahulu", context, GenColor.red);
    }else{
    reg();
    }
  }
}
