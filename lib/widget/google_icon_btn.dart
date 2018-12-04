import 'package:flutter/material.dart';

class GoogleIconBtn extends StatelessWidget{
  final Function onTap;

  GoogleIconBtn({
    Key key,
    this.onTap,
  }) : super (key : key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new GestureDetector(
      onTap: this.onTap,
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        padding: const EdgeInsets.all(10.0),
        child: new CircleAvatar(
          backgroundImage: new AssetImage("assets/image/gologo.png"),
          radius: 14.0,
        ),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.all(Radius.circular(100)),
            boxShadow: [
              new BoxShadow(
                blurRadius: 1.0,
                offset: Offset(1, 2),
                color: Colors.black54,
              )
            ]),
      ),
    );
  }

}