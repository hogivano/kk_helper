import 'package:firebase_database/firebase_database.dart';
class Users {
  String _key;
  String _noTelp;
  String _nama;
  String _image;
  String _email;
  int _role;

  Users (){
    this._key = "";
    this._noTelp = "";
    this._nama = "";
    this._email = "";
    this._image = "";
    this._role = -1;
  }

  String get Key => _key;
  String get noTelp => _noTelp;
  String get nama => _nama;
  String get email => _email;
  String get image => _image;
  int get role => _role;

  set setKey(String key) => this._key = key;
  set setNoTelp(String noTelp) => this._noTelp = noTelp;
  set setNama(String nama) => this._nama = nama;
  set setEmail(String email) => this._email = email;
  set setImage(String image) => this._image = image;
  set setRole(int role) => this._role = role;

  Users.map(dynamic obj){
    this._key = obj['key'];
    this._noTelp = obj['noTelp'];
    this._nama = obj['nama'];
    this._email = obj['email'];
    this._image = obj['image'];
    this._role = obj['role'];
  }

  Users.fromJsonWithKey(Map<String, dynamic> json) :
        _key = json['key'],
        _nama = json['nama'],
        _noTelp = json['noTelp'],
        _email = json['email'],
        _image = json['image'],
        _role = json['role'];

  Users.fromJsonNotKey(Map<String, dynamic> json) :
        _nama = json['nama'],
        _noTelp = json['noTelp'],
        _email = json['email'],
        _image = json['image'],
        _role = json['role'];

  Map<String, dynamic> toJsonWithKey() =>
      {
        'key': _key,
        'noTelp' : _noTelp,
        'email': _email,
        'nama' : _nama,
        'image' : _image,
        'role' : role,
      };

  Map<String, dynamic> toJsonNotKey() =>
      {
        'noTelp' : _noTelp,
        'email': email,
        'nama' : _nama,
        'image' : _image,
        'role' : role,
      };

  Users.fromSnapshot(DataSnapshot snapshot) {
    _key = snapshot.key;
    _noTelp = snapshot.value['noTelp'];
    _nama = snapshot.value['nama'];
    _email = snapshot.value['email'];
    _image = snapshot.value['image'];
    _role = snapshot.value['role'];
  }
}