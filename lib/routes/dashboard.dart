import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kk_helper/logger.dart';
import 'package:kk_helper/model/users.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:kk_helper/routes/login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:kk_helper/widget/Ddrawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kk_helper/local_disk.dart';
import 'package:kk_helper/routes/alur_kk_baru.dart';
import 'package:kk_helper/routes/alur_kk_hilang.dart';
import 'package:kk_helper/routes/alur_hapus_anggota.dart';
import 'package:kk_helper/routes/alur_tambah_anggota.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Dashboard extends StatefulWidget{
  final FirebaseUser firebaseUser;
  const Dashboard({Key key, @required this.firebaseUser})
    :assert(firebaseUser != null),
    super(key : key);
  @override
  State<StatefulWidget> createState() => _dashboardState();
}

class _dashboardState extends State<Dashboard>{
  final GlobalKey<ScaffoldState> _scaffoldStateKey = new GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Users user = new Users();

  static final Options options = new Options(
      baseUrl: "http://dispendukcapil.surabaya.go.id/ceknik_sby",
      connectTimeout: 5000,
      receiveTimeout: 3000,
      contentType: ContentType.parse("application/x-www-form-urlencoded"),
  );

  Dio _dio = new Dio(options);

  FormData formData = new FormData.from({
    "qcari" : "3578050612980002",
    "qcari1" : "120",
    "qcaptcha" : "120",
  });

