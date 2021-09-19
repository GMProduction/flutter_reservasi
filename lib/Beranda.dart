import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:reservasi_app/component/commonPadding.dart';
import 'package:reservasi_app/component/genPreferrence.dart';
import 'package:reservasi_app/component/genRadioMini.dart';
import 'package:reservasi_app/component/genShadow.dart';
import 'package:reservasi_app/component/genText.dart';
import 'package:reservasi_app/component/textAndTitle.dart';

import 'blocks/baseBloc.dart';
import 'component/NavDrawer.dart';
import 'component/genColor.dart';
import 'component/request.dart';

class Beranda extends StatefulWidget {
  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> with WidgetsBindingObserver {
  Map dunmmyProfil = {
    "nama": "Colleen Alexander",
    "medal": 0,
    "koin": 0,
    "level": 0,
    "xp": 0,
    "up-level": 1000,
    "foto":
        "https://i1.hdslb.com/bfs/archive/1c619fbdf3fb4a2171598e17b7bee680d5fab2ff.png"
  };

  final req = new GenRequest();

  List listData = [
    {"id": 1, "hari": "senin"},
    {"id": 2, "hari": "selasa"},
    {"id": 3, "hari": "rabu"},
    {"id": 4, "hari": "kamis"},
    {"id": 5, "hari": "jumat"},
    {"id": 6, "hari": "sabtu"},
  ];

  List dummyPromo = [
//    {
//      "image":
//          "https://i2.wp.com/quipperhome.wpcomstaging.com/wp-content/uploads/2018/08/790e6-ini-dia-9-tipe-guru-di-sekolah-yang-akan-kamu-temui.png"
//    },
//    {
//      "image":
//          "https://i2.wp.com/quipperhome.wpcomstaging.com/wp-content/uploads/2018/08/790e6-ini-dia-9-tipe-guru-di-sekolah-yang-akan-kamu-temui.png"
//    },
//    {
//      "image":
//          "https://i2.wp.com/quipperhome.wpcomstaging.com/wp-content/uploads/2018/08/790e6-ini-dia-9-tipe-guru-di-sekolah-yang-akan-kamu-temui.png"
//    },
//    {
//      "image":
//          "https://i2.wp.com/quipperhome.wpcomstaging.com/wp-content/uploads/2018/08/790e6-ini-dia-9-tipe-guru-di-sekolah-yang-akan-kamu-temui.png"
//    },
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
  var stateHari;
  var kelas;
  dynamic dataJadwal;

  @override
  void initState() {
    // TODO: implement initState
    // analytics.
    getKelas();

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

//  FUNCTION

  getKelas() async {
    dataJadwal = await req.getApi("jadwal?id=1");
    kelas = await getPrefferenceKelas();
    setState(() {});
  }

//  getClientId() async {
//    clientId = await getPrefferenceIdClient();
//    if (clientId != null) {
//      print("CLIENT ID" + clientId);
//    }
//  }

  getProfileAbsen() async {
    // await profileBloc.getProfile(reload: true);
  }

  String clienId;

//  getRoom() async {
//    clienId = await getPrefferenceIdClient();
//    return clienId;
//  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

    // notifbloc.dispose();
    // bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: GenColor.primaryColor, // status bar color
    ));

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

    if (!isLoaded) {
      isLoaded = true;
    }

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
              "Kelas " + kelas.toString(),
              style: TextStyle(fontSize: 25),
            )),
            SizedBox(
              height: 20,
            ),
            CommonPadding(child: GenText("Jadwal Mata Kuliah")),
            CommonPadding(
              child: GenRadioGroupMini(
                listData: listData,
                ontap: (val) {
                  setState(() {
                    stateHari = val["id"];
                    getJaddwal(stateHari);
                  });
                },
                id: "id",
                title: "hari",
                initValue: 1,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: dataJadwal == null ? Container() : dataJadwal.length == 0 ? Center(child: GenText("TIdak ada Jadwal Hari ini"),) : SingleChildScrollView(
              child: Column(
                children: dataJadwal.map<Widget>((e) {
                  print(e);
                  return CommonPadding(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: GenShadow()
                              .genShadow(radius: 3.w, offset: Offset(0, 2.w))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GenText(
                            e["matakuliah"].toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                          Divider(),
                          TextRowBetween(
                            leftText: "Jam",
                            rightText: e["jam"].toString(),
                            textright: true,
                          ),
                          TextRowBetween(
                            leftText: "Ruang",
                            rightText: e["get_ruang"]["nama"].toString(),
                            textright: true,
                          ),
                          TextRowBetween(
                            leftText: "Dosen",
                            rightText: e["dosen"].toString(),
                            textright: true,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ).toList()
            )))
          ],
        ),
      ),
    );
  }

  void getJaddwal(id) async {
    dataJadwal = await req.getApi("jadwal?id=" + id.toString());

    print("DATA $dataJadwal");
    print("length" +dataJadwal.length.toString());

    setState(() {});
  }
}
