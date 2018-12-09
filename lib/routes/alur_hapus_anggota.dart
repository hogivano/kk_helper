import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:kk_helper/model/users.dart';
import 'package:kk_helper/local_disk.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AlurHapusAnggota extends StatefulWidget {
  final FirebaseUser firebaseUser;
  const AlurHapusAnggota({Key key, @required this.firebaseUser})
      : assert(firebaseUser != null),
        super(key: key);
  @override
  State<StatefulWidget> createState() => _AlurHapusAnggotaState();
}

class _AlurHapusAnggotaState extends State<AlurHapusAnggota> {
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
                "Alur Kurang Anggota",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
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
                        new Container(
                          width: MediaQuery.of(context).size.width*0.7,
                          child: new Text("Kartu Keluarga yang hendak dikurangi anggota keluarganya",
                            textAlign: TextAlign.justify,
                          ),
                        ),
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
                        new Container(
                          width: MediaQuery.of(context).size.width*0.7,
                          child: new Text("Surat Pengantar Perubahan KK dari RT/RW dan sudah distempel",
                            textAlign: TextAlign.justify,
                          ),
                        ),
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
                        new Container(
                          width: MediaQuery.of(context).size.width*0.7,
                          child: new Text("Surat Keterangan Kematian (jika anggota keluarga meninggal)",
                            textAlign: TextAlign.justify,
                          ),
                        ),
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
                                "4",
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
                          child: new Text("Surat Keterangan Pindah (jika anggota keluarga pindah KK dan masih dalam wilayah NKRI)",
                            textAlign: TextAlign.justify,
                          ),
                        ),
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
                          child: new Text("Meminta surat pengantar perubahan kk ke RT & RW (telah distempel oleh RW)",
                            textAlign: TextAlign.justify,
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
                        new Container(
                          width: MediaQuery.of(context).size.width*0.7,
                          child: new Text("Menyiapkan semua persyaratan berkas dan dijadikan dalam bentuk gambar (jpg/png)",
                            textAlign: TextAlign.justify,
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
                          child: new Text("Klik menu kurang anggota pada navigasi aplikasi sebelah kiri untuk permohonan "
                              + "pengurangan anggota",
                            textAlign: TextAlign.justify,
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
                                "4",
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
                          child: new Text("Mengisi data kk ditempat yang telah disediakan dengan baik dan benar",
                            textAlign: TextAlign.justify,
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
                                "5",
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
                          child: new Text("Mengisi biodata seluruh anggota yang ada di KK ditempat "
                              + "yang telah disediakan dengan baik dan benar",
                            textAlign: TextAlign.justify,
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
                                "6",
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
                          child: new Text("Mengisi biodata anggota yang hendak dikurangi serta alasan pengurangan ditempat "
                              + "yang telah disediakan dengan baik dan benar",
                            textAlign: TextAlign.justify,
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
                                "7",
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
                          child: new Text("Upload seluruh berkas ke tempat yang telah disediakan",
                            textAlign: TextAlign.justify,
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
                                "8",
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
                          child: new Text("Seluruh isian yang telah dikirim tidak bisa dirubah hanya bisa dibatalkan saja",
                            textAlign: TextAlign.justify,
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
                                "9",
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
                          child: new Text("Tunggu selama maksimal 7 hari untuk diacc oleh kelurahan dan kecamatan dan akan "
                              + "mendapatkan notifikasi di aplikasi bahwa kk sudah jadi",
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(bottom: 15.0),
                    padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Flexible(
                          fit: FlexFit.loose,
                          child:  new Container(
                            child: new CircleAvatar(
                              child: new Text(
                                "10",
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
                          child: new Text("Setelah mendapatkan pesan disetujui silahkan datang ke kantor kecamatan yang dituju dengan membawa seluruh persyaratan "
                              + " berkas untuk mengambil Kartu Keluarga Baru",
                            textAlign: TextAlign.justify,
                          ),
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
