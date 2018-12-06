import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TambahAnggota extends StatefulWidget{
  final FirebaseUser firebaseUser;
  const TambahAnggota({Key key, @required this.firebaseUser})
      :assert(firebaseUser != null),
        super(key : key);

  @override
  State<StatefulWidget> createState() => new _tambahAnggotaState();
}

class _tambahAnggotaState extends State<TambahAnggota>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Text("omiomi");
  }
}