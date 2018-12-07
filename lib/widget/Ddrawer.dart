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
import 'package:kk_helper/local_disk.dart';

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

  Future<void> _logout() async {
    await new LocalDisk().remove("user");
    await _auth.signOut().whenComplete(() {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (context) => Login(),
      ));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            accountName: new Text(
              widget.user != null ? widget.user.nama : "",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0),
            ),
            accountEmail: new Text(
              widget.firebaseUser.email != null
                  ? widget.firebaseUser.email
                  : widget.firebaseUser.phoneNumber.toString(),
              style: new TextStyle(color: Colors.white),
            ),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(colors: [
                Color(0xff1fb6f7),
                Color(0xFF35ade0),
                Color(0xff20b7f7)
              ]),
            ),
            onDetailsPressed: () {},
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
                            .pushReplacement(new MaterialPageRoute(
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
                            .pushReplacement(new MaterialPageRoute(
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
                            .pushReplacement(new MaterialPageRoute(
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
                            .pushReplacement(new MaterialPageRoute(
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
