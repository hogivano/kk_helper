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
  File _image;

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

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future<Uri> _uploadImage() async{
//    cekNik().then((test){
//      Fluttertoast.showToast(msg : test.toString().contains("Terima kasih").toString());
//    }, onError: (err){
//      Fluttertoast.showToast(msg: "error gess");
//    });
    final StorageReference firebaseRef = FirebaseStorage.instance.ref().child("profile_" +
        widget.firebaseUser.uid);
    Logger.log("Upload", message: _image.toString());
    firebaseRef.putFile(_image).onComplete.then((as){
      as.ref.getDownloadURL().then((download){
        Fluttertoast.showToast(msg: download.toString());
      }, onError: (err) {
        Fluttertoast.showToast(msg: "gagal upload file");
      });
    }, onError: (err){
      Fluttertoast.showToast(msg: err, toastLength: Toast.LENGTH_SHORT);
    });
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

                Fluttertoast.showToast(msg: "masukk di email");
              }
            });
          }
        });
      } else {
        Map userMap = jsonDecode(str);
        this.user = new Users.fromJsonWithKey(userMap);
        print("user key " + this.user.Key);
        Fluttertoast.showToast(msg: 'masuk ada isi');
      }
    }, onError: (){
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
          backgroundColorEnd: Color(0xff4b72f2),
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
              "KK Helper",
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
            child: new Column(
              children: <Widget>[
                new Align(
                  child: _image == null
                      ? new Text('No image selected.')
                      : new Image.file(_image),
                ),
                new Container(
                  alignment: Alignment.center,
                  child: new RaisedButton(
                    onPressed: getImage,
                    color: Theme.of(context).accentColor,
                    splashColor: Colors.white10,
                    elevation: 4,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.fromLTRB(80.0, 10.0, 80.0, 10.0),
                    child: Text(
                      "Upload",
                      style: new TextStyle(
                          color: Colors.white70,
                          fontSize: 13.0,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none
                      ),
                    ),
                  ),
                ),
                new Container(
                  alignment: Alignment.center,
                  child: new RaisedButton(
                    onPressed: _uploadImage,
                    color: Theme.of(context).accentColor,
                    splashColor: Colors.white10,
                    elevation: 4,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.fromLTRB(80.0, 10.0, 80.0, 10.0),
                    child: Text(
                      "Kirim",
                      style: new TextStyle(
                          color: Colors.white70,
                          fontSize: 13.0,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none
                      ),
                    ),
                  ),
                ),
              ],
            )
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