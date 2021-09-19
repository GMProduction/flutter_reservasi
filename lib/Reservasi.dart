import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:reservasi_app/CariRuangan.dart';
import 'package:reservasi_app/component/JustHelper.dart';
import 'package:reservasi_app/component/commonPadding.dart';
import 'package:reservasi_app/component/genButton.dart';
import 'package:reservasi_app/component/genRadioMini.dart';
import 'package:reservasi_app/component/genShadow.dart';
import 'package:reservasi_app/component/genText.dart';
import 'package:reservasi_app/component/textAndTitle.dart';

import 'blocks/baseBloc.dart';
import 'component/NavDrawer.dart';
import 'component/genColor.dart';
import 'component/request.dart';

class Reservasi extends StatefulWidget {


  @override
  _ReservasiState createState() => _ReservasiState();
}

class _ReservasiState extends State<Reservasi> with WidgetsBindingObserver {

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
  var startTime = TimeOfDay.fromDateTime(DateTime.now());
  var endTime = TimeOfDay.fromDateTime(DateTime.now());
  var selectedDate = DateTime.now();
  String _hour, _minute, _time;
  TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    // analytics.

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

//  FUNCTION

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
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (picked != null)
      setState(() {
        startTime = picked;
        _hour = startTime.hour.toString();
        _minute = startTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
      });
  }

  Future<Null> _selectTime2(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: endTime,
    );
    if (picked != null)
      setState(() {
        endTime = picked;
        _hour = endTime.hour.toString();
        _minute = endTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
      });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: GenColor.primaryColor, // status bar color
    ));
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery
                .of(context)
                .size
                .width,
            maxHeight: MediaQuery
                .of(context)
                .size
                .height),
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
                  "Pilih Tanggal",
                  style: TextStyle(fontSize: 25),
                )),
            SizedBox(
              height: 20,
            ),
            CommonPadding(
                child: InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: EdgeInsets.all(16), decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: GenShadow().genShadow(),
                      color: Colors.white
                  ),
                    child: GenText(formatTanggal(selectedDate).toString() ??
                        "Pilih Tanggal"),),
                )
            ),
            SizedBox(
              height: 50,
            ),
            CommonPadding(
                child: GenText(
                  "Pilih jam",
                  style: TextStyle(fontSize: 25),
                )),
            SizedBox(
              height: 20,
            ),
            CommonPadding(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => _selectTime(context),
                      child: Container(
                        padding: EdgeInsets.all(16), decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: GenShadow().genShadow(),
                          color: Colors.white
                      ),
                        child: GenText(startTime.hour.toString() + " : " +
                            startTime.minute.toString()),),
                    ),
                    SizedBox(width: 20,),
                    GenText("-"),
                    SizedBox(width: 20,),
                    InkWell(
                      onTap: () => _selectTime2(context),
                      child: Container(
                        padding: EdgeInsets.all(16), decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: GenShadow().genShadow(),
                          color: Colors.white
                      ),
                        child: GenText(endTime.hour.toString() + " : " +
                            endTime.minute.toString()),),
                    ),
                  ],
                )
            ),
            SizedBox(height: 50,),
            CommonPadding(child: GenButton(text: "Cari Ruangan", ontap: () {
              Navigator.pushNamed(
                  context, 'cariruangan', arguments: CariRuangan(
                tanggal: selectedDate.toString().substring(0,10),
                mulai: startTime.toString().substring(10,15),
                selesai: endTime.toString().substring(10,15)

              ));
            },))
          ],
        ),
      ),
    );
  }
}

