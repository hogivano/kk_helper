import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kk_helper/routes/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kk_helper/routes/dashboard.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    new Timer(new Duration(milliseconds: 5000), () async {
      FirebaseUser _user = await _auth.currentUser();
      if (_user != null){
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) => Dashboard(
            firebaseUser: _user,
          ),
        ));
      } else {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => Register()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: new Color(0xFF6ecce2)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Color(0xFF6ecce2),
                                radius: 50.0,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15.0)
                              ),
                              Text(
                                "KK Helper",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                ),
                              ),
                            ],
                          ),
                        )
                    )
                  ],
                ),
              )
            ]
        )
    );
  }
}

