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
import 'component/JustHelper.dart';
import 'component/NavDrawer.dart';
import 'component/genColor.dart';
import 'component/request.dart';

class InfoRuangan extends StatefulWidget {
  @override
  _InfoRuanganState createState() => _InfoRuanganState();
}

class _InfoRuanganState extends State<InfoRuangan> with WidgetsBindingObserver {

  final req = new GenRequest();


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
  dynamic dataHistory;

  @override
  void initState() {
    // TODO: implement initState
    // analytics.
    getJaddwal();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

//  FUNCTION

  getFasilitas() async {
    dataHistory = await req.getApi("ruang");
    setState(() {});
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
            SizedBox(height: 50,),
            CommonPadding(
                child: GenText(
                  "Ruangan Yang Kamu Pesan",
                  style: TextStyle(fontSize: 25),
                )),SizedBox(height: 20,),
            Expanded(
              child: dataHistory == null ? Container() : dataHistory.length == 0 ? Center(child: GenText("TIdak ada Ruangan Tersedia"),) : SingleChildScrollView(
                  child: Column(
                      children: dataHistory.map<Widget>((e) {
                        return CommonPadding(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: GenShadow()
                                    .genShadow(
                                    radius: 3.w, offset: Offset(0, 2.w))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GenText(
                                  e["get_ruang"]["nama"].toString(), style: TextStyle(fontSize: 20),),
                                Divider(),
                                GenText("Fasilitas: " +e["get_ruang"]["fasilitas"].toString(),
                                  style: TextStyle(fontSize: 15),),
                                GenText(
                                  "Lantai: " + e["get_ruang"]["lantai"].toString() , style: TextStyle(fontSize: 15),),
                                GenText(
                                  "Tanggal: " + formatTanggalFromString(e["tanggal"]) , style: TextStyle(fontSize: 15),),
                                GenText(
                                  "Jam: " + e["jam"].toString() + " - " + e["selesai"].toString() , style: TextStyle(fontSize: 15),),
                                GenText(
                                  "Keperluan: " + e["keterangan"].toString() , style: TextStyle(fontSize: 15),),
                              ],
                            ),
                          ),
                        );

                      },
                      ).toList())
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getJaddwal() async {
    dataHistory = await req.getApi("reservation");

    print(dataHistory);
    setState(() {});
  }
}
