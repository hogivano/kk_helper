import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:kk_helper/widget/Ddrawer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kk_helper/local_disk.dart';
import 'package:kk_helper/model/users.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:kk_helper/model/data_tambah_kk.dart';
import 'package:kk_helper/model/data_keluarga.dart';
import 'package:flutter/services.dart';
import 'package:kk_helper/model/data_hilang_kk.dart';

class Track extends StatefulWidget {
  final FirebaseUser firebaseUser;
  const Track({Key key, @required this.firebaseUser})
      :assert(firebaseUser != null),
        super(key : key);

  @override
  State<StatefulWidget> createState() => _trackState();
}

class _trackState extends State<Track>{
  final GlobalKey<ScaffoldState> _scaffoldStateKey = new GlobalKey<ScaffoldState>();
  Users user = new Users();
  List<DataTambahKK> listTambahKK = [];
  List<DataHilangKK> listHilangKK = [];

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  bool load = false;

  _getFirebaseBaruKK() async{
    await _database.reference().once().then((DataSnapshot datasnapshot){
      Map<dynamic, dynamic> values = datasnapshot.value;
      values.forEach((key, value){
        if (key == "tambah_kk"){
          Map<dynamic, dynamic> tambahKK = value;
          tambahKK.forEach((keyTambah, valueTambah){
            print("keyTambah " + keyTambah + " user " + valueTambah["idUser"]);
          });
          print("key ini " + key);
        }
      });
    });
  }

