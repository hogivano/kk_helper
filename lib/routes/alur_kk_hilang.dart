import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:kk_helper/model/users.dart';
import 'package:kk_helper/local_disk.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kk_helper/widget/Ddrawer.dart';

class AlurKKHilang extends StatefulWidget {
  final FirebaseUser firebaseUser;
  const AlurKKHilang({Key key, @required this.firebaseUser})
      : assert(firebaseUser != null),
        super(key: key);
  @override
  State<StatefulWidget> createState() => _AlurKKHilangState();
}

class _AlurKKHilangState extends State<AlurKKHilang> {
  final GlobalKey<ScaffoldState> _scaffoldStateKey =
  new GlobalKey<ScaffoldState>();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  Users user = new Users();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    new Connectivity().onConnectivityChanged.listen((result){
//      Fluttertoast.showToast(msg: result.toString());
//    });
    new LocalDisk().getString("user").then((str) {
      if (str == null) {
        _database
            .reference()
            .child("user")
            .once()
            .then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> values = snapshot.value;
          if (values != null) {
            values.forEach((key, value) {
              if (value["noTelp"] == widget.firebaseUser.phoneNumber) {
                user.setKey = key;
                user.setNama = value["nama"];
                user.setNoTelp = value["noTelp"];
                user.setImage = value["image"];
                user.setRole = value["role"];

                new LocalDisk()
                    .setString("user", jsonEncode(user.toJsonWithKey()));
              } else if (value["email"] == widget.firebaseUser.email) {
                user.setKey = key;
                user.setNama = value["nama"];
                user.setEmail = value["email"];
                user.setImage = value["image"];
                user.setRole = value["role"];

                new LocalDisk()
                    .setString("user", jsonEncode(user.toJsonWithKey()));

                Fluttertoast.showToast(msg: "masukk di email");
              }
            });
          }
        });
      } else {
        Map userMap = jsonDecode(str);
        this.user = new Users.fromJsonWithKey(userMap);
        print("user key " + this.user.Key);
      }
    }, onError: () {
      Fluttertoast.showToast(msg: "error pengambilan local disk");
    });
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
                  Icons.arrow_back,
                  size: 30.0,
                  color: Colors.white70,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                }),
            title: new Align(
              alignment: Alignment(-0.15, 0),
              child: new Text(
                "Alur KK Hilang/Rusak",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
          drawer: this.user.noTelp != "" || this.user.email != ""
              ? new Ddrawer(firebaseUser: widget.firebaseUser)
              : new Ddrawer(firebaseUser: widget.firebaseUser),
          body: new SafeArea(
            child: new SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: new Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Container(
                    child: new Text(
                      "Persyaratan Berkas",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    decoration: new BoxDecoration(
                        color: Color(0xff20b7f7),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          new BoxShadow(
                              color: Colors.black38,
                              blurRadius: 2.0,
                              offset: Offset(0, 0.1))
                        ]),
                    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    margin: const EdgeInsets.all(20.0),
                    alignment: Alignment(-1, 0),
                  ),
                  new Container(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Flexible(
                          fit: FlexFit.loose,
                          child:  new Container(
                            child: new CircleAvatar(
                              child: new Text(
                                "1",
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            width: 40.0,
                            height: 40.0,
                            padding: const EdgeInsets.all(1.0),
                            decoration: new BoxDecoration(
                              color: Color(0xff639fff),
                              shape: BoxShape.circle,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        ),
                        new Flexible(
                          fit: FlexFit.loose,
                          child: new Container(
                            child: new Text("KK Baru"),
                          ),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Flexible(
                          fit: FlexFit.loose,
                          child:  new Container(
                            child: new CircleAvatar(
                              child: new Text(
                                "2",
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            width: 40.0,
                            height: 40.0,
                            padding: const EdgeInsets.all(1.0),
                            decoration: new BoxDecoration(
                              color: Color(0xff639fff),
                              shape: BoxShape.circle,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        ),
                        new Flexible(
                          fit: FlexFit.loose,
                          child: new Container(
                            child: new Text("Surat Pengantar RT/RW"),
                          ),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Flexible(
                          fit: FlexFit.loose,
                          child:  new Container(
                            child: new CircleAvatar(
                              child: new Text(
                                "3",
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            width: 40.0,
                            height: 40.0,
                            padding: const EdgeInsets.all(1.0),
                            decoration: new BoxDecoration(
                              color: Color(0xff639fff),
                              shape: BoxShape.circle,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        ),
                        new Flexible(
                          fit: FlexFit.loose,
                          child: new Container(
                            child: new Text("Surat Pengantar RT/RW"),
                          ),
                        )
                      ],
                    ),
                  ),
                  //Alur Proses
                  new Container(
                    child: new Text(
                      "Alur Proses",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    decoration: new BoxDecoration(
                        color: Color(0xff20b7f7),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          new BoxShadow(
                              color: Colors.black38,
                              blurRadius: 2.0,
                              offset: Offset(0, 0.1))
                        ]),
                    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    margin: const EdgeInsets.all(20.0),
                    alignment: Alignment(-1, 0),
                  ),
                  new Container(
                    padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Flexible(
                          fit: FlexFit.loose,
                          child:  new Container(
                            child: new CircleAvatar(
                              child: new Text(
                                "1",
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            width: 40.0,
                            height: 40.0,
                            padding: const EdgeInsets.all(1.0),
                            decoration: new BoxDecoration(
                              color: Color(0xff639fff),
                              shape: BoxShape.circle,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        ),
                        new Container(
                          width: MediaQuery.of(context).size.width*0.7,
                          child: new Text("Surat Pengantar RT/RW ajsabs ajs ajs abcd kaja ka kja skajs a ajks a jK"
                              + "j AKJa as ka ajs a aks as kja sjka  ka sa"),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Container(
                          width: MediaQuery.of(context).size.width*0.7,
                          child: new Text("Surat Pengantar RT/RW ajsabs ajs ajs abcd kaja ka kja skajs a ajks a jK"
                              + "j AKJa as ka ajs a aks as kja sjka  ka sa",
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        new Flexible(
                          child: new Container(
                            child: new CircleAvatar(
                              child: new Text(
                                "2",
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            width: 40.0,
                            height: 40.0,
                            padding: const EdgeInsets.all(1.0),
                            decoration: new BoxDecoration(
                              color: Color(0xff639fff),
                              shape: BoxShape.circle,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Flexible(
                          fit: FlexFit.loose,
                          child:  new Container(
                            child: new CircleAvatar(
                              child: new Text(
                                "3",
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            width: 40.0,
                            height: 40.0,
                            padding: const EdgeInsets.all(1.0),
                            decoration: new BoxDecoration(
                              color: Color(0xff639fff),
                              shape: BoxShape.circle,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        ),
                        new Container(
                          width: MediaQuery.of(context).size.width*0.7,
                          child: new Text("Surat Pengantar RT/RW ajsabs ajs ajs abcd kaja ka kja skajs a ajks a jK"
                              + "j AKJa as ka ajs a aks as kja sjka  ka sa"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
