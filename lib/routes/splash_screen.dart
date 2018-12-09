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
                decoration: BoxDecoration(
                  gradient:  LinearGradient(
                      colors: [Color(0xff1fb6f7), Color(0xFF35ade0), Color(0xff20b7f7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Image.asset(
                                "assets/image/kk-helper.png",
                                width: MediaQuery.of(context).size.width / 2,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 25.0)
                              ),
                              Text(
                                "KK Helper Surabaya",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
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

