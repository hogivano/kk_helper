import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KurangAnggota extends StatefulWidget{
  final FirebaseUser firebaseUser;
  const KurangAnggota({Key key, @required this.firebaseUser})
      :assert(firebaseUser != null),
        super(key : key);
  @override
  State<StatefulWidget> createState() => new _kurangAnggotaState();
}

class _kurangAnggotaState extends State<KurangAnggota>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Text("cokicoki");
  }
}