  _dialogConfirm(String key){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(
            'Apa anda yakin menghapusnya?',
          style: new TextStyle(
            color: Colors.black87,
          ),
        ),
        content: new Text(
            'semua data yang diproses akan dibatalkan',
          style: new TextStyle(
            color: Colors.black54,
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              'Tidak',
              style: TextStyle(
                  color: Color(0xff6ba3ff)
              ),
            ),
          ),
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              _deleteTap(key);
            },
            child: new Text(
              'Ya',
              style: TextStyle(
                  color: Color(0xff6ba3ff)
              ),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  _infoTap (String ind){
    print(ind);
//    Fluttertoast.showToast(msg: "index info : " + index.toString());
  }

  _deleteTap(String key) async{
    DataTambahKK del = _searchByKey(key);
    Fluttertoast.showToast(msg: del.kepalaKeluarga);
    setState(() {
      load = true;
    });
    if (del.ketDomisili != ""){
      String ketDomisili = _replaceLinkFirebaseStorage(del.ketDomisili);
      int tanya = ketDomisili.indexOf("?");
      ketDomisili = ketDomisili.substring(0, tanya);

      _delImage(ketDomisili);
    }

    for(int i = 0; i < del.pekerjaan.length; i++){
      String ket = _replaceLinkFirebaseStorage(del.pekerjaan[i]);
      int index = ket.indexOf("?");
      ket = ket.substring(0, index);

      await _delImage(ket);
    }

    for(int i = 0; i < del.aktaKawin.length; i++){
      String ket = _replaceLinkFirebaseStorage(del.aktaKawin[i]);
      int index = ket.indexOf("?");
      ket = ket.substring(0, index);

      await _delImage(ket);
    }

    for(int i = 0; i < del.pindahDaatng.length; i++){
      String ket = _replaceLinkFirebaseStorage(del.pindahDaatng[i]);
      int index = ket.indexOf("?");
      ket = ket.substring(0, index);

      await _delImage(ket);
    }

    await _database.reference().child("tambah_kk").child(key).remove().whenComplete((){
      Fluttertoast.showToast(msg: "berhasil menghapus");
      setState(() {
        load = false;
      });
    }).catchError((err){
      setState(() {
        load = false;
      });
      Fluttertoast.showToast(msg: "gagal menghapus");
    });
  }

  String _replaceLinkFirebaseStorage(String link){
    return link.replaceAll("https://firebasestorage.googleapis.com/v0/b/flutter-kkhelper.appspot.com/o/", "");
  }

  _delImage(String path){
    try {
      FirebaseStorage.instance.ref().child(path).delete().whenComplete(() {
//        Fluttertoast.showToast(msg: "seccess delete");
      }).catchError((err){
        Fluttertoast.showToast(msg: "error delete image");
      }).then((str){
//        Fluttertoast.showToast(msg: "then delete");
      }, onError: (){
        Fluttertoast.showToast(msg: "error delete image");
      });
    } on PlatformException {
      Fluttertoast.showToast(msg: "file tidak ditemukan");
    } catch (e){
      Fluttertoast.showToast(msg: "file tidak ditemukan");
    }
  }

  DataTambahKK _searchByKey(String key){
    DataTambahKK data = new DataTambahKK();
    for(int i = 0; i < listTambahKK.length; i++){
      if (listTambahKK[i].key == key){
        data = listTambahKK[i];
        break;
      }
    }
    return data;
  }

  List<Widget> _getTambahKK(DataSnapshot snapshot){
    List<Widget> wgt = [];
    int index = 0;
    listTambahKK = [];
    listHilangKK = [];
    Map<dynamic, dynamic> values = snapshot.value;
    if (values.length == 1){
      return <Widget> [
        new Container(
          height: MediaQuery.of(context).size.height-80,
          alignment: Alignment(0, 0),
          child: new Text(
            "anda belum melakukan apapun",
            style: new TextStyle(color: Colors.black38),
          ),
        ),
      ];
    }
    values.forEach((key, value){
      if (key != "user"){
        if (value != null){
          Map<dynamic, dynamic> list = value;
          list.forEach((keyList, valList){
            if (valList["idUser"] == user.Key){
              String d = valList["date"];
              var date = d.split(" ");
              var tanggal = date[0].split("-");

              if (key == "tambah_kk"){
                DataTambahKK dtk = new DataTambahKK();
                dtk.setKey = keyList;
                dtk.setAccKecamatan = valList["accKecamatan"];
                dtk.setaccKelurahan = valList["accKelurahan"];
                dtk.setAlamat = valList["alamat"];
                dtk.setDate = valList["date"];
                dtk.setIdUser = valList["idUser"];
                dtk.setKecamatan = valList["kecamatan"];
                dtk.setKelurahan = valList["kelurahan"];
                dtk.setKepalaKeluarga = valList["kepalaKeluarga"];
                dtk.setReject = valList["reject"];
                dtk.setRejectKeterangan = valList["rejectKeterangan"];
                dtk.setRt = valList["rt"];
                dtk.setRw = valList["rw"];

                String strAnggota = jsonEncode(valList["anggotaKeluarga"]);
                List<dynamic> mapping = jsonDecode(strAnggota);

                List<DataKeluarga> listDk = [];

                mapping.forEach((str){
                  String jsonStr = jsonEncode(str);
                  DataKeluarga baru = DataKeluarga.fromJson(jsonDecode(jsonStr));
                  listDk.add(baru);
                });
                dtk.setAnggotaKeluarga = listDk;

                String strImage = jsonEncode(valList["image"]);
                Map<dynamic, dynamic> mapImage = jsonDecode(strImage);
                mapImage.forEach((key, valImage){
                  if (key == "ketDomisili"){
                    dtk.setKetDomisili = valImage;
                  } else {
                    List<String> imgArray = [];
                    List<dynamic> mapArray = jsonDecode(jsonEncode(valImage));
                    mapArray.forEach((str){
                      imgArray.add(str);
                    });

                    if (key == "aktaKawin"){
                      dtk.setAktaKawin = imgArray;
                    } else if (key == "pekerjaan"){
                      dtk.setPekerjaan = imgArray;
                    } else if (key == "pindahDatang"){
                      dtk.setPindahDatang = imgArray;
                    }
                  }
                });

                listTambahKK.add(dtk);
              } else if (key == "hilang_kk"){
                DataHilangKK dhk = new DataHilangKK();
                dhk.setKey = keyList;
                dhk.setAccKecamatan = valList["accKecamatan"];
                dhk.setaccKelurahan = valList["accKelurahan"];
                dhk.setAlamat = valList["alamat"];
                dhk.setDate = valList["date"];
                dhk.setIdUser = valList["idUser"];
                dhk.setKecamatan = valList["kecamatan"];
                dhk.setKelurahan = valList["kelurahan"];
                dhk.setKepalaKeluarga = valList["kepalaKeluarga"];
                dhk.setReject = valList["reject"];
                dhk.setRejectKeterangan = valList["rejectKeterangan"];
                dhk.setRt = valList["rt"];
                dhk.setRw = valList["rw"];

                String strAnggota = jsonEncode(valList["anggotaKeluarga"]);
                List<dynamic> mapping = jsonDecode(strAnggota);

                List<DataKeluarga> listDk = [];

                mapping.forEach((str){
                  String jsonStr = jsonEncode(str);
                  DataKeluarga baru = DataKeluarga.fromJson(jsonDecode(jsonStr));
                  listDk.add(baru);
                });
                dhk.setAnggotaKeluarga = listDk;

                String strImage = jsonEncode(valList["image"]);
                Map<dynamic, dynamic> mapImage = jsonDecode(strImage);
                mapImage.forEach((key, valImage){
                  if (key == "kk"){
                    dhk.setKKLama = valImage;
                  } else if (key == "ktp"){
                    dhk.setKtp = valImage;
                  } else if (key == "kehilangan"){
                    dhk.setKehilanganPolisi = valImage;
                  } else if (key == "pengantar"){
                    dhk.setPengantarRtRw = valImage;
                  }
                });

                listHilangKK.add(dhk);
              }
              wgt.add(
                new Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150.0,
                  margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        width: 10.0,
                        height: 150.0,
                        color: key == "tambah_kk" ? Colors.redAccent :
                        key == "hilang_kk" ? Colors.amberAccent : Colors.deepOrangeAccent,
                      ),
                      new Expanded(
                          child: new Container(
                            width: MediaQuery.of(context).size.width,
                            height: 150.0,
                            child: new Column(
                              children: <Widget>[
                                new Container(
                                    height: 100.0,
                                    padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 10.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              new Container(
                                                child: new Text(
                                                  valList["kepalaKeluarga"],
                                                  textAlign: TextAlign.left,
                                                  style: new TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15.0
                                                  ),
                                                ),
                                                alignment: Alignment.topLeft,
                                                padding: const EdgeInsets.only(bottom: 2.0, top: 15.0),
                                              ), new Container(
                                                alignment: Alignment(-1, 0),
                                                child: new Text(
                                                  valList["alamat"],
                                                  textAlign: TextAlign.left,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: new TextStyle(
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                padding: const EdgeInsets.only(right: 10.0, bottom: 7.0),
                                              ), new Container(
                                                alignment: Alignment.topLeft,
                                                padding: const EdgeInsets.only(top: 5.0),
                                                child: new Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    new Icon(
                                                      Icons.calendar_today,
                                                      size: 10.0,
                                                      color: Colors.black26,
                                                    ), new Container(
                                                      margin: const EdgeInsets.only(left: 5.0, right: 10.0),
                                                      child: new Text(
                                                        tanggal[2] + "-" + tanggal[1] + "-" + tanggal[0],
                                                        style: new TextStyle(
                                                            color: Colors.black26,
                                                            fontSize: 10.0
                                                        ),
                                                      ),
                                                    ), new Icon(
                                                      Icons.access_time,
                                                      size: 10.0,
                                                      color: Colors.black26,
                                                    ), new Container(
                                                      margin: const EdgeInsets.only(left: 5.0, right: 10.0),
                                                      child: new Text(
                                                        date[1],
                                                        style: new TextStyle(
                                                            color: Colors.black26,
                                                            fontSize: 10.0
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          fit: FlexFit.loose,
                                        ), new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Container(
                                              padding: const EdgeInsets.only(bottom: 2.0, top: 15.0),
                                              child: new Container(
                                                child: new Text(
                                                  valList["reject"] == "" ? (valList["accKecamatan"] == true && valList["accKelurahan"] == true)
                                                      ? "selesai" : "proses" : "ditolak",
                                                  style: new TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13.0
                                                  ),
                                                ),
                                                padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                                decoration: new BoxDecoration(
                                                  color: valList["reject"] == "" ? (valList["accKecamatan"] == true && valList["accKelurahan"] == true)
                                                      ? Colors.greenAccent : Colors.blueAccent : Colors.redAccent,
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                ),
                                new Container(
                                  height: 50.0,
                                  color: new Color(0xfff7f7f7),
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: new Row(
                                    children: <Widget>[
                                      new Flexible(
                                        child: new Container(
                                          child: new Text(
                                            "ket : " + valList["rejectKeterangan"],
                                            style: new TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12.0
                                            ),
                                          ),
                                          width: MediaQuery.of(context).size.width,
                                        ),
                                        fit: FlexFit.loose,
                                      ),
                                      new Flexible(
                                          fit: FlexFit.loose,
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              new Expanded(
                                                child: new FlatButton(
                                                  onPressed: (){
                                                    _infoTap(keyList);
                                                  },
                                                  child: new Icon(
                                                    Icons.info,
                                                    color: Colors.black38,
                                                  ),
                                                ),
                                              ),
                                              new Expanded(
                                                child: new FlatButton(
                                                    onPressed: () {},
                                                    child: new Icon(
                                                      Icons.edit,
                                                      color: Color(0xff0ba5c4),
                                                    )
                                                ),
                                              ),
                                              new Expanded(
                                                  child: new FlatButton(
                                                      onPressed: () {
                                                        _dialogConfirm(keyList);
                                                      },
                                                      child: new Icon(
                                                        Icons.delete,
                                                        color: Color(0xffb7190b),
                                                      )
                                                  )
                                              ),
                                            ],
                                          )
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                            color: Colors.black38,
                            offset: Offset(0, 0.28),
                            blurRadius: 1
                        )
                      ]
                  ),
                ),
              );
            }
          });
        } else {
          print("null snap");
        }
      }
      index++;
    });
    return wgt;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
      }
    }, onError: (){
      Fluttertoast.showToast(msg: "error pengambilan local disk");
    });

    _database.reference().onChildChanged.listen((event){
      Map<dynamic, dynamic> values = event.snapshot.value;
      values.forEach((key, value){
        print("keyekk changed " + " " + key);
      });
    });

    _database.reference().onChildAdded.listen((event){
      print("keyekk addd ");
    });

    _database.reference().onChildRemoved.listen((event){
      print("keyekk remove ");
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Material(
      child: new Scaffold(
        backgroundColor: Colors.white70,
        key: _scaffoldStateKey,
        appBar: new GradientAppBar(
          elevation: 4.0,
          backgroundColorStart: Color(0xFF35ade0),
          backgroundColorEnd: Color(0xff4b72f2),
          leading: new IconButton(
              icon: new Icon(
                Icons.menu,
                size: 30.0,
                color: Colors.white70,
              ),
              onPressed: (){
                _scaffoldStateKey.currentState.openDrawer();
              }
          ),
          title: new Align(
            alignment: Alignment(-0.15, 0),
            child: new Text (
              "Track Permohonan",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
                color: Colors.white70,
              ),
            ),
          ),
        ),
        drawer: new Ddrawer(firebaseUser: widget.firebaseUser),
        body: new SafeArea(
            child: new SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: new Stack(
                children: <Widget>[
                  new FutureBuilder(
                    future: _database.reference().once(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!=null) {
                          return new Column(
                            mainAxisSize: MainAxisSize.max,
                            children:  _getTambahKK(snapshot.data),
                          );
                        } else {
                          return new CircularProgressIndicator(
                            strokeWidth: 4.0,
                          );
                        }
                      } else {
                        return new Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          alignment: Alignment(0.0, 0.0),
                          child: new SizedBox(
                            child: new CircularProgressIndicator(
                              strokeWidth:3.0,
                            ),
                            height: 50.0,
                            width: 50.0,
                          ),
                        );
                      }
                    },
                  ),
                  load ? new Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment(0.0, 0.0),
                    child: new SizedBox(
                      child: new CircularProgressIndicator(
                        strokeWidth:3.0,
                      ),
                      height: 50.0,
                      width: 50.0,
                    ),
                  ) : new Text(""),
                ],
              )
            )
        ),
      ),
    );
  }

}