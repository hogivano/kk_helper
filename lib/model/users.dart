import 'package:firebase_database/firebase_database.dart';
class Users {
  String _key;
  String _noTelp;
  String _nama;
  String _image;
  String _email;
  int _role;
  Users (this._key, this._noTelp, this._nama, this._email, this._image, this._role);

  String get Key => _key;
  String get noTelp => _noTelp;
  String get nama => _nama;
  String get email => _email;
  String get image => _image;
  int get role => _role;

  Users.map(dynamic obj){
    this._key = obj['key'];
    this._noTelp = obj['noTelp'];
    this._nama = obj['nama'];
    this._email = obj['email'];
    this._image = obj['image'];
    this._role = obj['role'];
  }

  Users.fromSnapshot(DataSnapshot snapshot) {
    _key = snapshot.key;
    _noTelp = snapshot.value['noTelp'];
    _nama = snapshot.value['nama'];
    _email = snapshot.value['email'];
    _image = snapshot.value['image'];
    _role = snapshot.value['role'];
  }
}