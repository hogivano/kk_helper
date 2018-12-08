import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:kk_helper/routes/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:onesignal/onesignal.dart';


FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async{
  var initializationSettingsAndroid =
  new AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  _knowChange();
  runApp(MyApp());
}

_knowChange() async{
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  _database.reference().child("hilang_kk").onChildChanged.listen((event){
    var now = new DateTime.now();
    bool accKecamatan = false;
    bool accKelurahan = false;
    String reject = "";
    var arrDate = [];
    var arrTime = [];
    Map<dynamic, dynamic> values = event.snapshot.value;
    values.forEach((key, value){
      if (key == "date"){
        String date = value;
        var arr = date.split(" ");
        arrDate = arr[0].split("-");
        arrTime = arr[1].split(":");
      } else if (key == "accKecamatan"){
        accKecamatan = value;
      } else if (key == "accKelurahan"){
        accKelurahan = value;
      } else if (key == "reject"){
        reject = value;
      }
    });

    if (int.parse(arrDate[0]) == now.year && int.parse(arrDate[1]) == now.month && int.parse(arrDate[2]) == now.day){
      if (int.parse(arrTime[0]) == now.hour){
        if (now.minute-int.parse(arrTime[1]) <= 2){
          if (accKecamatan && accKelurahan){
            _showNotificationWithDefaultSound("Tambah KK", "KK kamu telah jadi");
          } else if (reject == "kelurahan"){
            _showNotificationWithDefaultSound("Tambah KK", "Penolakan pengajuan dari kelurahan");
          } else if (reject == "kecamatan"){
            _showNotificationWithDefaultSound("Tambah KK", "Penolakan pengajuan dari kecamatan");
          } else if (accKelurahan){
            _showNotificationWithDefaultSound("Tambah KK", "KK kamu telah di acc dari kelurahan");
          }
        }
      }
    }
  });

  _database.reference().child("tambah_kk").onChildChanged.listen((event){
    var now = new DateTime.now();
    bool accKecamatan = false;
    bool accKelurahan = false;
    String reject = "";
    var arrDate = [];
    var arrTime = [];
    Map<dynamic, dynamic> values = event.snapshot.value;
    values.forEach((key, value){
      if (key == "date"){
        String date = value;
        var arr = date.split(" ");
        arrDate = arr[0].split("-");
        arrTime = arr[1].split(":");
      } else if (key == "accKecamatan"){
        accKecamatan = value;
      } else if (key == "accKelurahan"){
        accKelurahan = value;
      } else if (key == "reject"){
        reject = value;
      }
    });

    if (int.parse(arrDate[0]) == now.year && int.parse(arrDate[1]) == now.month && int.parse(arrDate[2]) == now.day){
      if (int.parse(arrTime[0]) == now.hour){
        if (now.minute-int.parse(arrTime[1]) <= 2){
          if (accKecamatan && accKelurahan){
            _showNotificationWithDefaultSound("KK Hilang/Rusak", "KK kamu telah jadi");
          } else if (reject == "kelurahan"){
            _showNotificationWithDefaultSound("KK Hilang/Rusak", "Penolakan pengajuan dari kelurahan");
          } else if (reject == "kecamatan"){
            _showNotificationWithDefaultSound("KK Hilang/Rusak", "Penolakan pengajuan dari kecamatan");
          } else if (accKelurahan){
            _showNotificationWithDefaultSound("KK Hilang/Rusak", "KK kamu telah di acc dari kelurahan");
          }
        }
      }
    }
  });

  _database.reference().child("kurang_anggota").onChildChanged.listen((event){
    var now = new DateTime.now();
    bool accKecamatan = false;
    bool accKelurahan = false;
    String reject = "";
    var arrDate = [];
    var arrTime = [];
    Map<dynamic, dynamic> values = event.snapshot.value;
    values.forEach((key, value){
      if (key == "date"){
        String date = value;
        var arr = date.split(" ");
        arrDate = arr[0].split("-");
        arrTime = arr[1].split(":");
      } else if (key == "accKecamatan"){
        accKecamatan = value;
      } else if (key == "accKelurahan"){
        accKelurahan = value;
      } else if (key == "reject"){
        reject = value;
      }
    });

    if (int.parse(arrDate[0]) == now.year && int.parse(arrDate[1]) == now.month && int.parse(arrDate[2]) == now.day){
      if (int.parse(arrTime[0]) == now.hour){
        if (now.minute-int.parse(arrTime[1]) <= 2){
          if (accKecamatan && accKelurahan){
            _showNotificationWithDefaultSound("Pengurangan Anggota", "KK kamu telah jadi");
          } else if (reject == "kelurahan"){
            _showNotificationWithDefaultSound("Pengurangan Anggota", "Penolakan pengajuan dari kelurahan");
          } else if (reject == "kecamatan"){
            _showNotificationWithDefaultSound("Pengurangan Anggota", "Penolakan pengajuan dari kecamatan");
          } else if (accKelurahan){
            _showNotificationWithDefaultSound("Pengurangan Anggota", "KK kamu telah di acc dari kelurahan");
          }
        }
      }
    }
  });

  _database.reference().child("tambah_anggota").onChildChanged.listen((event){
    var now = new DateTime.now();
    bool accKecamatan = false;
    bool accKelurahan = false;
    String reject = "";
    var arrDate = [];
    var arrTime = [];
    Map<dynamic, dynamic> values = event.snapshot.value;
    values.forEach((key, value){
      if (key == "date"){
        String date = value;
        var arr = date.split(" ");
        arrDate = arr[0].split("-");
        arrTime = arr[1].split(":");
      } else if (key == "accKecamatan"){
        accKecamatan = value;
      } else if (key == "accKelurahan"){
        accKelurahan = value;
      } else if (key == "reject"){
        reject = value;
      }
    });

    if (int.parse(arrDate[0]) == now.year && int.parse(arrDate[1]) == now.month && int.parse(arrDate[2]) == now.day){
      if (int.parse(arrTime[0]) == now.hour){
        if (now.minute-int.parse(arrTime[1]) <= 2){
          if (accKecamatan && accKelurahan){
            _showNotificationWithDefaultSound("Pertambahan Anggota", "KK kamu telah jadi");
          } else if (reject == "kelurahan"){
            _showNotificationWithDefaultSound("Pertambahan Anggota", "Penolakan pengajuan dari kelurahan");
          } else if (reject == "kecamatan"){
            _showNotificationWithDefaultSound("Pertambahan Anggota", "Penolakan pengajuan dari kecamatan");
          } else if (accKelurahan){
            _showNotificationWithDefaultSound("Pertambahan Anggota", "KK kamu telah di acc dari kelurahan");
          }
        }
      }
    }
  });
}

Future _showNotificationWithDefaultSound(String header, String body) async {

  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'kel1.mobtek.kkhelper', 'KK Helper', 'pembuatan kk di surabaya',
      importance: Importance.Max, priority: Priority.High);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    header,
    body,
    platformChannelSpecifics,
  );

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KK Helper',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.lightBlue,
      ),
      home: SplashScreen(),
    );
  }
}
