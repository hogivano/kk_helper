import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:kk_helper/local_disk.dart';
import 'package:kk_helper/list_kec_kel.dart';
import 'package:kk_helper/widget/Ddrawer.dart';
import 'dart:convert';
import 'package:kk_helper/model/users.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TambahAnggota extends StatefulWidget{
  final FirebaseUser firebaseUser;
  const TambahAnggota({Key key, @required this.firebaseUser})
      :assert(firebaseUser != null),
        super(key : key);

  @override
  State<StatefulWidget> createState() => new _tambahAnggotaState();
}

class _tambahAnggotaState extends State<TambahAnggota>{

  final GlobalKey<ScaffoldState> _scaffoldStateKey = new GlobalKey<ScaffoldState>();

  List<TextEditingController> _namaAnggotaController = [];
  List<TextEditingController> _nikAnggotaController = [];
  List<TextEditingController> _namaKepalaLamaController = [];
  List<TextEditingController> _noKKLamaController = [];
  List<TextEditingController> _alamatLamaController = [];

  TextEditingController _kepalaDiikutiController = new TextEditingController();
  TextEditingController _noKKDiikutiController = new TextEditingController();
  TextEditingController _alamatDiikutiController = new TextEditingController();
  TextEditingController _rtDiikutiController = new TextEditingController();
  TextEditingController _rwDiikutiController = new TextEditingController();

  List<String> listKecamatan = ListKecKel.getListKecamatan();
  List<List<String>> listKelurahan = ListKecKel.getListKelurahan();

  String kepalaDiikuti = "";
  String noKKDiikuti = "";
  String alamatDiikuti = "";
  String kelurahanDiikuti = "";
  String kecamatanDiikuti = "";
  String rtDiikuti = "";
  String rwDiikuti = "";

  Users user = new Users();

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  int posForm = 0;
  int posKecamatan = -1;
  bool kirimData = false;

  int _jumlahKurang = 0;
  int _jumlahAnggota = 0;

  List<String> listDay = [];
  List<String> listMonth = [];
  List<String> listYear = [];

  void _setInputForm1(){
    _kepalaDiikutiController.text = kepalaDiikuti;
    _noKKDiikutiController.text = noKKDiikuti;
    _alamatDiikutiController.text = alamatDiikuti;
    _rtDiikutiController.text = rtDiikuti;
    _rwDiikutiController.text = rwDiikuti;
  }

  bool _cekInputForm1(){
    if (kepalaDiikuti == "" || noKKDiikuti == "" || alamatDiikuti == "" || rtDiikuti == "" || rwDiikuti == "" ||
        kelurahanDiikuti == "" || kecamatanDiikuti == "" || _jumlahKurang == 0){
      Fluttertoast.showToast(msg: "semua data harus diisi", toastLength: Toast.LENGTH_SHORT);
      return false;
    } else if (noKKDiikuti.length != 16) {
      Fluttertoast.showToast(msg: "jumlah nokk sebanyak 16 digit");
      return false;
    } else {
      return true;
    }
  }

  bool _cekInputForm2(){

  }

  bool _cekInputForm3(){

  }

  bool _cekInputForm4(){

  }

