import 'package:flutter/material.dart';

class PhoneIconBtn extends StatelessWidget{
  final Function onPressed;

  PhoneIconBtn({
    Key key, this.onPressed,
  }) : super (key : key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: new IconButton(
          icon: new Icon(
            Icons.phone,
            color: Colors.blue,
          ),
          onPressed: this.onPressed,
          splashColor: Colors.black38,
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
    );
  }

}