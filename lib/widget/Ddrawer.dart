import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kk_helper/routes/login.dart';
import 'package:kk_helper/routes/tambah_kk.dart';

class Ddrawer extends StatefulWidget{
  final FirebaseUser firebaseUser;
  const Ddrawer({Key key, @required this.firebaseUser})
      :assert(firebaseUser != null),
        super(key : key);
  @override
   State<StatefulWidget> createState() => new _dDrawer();
}

class _dDrawer extends State<Ddrawer>{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logout() async{
    await _auth.signOut().whenComplete((){
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (context) => Login(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                      return Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => TambahKK(firebaseUser: widget.firebaseUser),
                      ));
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

}