  List<Widget> _btnNextPrev(int pos){
    if (pos == 0 ){
      return <Widget> [
        new Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
          child: new RaisedButton(
            onPressed: (){
              if (_cekInputForm1()){
                setState(() {
                  posForm++;
                });
              }
            },
            color: Color(0xff6ba3ff),
            child: new Text(
              "Next",
              style: new TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        )
      ];
    } else if (pos == 3){
      return <Widget> [
        new Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
          child: new RaisedButton(
            onPressed: (){
              setState(() {
                posForm--;
              });
            },
            color: Color(0xff6ba3ff),
            child: new Text(
              "Prev",
              style: new TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        ),
        new Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
          child: new RaisedButton(
            onPressed: (){
              if (_cekInputForm3()){
                setState(() {
                  kirimData = true;
                });
//                _storeData();
              }
            },
            color: Color(0xff41f4a0),
            child: new Text(
              "Kirim",
              style: new TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        )
      ];
    } else {
      return <Widget> [
        new Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
          child: new RaisedButton(
            onPressed: (){
              setState(() {
                _setInputForm1();
                posForm--;
              });
            },
            color: Color(0xff6ba3ff),
            child: new Text(
              "Prev",
              style: new TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        ),
        new Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
          child: new RaisedButton(
            onPressed: (){
              setState(() {
                if (_cekInputForm2()){
                  setState(() {
                    posForm++;
                  });
                }
              });
            },
            color: Color(0xff6ba3ff),
            child: new Text(
              "Next",
              style: new TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        )
      ];
    }
  }

  List<Widget> _switchForm(int pos){
    switch (pos){
      case 0:
        return _showForm1(MediaQuery.of(context).size.width / 22);
        break;
      case 1:
        return _showForm2(MediaQuery.of(context).size.width / 22);
        break;
      case 2:
        return _showForm3(MediaQuery.of(context).size.width / 22);
        break;
      case 3:
        return _showForm4(MediaQuery.of(context).size.width / 22);
        break;
    }
  }

  List<Widget> _showForm1(double fontForm){
    return <Widget>[
      new Container(
        alignment: Alignment.centerLeft,
        child: new Text("Kepala Keluarga :"),
        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
      ), new Container(
        margin: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width / 1,
        alignment: Alignment.center,
        child: new TextField(
          controller: _kepalaDiikutiController,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: fontForm,
            color: Colors.black54,
          ),
          decoration: new InputDecoration(
            hintStyle: TextStyle(
              fontSize: fontForm - 5,
            ),
            hintText: "nama lengkap",
            border: InputBorder.none,
          ),
          onChanged: (val){
            setState(() {
              kepalaDiikuti = val;
            });
          },
        ),
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              kepalaDiikuti == "" ?
              new BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, 0.2),
                  blurRadius: 0.2
              ) :
              new BoxShadow(
                  color: Colors.blue,
                  offset: Offset(0, 0.28),
                  blurRadius: 1
              )
            ]
        ),
      ), new Container(
        alignment: Alignment.centerLeft,
        child: new Text("No KK :"),
        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
      ), new Container(
        margin: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width / 1,
        alignment: Alignment.center,
        child: new TextField(
          controller: _noKKDiikutiController,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: fontForm,
            color: Colors.black54,
          ),
          decoration: new InputDecoration(
            hintStyle: TextStyle(
              fontSize: fontForm - 5,
            ),
            hintText: "no kk",
            border: InputBorder.none,
          ),
          onChanged: (val){
            setState(() {
              noKKDiikuti = val;
            });
          },
        ),
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              noKKDiikuti == "" ?
              new BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, 0.2),
                  blurRadius: 0.2
              ) :
              new BoxShadow(
                  color: Colors.blue,
                  offset: Offset(0, 0.28),
                  blurRadius: 1
              )
            ]
        ),
      ), new Container(
        alignment: Alignment.centerLeft,
        child: new Text("Alamat :"),
        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
      ), new Container(
        margin: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width / 1,
        alignment: Alignment.center,
        child: new TextField(
          controller: _alamatDiikutiController,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: fontForm,
            color: Colors.black54,
          ),
          decoration: new InputDecoration(
            hintStyle: TextStyle(
              fontSize: fontForm - 5,
            ),
            hintText: "alamat lengkap",
            border: InputBorder.none,
          ),
          onChanged: (val){
            setState(() {
              alamatDiikuti = val;
            });
          },
        ),
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              alamatDiikuti == "" ?
              new BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, 0.2),
                  blurRadius: 0.2
              ) :
              new BoxShadow(
                  color: Colors.blue,
                  offset: Offset(0, 0.28),
                  blurRadius: 1
              )
            ]
        ),
      ), new Row(
        children: <Widget>[
          new Flexible(
              child: new Container(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      alignment: Alignment.centerLeft,
                      child: new Text("RT :"),
                      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                    ), new Container(
                      margin: const EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width / 1,
                      alignment: Alignment.center,
                      child: new TextField(
                        controller: _rtDiikutiController,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: fontForm,
                          color: Colors.black54,
                        ),
                        decoration: new InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: fontForm - 5,
                          ),
                          hintText: "rt",
                          border: InputBorder.none,
                        ),
                        onChanged: (val){
                          setState(() {
                            rtDiikuti = val;
                          });
                        },
                        keyboardType: TextInputType.number,
                      ),
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: [
                            rtDiikuti == "" ?
                            new BoxShadow(
                                color: Colors.black38,
                                offset: Offset(0, 0.2),
                                blurRadius: 0.2
                            ) :
                            new BoxShadow(
                                color: Colors.blue,
                                offset: Offset(0, 0.28),
                                blurRadius: 1
                            )
                          ]
                      ),
                    ),
                  ],
                ),
              )
          ), new Flexible(
              child: new Container(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      alignment: Alignment.centerLeft,
                      child: new Text("RW :"),
                      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                    ), new Container(
                      margin: const EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width / 1,
                      alignment: Alignment.center,
                      child: new TextField(
                        controller: _rwDiikutiController,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: fontForm,
                          color: Colors.black54,
                        ),
                        decoration: new InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: fontForm - 5,
                          ),
                          hintText: "rw",
                          border: InputBorder.none,
                        ),
                        onChanged: (val){
                          setState(() {
                            rwDiikuti = val;
                          });
                        },
                        keyboardType: TextInputType.number,
                      ),
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: [
                            rwDiikuti == "" ?
                            new BoxShadow(
                                color: Colors.black38,
                                offset: Offset(0, 0.2),
                                blurRadius: 0.2
                            ) :
                            new BoxShadow(
                                color: Colors.blue,
                                offset: Offset(0, 0.28),
                                blurRadius: 1
                            )
                          ]
                      ),
                    ),
                  ],
                ),
              )
          )
        ],
      ),new Container(
        alignment: Alignment.centerLeft,
        child: new Text("Kecamatan :"),
        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
      ), new Container(
        margin: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width / 1,
        child: new DropdownButtonHideUnderline(
          child: new DropdownButton(
            hint: new Text(
              kecamatanDiikuti == "" ? "kecamatan" : kecamatanDiikuti,
              style: TextStyle(
                  fontSize: fontForm - 3
              ),
              textAlign: TextAlign.center,
            ),
            items: listKecamatan.map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            style: new TextStyle(
              fontSize: fontForm - 3,
              color: Colors.black54,
            ),
            onChanged: (value) {
              setState(() {
                kecamatanDiikuti = value;
                kelurahanDiikuti = "";
                for (int i = 0; i < listKecamatan.length; i++){
                  if (listKecamatan[i] == value){
                    posKecamatan = i;
                  }
                }
              });
            },
          ),
        ),
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              kecamatanDiikuti == "" ?
              new BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, 0.2),
                  blurRadius: 0.2
              ) :
              new BoxShadow(
                  color: Colors.blue,
                  offset: Offset(0, 0.28),
                  blurRadius: 1
              )
            ]
        ),
      ), new Container(
        alignment: Alignment.centerLeft,
        child: new Text("Kelurahan :"),
        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
      ), new Container(
        margin: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width / 1,
        child: new DropdownButtonHideUnderline(
          child: new DropdownButton(
            hint: new Text(
              kelurahanDiikuti == "" ? "kelurahan" : kelurahanDiikuti,
              style: TextStyle(
                  fontSize: fontForm - 3
              ),
              textAlign: TextAlign.center,
            ),
            items: posKecamatan == -1 ? null : listKelurahan[posKecamatan].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList()
            ,style: new TextStyle(
            fontSize: fontForm - 3,
            color: Colors.black54,
          ),
            onChanged: (value) {
              setState(() {
                kelurahanDiikuti = value;
              });
            },
          ),
        ),
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              kelurahanDiikuti == "" ?
              new BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, 0.2),
                  blurRadius: 0.2
              ) :
              new BoxShadow(
                  color: Colors.blue,
                  offset: Offset(0, 0.28),
                  blurRadius: 1
              )
            ]
        ),
      ), new Container(
        alignment: Alignment.centerLeft,
        child: new Text("Jumlah Pengurangan :"),
        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
      ), new Container(
        margin: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width / 1,
        child: new DropdownButtonHideUnderline(
          child: new DropdownButton(
            hint: new Text(
              _jumlahKurang == 0 ? "jumlah kurang" : _jumlahKurang.toString(),
              style: TextStyle(
                  fontSize: fontForm - 3
              ),
              textAlign: TextAlign.center,
            ),
            items: ["1", "2", "3", "4", "5"].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList()
            ,style: new TextStyle(
            fontSize: fontForm - 3,
            color: Colors.black54,
          ),
            onChanged: (value) {
              setState(() {
                _jumlahKurang = int.parse(value);
              });
            },
          ),
        ),
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              _jumlahKurang == 0 ?
              new BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, 0.2),
                  blurRadius: 0.2
              ) :
              new BoxShadow(
                  color: Colors.blue,
                  offset: Offset(0, 0.28),
                  blurRadius: 1
              )
            ]
        ),
      ),
    ];
  }

  List<Widget> _showForm2(double fontForm){
    List<Widget> list = [];

  }

  List<Widget> _showForm3(double fontForm){

  }

  List<Widget> _showForm4(double fontForm){

  }

  Future<bool> _onWillPop(){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Apa anda yakin keluar?'),
        content: new Text('Semua data yang diisi akan hilang'),
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
            onPressed: () => Navigator.of(context).pop(true),
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double fontForm = MediaQuery.of(context).size.width / 22;
    double fontJudul = MediaQuery.of(context).size.width / 10;
    // TODO: implement build
    return new Material(
        child: new WillPopScope(
            onWillPop: _onWillPop,
            child: new Scaffold(
              backgroundColor: Colors.white70,
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
                    ),
                    onPressed: (){
                      _scaffoldStateKey.currentState.openDrawer();
                    }
                ),
                title: new Align(
                  alignment: Alignment(-0.15, 0),
                  child: new Text (
                    "Pengurangan Anggota",
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
                  child: new Stack(
                    children: <Widget>[
                      new SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: new Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Container (
                              child: new Text(
                                posForm == 0 ?  "Data KK" : posForm == 1 ? "DATA KELUARGA" : "UPLOAD KELENGKAPAN"
                                ,textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              alignment: Alignment.topCenter,
                              padding: const EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 15.0),
                            ),
                            new Container(
                              margin: const EdgeInsets.symmetric(vertical: 15.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Container(
                                    child: new CircleAvatar(
                                      child: new Text(
                                        "1",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      ),
                                      backgroundColor: Color(0xff639fff),
                                    ),
                                    width: fontForm * 2.5,
                                    height: fontForm * 2.5,
                                    padding: const EdgeInsets.all(1.0),
                                    decoration: new BoxDecoration(
                                      color: Color(0xff639fff),
                                      shape: BoxShape.circle,
                                    ),
                                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                  ),
                                  new Container(
                                    child: new CircleAvatar(
                                      child: new Text(
                                        "2",
                                        style: TextStyle(
                                          color: posForm > 0 ? Colors.white : Color(0xff639fff),
                                        ),
                                      ),
                                      backgroundColor: posForm > 0 ? Color(0xff639fff) : Colors.white,
                                    ),
                                    width: fontForm * 2.5,
                                    height: fontForm * 2.5,
                                    padding: const EdgeInsets.all(1.0),
                                    decoration: new BoxDecoration(
                                        color: posForm > 0 ? Color(0xff639fff) : Colors.black,
                                        shape: BoxShape.circle
                                    ),
                                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                  ),
                                  new Container(
                                    child: new CircleAvatar(
                                      child: new Text(
                                        "3",
                                        style: TextStyle(
                                          color: posForm > 1 ? Colors.white : Color(0xff639fff),
                                        ),
                                      ),
                                      backgroundColor: posForm > 1 ? Color(0xff639fff) : Colors.white,
                                    ),
                                    width: fontForm * 2.5,
                                    height: fontForm * 2.5,
                                    padding: const EdgeInsets.all(1.0),
                                    decoration: new BoxDecoration(
                                        color: posForm > 1 ? Color(0xff639fff) : Colors.black,
                                        shape: BoxShape.circle
                                    ),
                                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                  ), new Container(
                                    child: new CircleAvatar(
                                      child: new Text(
                                        "4",
                                        style: TextStyle(
                                          color: posForm == 3 ? Colors.white : Color(0xff639fff),
                                        ),
                                      ),
                                      backgroundColor: posForm == 3 ? Color(0xff639fff) : Colors.white,
                                    ),
                                    width: fontForm * 2.5,
                                    height: fontForm * 2.5,
                                    padding: const EdgeInsets.all(1.0),
                                    decoration: new BoxDecoration(
                                        color: posForm == 3 ? Color(0xff639fff) : Colors.black,
                                        shape: BoxShape.circle
                                    ),
                                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                  )
                                ],
                              ),
                            ),
                            new Column(
                              mainAxisSize: MainAxisSize.max,
                              children: _switchForm(posForm),
                            ), new Container(
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              child: new Stack(
                                  children: _btnNextPrev(posForm)
                              ),
                            )
                          ],
                        ),
                      ),
                      kirimData == true ? new Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.black38,
                          alignment: Alignment(0.0, 0.0),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new SizedBox(
                                child: new CircularProgressIndicator(
                                  strokeWidth:5.0,
                                ),
                                height: 80.0,
                                width: 80.0,
                              ),
                              new Container(
                                margin: const EdgeInsets.symmetric(vertical: 20.0),
                                child: new Text(
                                    "Kondisi Kirim",
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0
                                    )
                                ),
                              )
                            ],
                          )
                      ) : new Text("")
                    ],
                  )
              ),
            )
        )
    );
  }

  @override
  void initState(){
    super.initState();

    var now = new DateTime.now();
    for(int i = now.year; i >= 1900; i--){
      this.listYear.add(i.toString());
    };

    for(int i = 1; i <= now.month; i++){
      this.listMonth.add(i.toString());
    };

    for(int i = 1; i <= 31; i++){
      this.listDay.add(i.toString());
    };

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
        Map<dynamic, dynamic> userMap = jsonDecode(str);
        this.user = new Users.fromJsonWithKey(userMap);
        print("user key " + this.user.Key);
      }
    }, onError: (){
      Fluttertoast.showToast(msg: "error pengambilan local disk");
    });
  }
}