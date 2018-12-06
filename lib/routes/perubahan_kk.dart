import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PerubahanKK extends StatefulWidget{
  final FirebaseUser firebaseUser;
  const PerubahanKK({Key key, @required this.firebaseUser})
      :assert(firebaseUser != null),
        super(key : key);
  @override
  State<StatefulWidget> createState() => new _PerubahanKKState();
}

class _PerubahanKKState extends State<PerubahanKK>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Text("rubahhh KKKU");
  }
}