  Future<Response> cekNik() async{
    Response<String> response = await _dio.post("/pak_kurus", data: formData);
    return response;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    new Connectivity().onConnectivityChanged.listen((result){
//      Fluttertoast.showToast(msg: result.toString());
//    });
    new LocalDisk().getString("user").then((str){
      if (str == null){
        _database.reference().child("user").once().then((DataSnapshot snapshot){
          Map<dynamic, dynamic> values = snapshot.value;
          if (values != null) {
            values.forEach((key, value) {
              if (value["noTelp"] == widget.firebaseUser.phoneNumber) {
                user.setKey = key;
                user.setNama = value["nama"];
                user.setNoTelp = value["noTelp"];
                user.setImage = value["image"];
                user.setRole = value["role"];

                new LocalDisk().setString("user", jsonEncode(user.toJsonWithKey()));
              } else if (value["email"] == widget.firebaseUser.email){
                user.setKey = key;
                user.setNama = value["nama"];
                user.setEmail = value["email"];
                user.setImage = value["image"];
                user.setRole = value["role"];

                new LocalDisk().setString("user", jsonEncode(user.toJsonWithKey()));
              }
            });
          }
        });
      } else {
        Map userMap = jsonDecode(str);
        this.user = new Users.fromJsonWithKey(userMap);
        print("user key " + this.user.Key);
      }
    }, onError: (){
      Fluttertoast.showToast(msg: "error pengambilan local disk");
    });

    var initializationSettingAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingIOS = new IOSInitializationSettings();

    var initializationSetting = new InitializationSettings(initializationSettingAndroid, initializationSettingIOS);

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  }


  Future _showNotificationWithDefaultSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'KK Hilang',
      'Pengajuan KK Hilang telah di acc kelurahan',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Material(
      child: new Scaffold(
        key: _scaffoldStateKey,
        appBar: new GradientAppBar(
          elevation: 4.0,
          backgroundColorStart: Color(0xFF35ade0),
          backgroundColorEnd: Color(0xff20b7f7),
          leading: new IconButton(
              icon: new Icon(
                Icons.menu,
                size: 30.0,
                color: Colors.white70,
              ) ,
              onPressed: (){
                _scaffoldStateKey.currentState.openDrawer();
              }
          ),
          title: new Align(
            alignment: Alignment(-0.15, 0),
            child: new Text (
              "KK Helper Surabaya",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
                color: Colors.white70,
              ),
            ),
          ),
        ),
        drawer: this.user.noTelp != "" || this.user.email != "" ? new Ddrawer(firebaseUser: widget.firebaseUser)
                : new Ddrawer(firebaseUser: widget.firebaseUser),
        body: new SafeArea(
          child: new SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: new Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Container(
                  child: new Text(
                      "''KK Helper membantu warga kota surabaya dalam mengurus surat kependudukan (Khusus WNI)''",
                    style: new TextStyle(
                      color: Colors.black87,
                      fontSize: 15.0,
                      fontFamily: 'OpenSansCondensed'
                    ),
                    textAlign: TextAlign.center,
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20.0),
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 4.2,
                  margin: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                  child: new RaisedButton(
                      elevation: 2.0,
                      onPressed: (){
                        Navigator.of(context).push(new PageRouteBuilder(
                            opaque: true,
                            transitionDuration: const Duration(milliseconds: 500),
                            pageBuilder: (BuildContext context, _, __) {
                              return new AlurKKBaru(firebaseUser: widget.firebaseUser);
                            },
                            transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                              return new SlideTransition(
                                child: child,
                                position: new Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                              );
                            }
                        ));
                      },
                      splashColor: Colors.black54,
                      padding: new EdgeInsets.all(0.0),
                      child: new Stack(
                        children: <Widget>[
                          new Container (
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 4.2,
                            child: new Text(""),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                colors: [const Color(0xb32870d6), const Color(0xb3288ad6), const Color(0xb328d6c4)], // whitish to gray
                              ),
                            ),
                          ), new Container(
                            child: new Image.asset
                              ("assets/image/addDoc.png",
                              height: MediaQuery.of(context).size.height / 5.6,
                            ),
                            alignment: Alignment(-0.8, 0),
                            color: Colors.black12,
                          ), new Container(
                            child: new Text(
                                "ALUR PEMBUATAN\nKK BARU",
                              style: new TextStyle(
                                color: Colors.white70,
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0
                              ),
                            ),
                            alignment: Alignment(0.5, 0),
                            color: Colors.black12,
                          ), new Container(
                            child: new Icon(
                                Icons.arrow_forward,
                              size: 25.0,
                              color: Colors.white,
                            ), alignment: Alignment(0.92, 0.9),
                          )
                        ],
                      )
                  ),
                ), new Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 4.2,
                  margin: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                  child: new RaisedButton(
                      elevation: 2.0,
                      onPressed: () {
                        Navigator.of(context).push(new PageRouteBuilder(
                            opaque: true,
                            transitionDuration: const Duration(milliseconds: 500),
                            pageBuilder: (BuildContext context, _, __) {
                              return new AlurTambahAnggota(firebaseUser: widget.firebaseUser);
                            },
                            transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                              return new SlideTransition(
                                child: child,
                                position: new Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                              );
                            }
                        ));
                      },
                      splashColor: Colors.black54,
                      padding: new EdgeInsets.all(0.0),
                      child: new Stack(
                        children: <Widget>[
                          new Container (
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 4.2,
                            child: new Text(""),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                colors: [const Color(0xb37554d8), const Color(0xb3b253d8), const Color(0xb3d553d8)], // whitish to gray
                              ),
                            ),
                          ), new Container(
                            child: new Image.asset
                              ("assets/image/person.png",
                              height: MediaQuery.of(context).size.height / 5.6,
                            ),
                            alignment: Alignment(-0.8, 0),
                            color: Colors.black12,
                          ), new Container(
                            child: new Text(
                              "ALUR TAMBAH\nANGGOTA KELUARGA",
                              style: new TextStyle(
                                  color: Colors.white70,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0
                              ),
                            ),
                            alignment: Alignment(0.7, 0),
                            color: Colors.black12,
                          ), new Container(
                            child: new Icon(
                              Icons.arrow_forward,
                              size: 25.0,
                              color: Colors.white,
                            ), alignment: Alignment(0.92, 0.9),
                          )
                        ],
                      )
                  ),
                ), new Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 4.2,
                  margin: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                  child: new RaisedButton(
                      elevation: 2.0,
                      onPressed: (){
                        Navigator.of(context).push(new PageRouteBuilder(
                            opaque: true,
                            transitionDuration: const Duration(milliseconds: 500),
                            pageBuilder: (BuildContext context, _, __) {
                              return new AlurHapusAnggota(firebaseUser: widget.firebaseUser);
                            },
                            transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                              return new SlideTransition(
                                child: child,
                                position: new Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                              );
                            }
                        ));
                      },
                      splashColor: Colors.black54,
                      padding: new EdgeInsets.all(0.0),
                      child: new Stack(
                        children: <Widget>[
                          new Container (
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 4.2,
                            child: new Text(""),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                colors: [const Color(0xb3d16f29), const Color(0xb3d15029), const Color(0xb3d81e1e)], // whitish to gray
                              ),
                            ),
                          ), new Container(
                            child: new Image.asset
                              ("assets/image/person.png",
                              height: MediaQuery.of(context).size.height / 5.6,
                            ),
                            alignment: Alignment(-0.8, 0),
                            color: Colors.black12,
                          ), new Container(
                            child: new Text(
                              "ALUR KURANG\nANGGOTA KELUARGA",
                              style: new TextStyle(
                                  color: Colors.white70,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0
                              ),
                            ),
                            alignment: Alignment(0.7, 0),
                            color: Colors.black12,
                          ), new Container(
                            child: new Icon(
                              Icons.arrow_forward,
                              size: 25.0,
                              color: Colors.white,
                            ), alignment: Alignment(0.92, 0.9),
                          )
                        ],
                      )
                  ),
                ), new Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 4.2,
                  margin: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                  child: new RaisedButton(
                      elevation: 2.0,
                      onPressed: (){
                        Navigator.of(context).push(new PageRouteBuilder(
                            opaque: true,
                            transitionDuration: const Duration(milliseconds: 500),
                            pageBuilder: (BuildContext context, _, __) {
                              return new AlurKKHilang(firebaseUser: widget.firebaseUser);
                            },
                            transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                              return new SlideTransition(
                                child: child,
                                position: new Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                              );
                            }
                        ));
                      },
                      splashColor: Colors.black54,
                      padding: new EdgeInsets.all(0.0),
                      child: new Stack(
                        children: <Widget>[
                          new Container (
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 4.2,
                            child: new Text(""),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                colors: [const Color(0xb307962b), const Color(0xb305b26a), const Color(0xb31ab2af)], // whitish to gray
                              ),
                            ),
                          ), new Container(
                            child: new Image.asset
                              ("assets/image/edit.png",
                              height: MediaQuery.of(context).size.height / 5.6,
                            ),
                            alignment: Alignment(-0.8, 0),
                            color: Colors.black12,
                          ), new Container(
                            child: new Text(
                              "ALUR PENGAJUAN\nKK HILANG/RUSAK",
                              style: new TextStyle(
                                  color: Colors.white70,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0
                              ),
                            ),
                            alignment: Alignment(0.5, 0),
                            color: Colors.black12,
                          ), new Container(
                            child: new Icon(
                              Icons.arrow_forward,
                              size: 25.0,
                              color: Colors.white,
                            ), alignment: Alignment(0.92, 0.9),
                          )
                        ],
                      )
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _drawer(BuildContext context) {
    return new SafeArea(
        child: new Drawer(
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text(
                    widget.firebaseUser.displayName.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 20.0
                    ),
                ),
                accountEmail: new Text(
                  "Hogiavno@gmail.com"
                ),
                decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          const Color(0xff55b9fc),
                          const Color(0xff2999e5),
                          const Color(0xff4b72f2),
                        ]
                    ),
                ),
                onDetailsPressed: (){},
              ),
              new Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new ListTile(
                    leading: new Icon(Icons.add),
                    title: new Text("Nambah KK"),
                    onTap: (){
                      return null;
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.add),
                    title: new Text("Nambah KK"),
                    onTap: (){
                      return null;
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.add),
                    title: new Text("Nambah KK"),
                    onTap: (){
                      return null;
                    },
                  )
                ],
              ),
              new Stack(
                children: <Widget>[
                  new Align(
                    alignment: Alignment(0.0, -1.0),
                    child: new RaisedButton(
                      onPressed: _logout,
                      child: new Text("keluar"),
                      elevation: 4.0,
                    ),
                  )
                ],
              ),
            ],
          ),
        )
    );
  }
  Future<void> _logout() async{
    await _auth.signOut().whenComplete((){
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (context) => Login(),
      ));
    });
  }
}