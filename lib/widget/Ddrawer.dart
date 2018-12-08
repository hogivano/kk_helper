import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kk_helper/routes/login.dart';
import 'package:kk_helper/routes/tambah_kk.dart';
import 'package:kk_helper/routes/track.dart';
import 'package:kk_helper/model/users.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kk_helper/routes/dashboard.dart';
import 'package:kk_helper/routes/hilang_kk.dart';
import 'package:kk_helper/routes/perubahan_kk.dart';
import 'package:kk_helper/routes/kurang_anggota.dart';
import 'package:kk_helper/routes/tambah_anggota.dart';
import 'dart:convert';
import 'package:kk_helper/local_disk.dart';
import 'package:firebase_database/firebase_database.dart';

class Ddrawer extends StatefulWidget {
  final FirebaseUser firebaseUser;
  final Users user;
  const Ddrawer({Key key, @required this.firebaseUser, this.user})
      : assert(firebaseUser != null),
        super(key: key);
  @override
  State<StatefulWidget> createState() => new _dDrawer();
}

class _dDrawer extends State<Ddrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Users s = new Users();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  bool _showUserEdit = false;

  Future<void> _logout() async {
    await new LocalDisk().remove("user");
    await _auth.signOut().whenComplete(() {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (context) => Login(),
      ));
    });
  }

  Widget _buildUserDetail() {
    return Container(
      color: Colors.lightBlue,
      child: ListView(
        children: [
          ListTile(
            title: Text("User details"),
            leading: Icon(Icons.info_outline),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                setState(() {
                  s.setKey = key;
                  s.setNama = value["nama"];
                  s.setNoTelp = value["noTelp"];
                  s.setImage = value["image"];
                  s.setRole = value["role"];
                });

                new LocalDisk()
                    .setString("user", jsonEncode(s.toJsonWithKey()));
              } else if (value["email"] == widget.firebaseUser.email) {
                setState(() {
                  s.setKey = key;
                  s.setNama = value["nama"];
                  s.setEmail = value["email"];
                  s.setImage = value["image"];
                  s.setRole = value["role"];
                });

                new LocalDisk()
                    .setString("user", jsonEncode(s.toJsonWithKey()));
              }
            });
          }
        });
      } else {
        Map userMap = jsonDecode(str);
        setState(() {
          this.s = new Users.fromJsonWithKey(userMap);
        });
      }
    }, onError: () {
      Fluttertoast.showToast(msg: "error pengambilan local disk");
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.firebaseUser.photoUrl.toString());
    print(widget.firebaseUser.phoneNumber.toString());
    // TODO: implement build
    return new SafeArea(
        child: new Drawer(
      child: new Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new UserAccountsDrawerHeader(
            currentAccountPicture: new Container(
                width: 190.0,
                height: 190.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: s.image == "" ? AssetImage("assets/image/kk-helper.png") : new NetworkImage(
                            s.image)))),
            accountName: new Container(
              padding: const EdgeInsets.only(top: 20.0),
              child: new Text(
                this.s.nama,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 18.0
                ),
              ),
            ),
            accountEmail: new Text(
              s.email != "" ? s.email : s.noTelp,
              style: new TextStyle(color: Colors.white, fontSize: 15.0),
            ),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(colors: [
                Color(0xff1fb6f7),
                Color(0xFF35ade0),
                Color(0xff20b7f7)
              ]),
            ),
          ),
          new SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: new Column(
              children: <Widget>[
                new Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new ListTile(
                      leading: new Icon(Icons.dashboard),
                      title: new Text("Dashboard"),
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacement(new MaterialPageRoute(
                          builder: (context) =>
                              Dashboard(firebaseUser: widget.firebaseUser),
                        ));
                      },
                    ),
                    new ListTile(
                      leading: new Icon(Icons.add),
                      title: new Text("KK Baru"),
                      onTap: () {
                        return Navigator.of(context)
                            .push(new MaterialPageRoute(
                          builder: (context) =>
                              TambahKK(firebaseUser: widget.firebaseUser),
                        ));
                      },
                    ),
                    new ListTile(
                      leading: new Icon(Icons.add),
                      title: new Text("Tambah Anggota"),
                      onTap: () {
                        return Navigator.of(context)
                            .push(new MaterialPageRoute(
                          builder: (context) =>
                          TambahAnggota(firebaseUser: widget.firebaseUser),
                        ));
                      },
                    ),
                    new ListTile(
                      leading: new Icon(Icons.remove),
                      title: new Text("Kurang Anggota"),
                      onTap: () {
                        return Navigator.of(context)
                            .push(new MaterialPageRoute(
                          builder: (context) =>
                              KurangAnggota(firebaseUser: widget.firebaseUser),
                        ));
                      },
                    ),
                    new ListTile(
                      leading: new Icon(Icons.restore_page),
                      title: new Text("KK Hilang/Rusak"),
                      onTap: () {
                        return Navigator.of(context)
                            .push(new MaterialPageRoute(
                          builder: (context) =>
                              HilangKK(firebaseUser: widget.firebaseUser),
                        ));
                      },
                    ),
                    new ListTile(
                      leading: new Icon(Icons.track_changes),
                      title: new Text("Track"),
                      onTap: () {
                        return Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) =>
                              Track(firebaseUser: widget.firebaseUser),
                        ));
                      },
                    ),
                  ],
                ),
                new Stack(
                  children: <Widget>[
                    new Align(
                        alignment: Alignment(0.0, -1.0),
                        child: new Container(
                          child: new RaisedButton(
                            onPressed: _logout,
                            splashColor: Colors.white54,
                            color: Theme.of(context).accentColor,
                            child: new Text(
                              "keluar",
                              style: new TextStyle(color: Colors.white),
                            ),
                            elevation: 3.0,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            padding: const EdgeInsets.fromLTRB(
                                80.0, 10.0, 80.0, 10.0),
                          ),
                          margin: const EdgeInsets.only(top: 20.0),
                        ))
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
