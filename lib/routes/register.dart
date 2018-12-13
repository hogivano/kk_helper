import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kk_helper/routes/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kk_helper/logger.dart';
import 'package:kk_helper/model/users.dart';
import 'package:kk_helper/routes/dashboard.dart';
import 'package:kk_helper/widget/google_sign_in_btn.dart';
import 'package:flutter/services.dart';
import 'package:kk_helper/widget/email_icon_btn.dart';
import 'package:kk_helper/widget/google_icon_btn.dart';
import 'package:kk_helper/widget/phone_icon_btn.dart';
import 'package:fluttertoast/fluttertoast.dart';

class _RegisterState extends State<Register> {
  static const String TAG = "AUTH";
  AuthStatus status = AuthStatus.PHONE_AUTH;

  var kecamatan = [
    "Asemrowo",
    "Benowo",
    "Bubutan",
    "Bulak",
    "Dukuh Pakis",
    "Gayungan",
    "Genteng",
    "Gubeng",
    "Gunung Anyar",
    "Jambangan",
    "Karang Pilang",
    "Kenjeran",
    "Krembangan",
    "Lakarsantri",
    "Mulyorejo",
    "Pabean Cantikan",
    "Pakal",
    "Rungkut",
    "Sambikerep",
    "Sawahan",
    "Semampir",
    "Simokerto",
    "Sukolilo",
    "Sukomanunggal",
    "Tambaksari",
    "Tandes",
    "Tegalsari",
    "Tenggilis Mejoyo",
    "Wiyung",
    "Wonocolo",
    "Wonokromo"
  ];
  var kelurahan = [
    ["Asemrowo", "Genting Kalianak", "Tambak Sarioso"],
    ["Kandangan", "Romokalisari", "Sememi", "Tambak Oso Wilangon"],
    ["Alon-Alon Contong", "Bubutan", "Gundih", "Jepara", "Tembok Dukuh"],
    ["Bulak", "Kedung Cowek", "Kenjeran", "Sukolilo Baru"],
    ["Dukuh Kupang", "Dukuh Pakis", "Gunungsari", "Pradahkali Kendal"],
    ["Dukuh Menanggal", "Gayungan", "Ketintang", "Menanggal"],
    ["Embong Kaliasin", "Genteng", "Kapasari", "Ketabang", "Peneleh"],
    ["Airlangga", "Baratajaya", "Gubeng", "Kertajaya", "Mojo", "Pucang Sewu"],
    [
      "Gunung Anyar",
      "Gunung Anyar Tambak",
      "Rungkut Menanggal",
      "Rungkut Tengah"
    ],
    ["Pagesangan", "Kebonsari", "Jambangan", "Karah"],
    ["Kedurus", "Kebraon", "Warugunung", "Karang Pilang"],
    ["Bulakbanteng", "Tambakwedi", "Tanah Kalikedinding", "Sidotopo Wetan"],
    [
      "Dupak",
      "Krembangan Selatan",
      "Kemayoran",
      "Perak Barat",
      "Morokrembangan"
    ],
    [
      "Bangkingan",
      "Jeruk",
      "Lakarsantri",
      "Lidah Kulon",
      "Lidah Wetan",
      "Sumur Welut"
    ],
    [
      "Kalijudan",
      "Mulyorejo",
      "Kalisari",
      "Dukuh Sutorejo",
      "Kejawan Putih Tambak",
      "Manyar Sabrangan"
    ],
    [
      "Bongkaran",
      "Nyamplungan",
      "Krembangan Utara",
      "Perak Timur",
      "Perak Utara"
    ],
    ["Babat Jerawat", "Pakal", "Sumberejo"],
    [
      "Kedungbaruk",
      "Wonorejo",
      "Medokanayu",
      "Rungkut Kidul",
      "Kali Rungkut",
      "Penjaringansari"
    ],
    ["Benowo", "Bringin", "Made", "Lontar", "Sambikerep"],
    ["Patemon", "Sawahan", "Kupangkrajan", "Banyuurip", "Putat Jaya", "Pakis"],
    ["Ampel", "Pegirian", "Sidotopo", "Ujung", "Wonokromo"],
    ["Simokerto", "Kapasan", "Sidodadi", "Simolawang", "Tambakrejo"],
    [
      "Keputih",
      "Gebang Putih",
      "Menur Pumpungan",
      "Nginden Jangkungan",
      "Semolowaru",
      "Medokan Semampir",
      "Klampisngasem"
    ],
    [
      "Simomulyo",
      "Sukomanunggal",
      "Tanjungsari",
      "Sono Kuwijenan",
      "Putatgede",
      "Simomulyo Baru"
    ],
    [
      "Tambaksari",
      "Ploso",
      "Rangkah",
      "Pacar Kembang",
      "Gading",
      "Pacar Keling",
      "Dukuh Setro",
      "Kapas Madya"
    ],
    [
      "Tandes",
      "Karang Poh",
      "Balongsari",
      "Manukan Wetan",
      "Manukan Kulon",
      "Banjar Sugihan"
    ],
    ["Kedungdoro", "Keputran", "Tegalsari", "Dr. Sutomo", "Wonorejo"],
    ["Tenggilis Mejoyo", "Panjang Jiwo", "Kendangsari", "Kutisari"],
    ["Babatan", "Balasklumprik", "Jajar Tunggal", "Wiyung"],
    [
      "Sidosermo",
      "Bendul Merisi",
      "Margorejo",
      "Jemur Wonosari",
      "Siwalan Kerto"
    ],
    ["Ngagel", "Ngagelrejo", "Darmo", "Sawunggaling", "Wonokromo", "Jagir"]
  ];

  final TextEditingController _noTelpController = new TextEditingController();
  final TextEditingController _namaLengkapController =
      new TextEditingController();
  final TextEditingController _smsCodeController = new TextEditingController();

  final TextEditingController _namaMailController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _rePasswordController =
      new TextEditingController();

  final FocusNode _noTelpFocus = new FocusNode();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInAccount _googleUser;

  Duration _timeOut = const Duration(minutes: 2);
  String _verificationId;
  bool _codeTimer = false;
  bool _codeTimedOut = false;
  bool _codeVerified = false;
  bool _onSubmit = false;
  String noTelp = "";
  String namaLengkap = "";

  String get phoneNumber {
    String number = null;
    if (_noTelpController.text.length > 0) {
      number = _noTelpController.text.replaceRange(0, 1, "+62");
    }
    return number;
  }

  // PhoneCodeSent
  codeSent(String verificationId, [int forceResendingToken]) async {
    Timer(_timeOut, () {
      setState(() {
        _codeTimedOut = true;
        _onSubmit = false;
      });
    });
    _codeTimer = true;

    setState(() {
      this._verificationId = verificationId;
      Logger.log(TAG, message: "Changed status to okee");
    });
  }

  // PhoneVerificationCompleted
  verificationCompleted(FirebaseUser user) async {
    Logger.log(TAG, message: "onVerificationCompleted, user: $user");
    Logger.log(TAG, message: user.hashCode.toString());
    if (await _onCodeVerified(user)) {
//      await _finishSignIn(user);
      DatabaseReference database = _database.reference().child("user").push();
      database.set({
        'noTelp': user.phoneNumber,
        'nama': namaLengkap,
        'email': '',
        'image': '',
        'role': 0,
      });
      Logger.log(TAG, message: "code verifed true");
    } else {
      setState(() {
        Logger.log(TAG, message: "Changed status to state");
      });
    }
    setState(() {
      _onSubmit = false;
//      status = AuthStatus.SMS_AUTH;
    });
    _navigationToDashboard(user);
  }

  Future<bool> _onCodeVerified(FirebaseUser user) async {
    final isUserValid = (user != null &&
        (user.phoneNumber != null && user.phoneNumber.isNotEmpty));
    if (isUserValid) {
//      _database.reference().child("users").push().set(new Users(user.phoneNumber, "hendriyan"));
      setState(() {
        _verificationId = user.uid;
        Logger.log(TAG, message: "Changed status to falid");
      });
    } else {
      showInSnackBar("We couldn't verify your code, please try again!");
    }
    return isUserValid;
  }

  // PhoneVerificationFailed
  verificationFailed(AuthException authException) {
    setState(() {
      _onSubmit = false;
    });
    showInSnackBar("We couldn't verify your code for now, please try again!");
    Logger.log(TAG,
        message:
            'onVerificationFailed, code: ${authException.code}, message: ${authException.message}');
  }

  // PhoneCodeAutoRetrievalTimeout
  codeAutoRetrievalTimeout(String verificationId) {
    setState(() {
      this._verificationId = verificationId;
      this._codeTimedOut = true;
      this._onSubmit = false;
    });
  }

  void _verifyPhoneNumber() {
    Logger.log(TAG, message: "Got phone number as: ${this.phoneNumber}");
    _database.reference().child("user").once().then((DataSnapshot snapshot) {
      bool cekUser = false;
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, value) {
          if (value["noTelp"] == this.phoneNumber) {
            cekUser = true;
          }
        });
      }
      if (cekUser) {
        showInSnackBar("no telp sudah terdaftar silahkan untuk login");
        setState(() {
          _onSubmit = false;
        });
      } else {
        _authVerifyPhone();
      }
    }).catchError((error) {
      setState(() {
        _onSubmit = false;
      });
      showInSnackBar(error.toString());
    });
  }

  Future<Null> _authVerifyPhone() async {
    await _auth.verifyPhoneNumber(
        phoneNumber: this.phoneNumber,
        timeout: _timeOut,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed);
    return null;
  }

  Future<Null> _submitSmsCode() async {
    final error = null;
    if (error != null) {
      showInSnackBar(error);
      return null;
    } else {
      if (this._codeVerified) {
        await _finishSignIn(await _auth.currentUser());
      } else {
        Logger.log(TAG, message: "_signInWithPhoneNumber called");
        await _signInWithPhoneNumber();
      }
      return null;
    }
  }

  _finishSignIn(FirebaseUser user) async {
    await _onCodeVerified(user).then((result) {
      if (result) {
        // Here, instead of navigating to another screen, you should do whatever you want
        // as the user is already verified with Firebase from both
        // Google and phone number methods
        // Example: authenticate with your own API, use the data gathered
        // to post your profile/user, etc.

        _navigationToDashboard(user);
        setState(() {
          _onSubmit = false;
        });
      } else {
        setState(() {
          this.status = AuthStatus.SMS_AUTH;
        });
        showInSnackBar(
            "We couldn't create your profile for now, please try again later");
      }
    });
  }

  Future<void> _signInWithPhoneNumber() async {
    showInSnackBar(_verificationId);
    final errorMessage = "We couldn't verify your code, please try again!";
    await _auth
        .signInWithPhoneNumber(
            verificationId: _verificationId, smsCode: _smsCodeController.text)
        .then((user) async {
      await _onCodeVerified(user).then((codeVerified) async {
        this._codeVerified = codeVerified;
        Logger.log(
          TAG,
          message: "Returning ${this._codeVerified} from _onCodeVerified",
        );
        if (this._codeVerified) {
          await _finishSignIn(user);
        } else {
          showInSnackBar(errorMessage);
        }
        setState(() {
          _onSubmit = false;
        });
      });
    }, onError: (error) {
      setState(() {
        _onSubmit = false;
      });
      print("Failed to verify SMS code: $error");
      showInSnackBar(errorMessage);
    });
  }

  Future<Null> _signUpUsingGoogle() async {
    GoogleSignInAccount user = _googleSignIn.currentUser;

    if (user == null) {
      await _googleSignIn.signIn().then((account) {
        user = account;
        _database
            .reference()
            .child("user")
            .once()
            .then((DataSnapshot snapshot) {
          bool cekUser = false;
          Map<dynamic, dynamic> values = snapshot.value;
          if (values != null) {
            values.forEach((key, value) {
              if (value["email"] == user.email) {
                cekUser = true;
              }
            });
          }
          if (cekUser) {
            Fluttertoast.showToast(
              msg:
                  "email sudah terdaftar silahkan untuk login menggunakan icon gmail",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 2,
            );
//            showInSnackBar(
//                "email sudah terdaftar silahkan untuk login menggunakan icon gmail");
//            setState(() {
//              _onSubmit = false;
//            });
          } else {
            account.authentication.then((google) {
              _auth
                  .signInWithGoogle(
                      idToken: google.idToken, accessToken: google.accessToken)
                  .then((user) {
                DatabaseReference database =
                    _database.reference().child("user").push();
                database.set({
                  'noTelp': '',
                  'nama': user.displayName,
                  'email': user.email,
                  'image': user.photoUrl,
                  'role': 0,
                });
                setState(() {
                  _onSubmit = false;
                });
                _navigationToDashboard(user);
              }, onError: (error) {
                showInSnackBar("gagal silahkan coba lagi");
              });
            }, onError: (error) {
              showInSnackBar("gagal untuk registrasi menggunakan google");
            });
          }
        }).catchError((error) {
          showInSnackBar(error.toString());
        });
      }, onError: (error) {
        showInSnackBar("Tidak bisa daftar dengan google akun, coba lagi");
      });
    } else {
//      showInSnackBar(user.displayName + user.email + user.photoUrl);
    }
    setState(() {
      _onSubmit = false;
    });
  }

  void onChangeNoTelp() {
    String text = _noTelpController.text.trim();
    bool hasFocus = _noTelpFocus.hasFocus;

    if (text.length > 0) {
      if (text.substring(0, 1) != '0') {
        print("awalan 0");
        _noTelpController.clear();
      } else if (text.length > 1) {
        if (text.substring(1, 2) != '8') {
          print("awalan 8");
          _noTelpController.clear();
        }
      }
    }
    print(phoneNumber);
  }

  void _submitRegister() {
    if (status == AuthStatus.PHONE_AUTH) {
      if (!_onSubmit) {
        if (_noTelpController.text.isEmpty) {
          showInSnackBar("no telp harus diisi");
        } else if (_namaLengkapController.text.isEmpty) {
          showInSnackBar("nama lengkap harus diisi");
        } else {
          setState(() {
            namaLengkap = _namaLengkapController.text;
            _onSubmit = true;
          });
          _verifyPhoneNumber();
        }
      }
    } else if (status == AuthStatus.SMS_AUTH) {
      if (!_onSubmit) {
        if (_smsCodeController.text.isEmpty) {
          showInSnackBar("code sms harus diisi");
        } else if (_smsCodeController.text.length > 6 ||
            _smsCodeController.text.length < 6) {
          showInSnackBar("code hanya 6 digit");
        } else {
          setState(() {
            _onSubmit = true;
          });
          _submitSmsCode();
        }
      }
    } else if (status == AuthStatus.EMAIL_AUTH) {
      if (!_onSubmit) {
        if (_namaMailController.text.isEmpty ||
            _emailController.text.isEmpty ||
            _passwordController.text.isEmpty ||
            _rePasswordController.text.isEmpty) {
          showInSnackBar("semua harus diisi");
        } else {
          if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(_emailController.text)) {
            showInSnackBar("format email example@example.com");
          } else if (_passwordController.text == _rePasswordController.text) {
            if (_passwordController.text.length < 8) {
              showInSnackBar("minimal kata sandi 8 digit");
            } else {
              setState(() {
                _onSubmit = true;
              });
              _registerWithEmail();
            }
          } else {
            showInSnackBar("kata sandi tidak sama");
          }
        }
      }
    }
  }

  void _registerWithEmail() {
    _database.reference().child("user").once().then((DataSnapshot snapshot) {
      bool cekUser = false;
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, value) {
          if (value["email"] == _emailController.text) {
            cekUser = true;
          }
        });
      }
      if (cekUser) {
        showInSnackBar("email sudah terdaftar silahkan untuk login");
        setState(() {
          _onSubmit = false;
        });
      } else {
        _auth
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text)
            .then((user) {
          user.sendEmailVerification().then((e) {
            DatabaseReference database =
                _database.reference().child("user").push();
            database.set({
              'noTelp': '',
              'nama': _namaMailController.text,
              'email': _emailController.text,
              'image': '',
              'role': 0,
            }).then((user) {
              setState(() {
                _onSubmit = false;
              });
              Fluttertoast.showToast(
                  msg: "pendaftaran akun telah berhasil silahkan cek email untuk verifikasi", toastLength: Toast.LENGTH_LONG);
              Navigator.of(context).pushReplacement(
                  new MaterialPageRoute(builder: (context) => Login()));
            }).catchError((e) {
              setState(() {
                _onSubmit = false;
              });
              Fluttertoast.showToast(
                  msg:
                      "gagal mendaftarkan silahkan register dengan no telp atau google mail");
            });
          }).catchError((e) {
            setState(() {
              _onSubmit = false;
            });
            Fluttertoast.showToast(msg: "email tidak valid");
          });
        }).catchError((e) {
          setState(() {
            _onSubmit = false;
          });
          Fluttertoast.showToast(
              msg: "email sudah terdaftar silahkan untuk login");
        });
      }
    }).catchError((error) {
      setState(() {
        _onSubmit = false;
      });
      showInSnackBar(error.toString());
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: new Duration(milliseconds: 1000),
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 13.0),
      ),
      backgroundColor: Colors.black87,
    ));
  }

  String namedButton() {
    if (this.status != AuthStatus.SMS_AUTH) {
      return "Register";
    } else if (this.status == AuthStatus.SMS_AUTH) {
      return "Kirim Kode";
    }
  }

  void _onPressPhoneBtn() {
    setState(() {
      status = AuthStatus.PHONE_AUTH;
    });
  }

  void _onPressEmailBtn() {
    setState(() {
      status = AuthStatus.EMAIL_AUTH;
    });
  }

  void _onPressGmailBtn() {
    setState(() {
//      status = AuthStatus.GMAIL_AUTH;
      _onSubmit = true;
    });
    _signUpUsingGoogle();
  }

  @override
  void initState() {
    // TODO: implement initState
    _noTelpController.addListener(onChangeNoTelp);
    _noTelpFocus.addListener(onChangeNoTelp);
    super.initState();
  }

  //Alternative Register
  List<Widget> _buildBtnAlternativeRegister() {
    List<Widget> list = new List<Widget>();
    if (this.status == AuthStatus.EMAIL_AUTH) {
      list.add(new PhoneIconBtn(onPressed: _onPressPhoneBtn));
      list.add(new GoogleIconBtn(onTap: _onPressGmailBtn));
    } else if (this.status == AuthStatus.PHONE_AUTH) {
      list.add(new EmailIconBtn(onPressed: _onPressEmailBtn));
      list.add(new GoogleIconBtn(onTap: _onPressGmailBtn));
    } else if (this.status == AuthStatus.GMAIL_AUTH) {
      list.add(new GoogleIconBtn(onTap: _onPressGmailBtn));
    }

    return list;
  }

  void _navigationToDashboard(FirebaseUser user) {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
      builder: (context) => Dashboard(
            firebaseUser: user,
          ),
    ));
  }

  //Widget
  Widget _switchWidget() {
    if (this.status == AuthStatus.PHONE_AUTH) {
      return _buildInputRegister();
    } else if (this.status == AuthStatus.SMS_AUTH) {
      return _buildInputSmsCode();
    } else if (this.status == AuthStatus.PROFILE_AUTH) {
    } else if (this.status == AuthStatus.EMAIL_AUTH) {
      return _buildInputEmail();
    } else if (this.status == AuthStatus.GMAIL_AUTH) {}
  }

  Widget _buildInputEmail() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Align(
          alignment: Alignment.centerRight,
          child: new Container(
            width: MediaQuery.of(context).size.width / 1,
            margin: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
            child: new Material(
              elevation: 4,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: new Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: new TextFormField(
                  controller: _namaMailController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: 10.0,
                    ),
                    hintText: "nama lengkap",
                    border: InputBorder.none,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey,
                      )
                    ]),
              ),
            ),
          ),
        ),
        new Align(
          alignment: Alignment.centerRight,
          child: new Container(
            width: MediaQuery.of(context).size.width / 1,
            margin: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
            child: new Material(
              elevation: 4,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: new Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: new TextFormField(
                  controller: _emailController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                  validator: (value) {
                    value.isEmpty
                        ? print("email adress harus diisi")
                        : print("email address sudah diisi");
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: new InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: 10.0,
                    ),
                    hintText: "alamat email",
                    border: InputBorder.none,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey,
                      )
                    ]),
              ),
            ),
          ),
        ),
        new Align(
          alignment: Alignment.centerRight,
          child: new Container(
            width: MediaQuery.of(context).size.width / 1,
            margin: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
            child: new Material(
              elevation: 4,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: new Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: new TextFormField(
                  controller: _passwordController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                  validator: (value) {
                    value.isEmpty
                        ? print("password harus diisi")
                        : print("password sudah diisi");
                  },
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: new InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: 10.0,
                    ),
                    hintText: "kata sandi",
                    border: InputBorder.none,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey,
                      )
                    ]),
              ),
            ),
          ),
        ),
        new Align(
          alignment: Alignment.centerRight,
          child: new Container(
            width: MediaQuery.of(context).size.width / 1,
            margin: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
            child: new Material(
              elevation: 4,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: new Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: new TextFormField(
                  controller: _rePasswordController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                  validator: (value) {
                    value.isEmpty
                        ? print("re-password harus diisi")
                        : print("re-password sudah diisi");
                  },
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: new InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: 10.0,
                    ),
                    hintText: "ulangi kata sandi",
                    border: InputBorder.none,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey,
                      )
                    ]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputProfile() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[new Align()],
    );
  }

  Widget _buildInputSmsCode() {
    return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Align(
            alignment: Alignment.center,
            child: new Text(
              "Kode :",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
              ),
            ),
          ),
          new Align(
            alignment: Alignment.centerRight,
            child: new Container(
              width: MediaQuery.of(context).size.width / 1,
              margin: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
              child: new Material(
                elevation: 4,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: new Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: new TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _smsCodeController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                    validator: (value) {
                      value.isEmpty
                          ? print("sms code harus diisi")
                          : print("asas");
                    },
                    decoration: new InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 10.0,
                      ),
                      hintText: "XXXXXX",
                      border: InputBorder.none,
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.grey,
                        )
                      ]),
                ),
              ),
            ),
          ),
        ]);
  }

  Widget _buildInputRegister() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Align(
          alignment: Alignment.centerRight,
          child: new Container(
            width: MediaQuery.of(context).size.width / 1,
            margin: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
            child: new Material(
              elevation: 4,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: new Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: new TextFormField(
                  controller: _noTelpController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                  validator: (value) {
                    value.isEmpty
                        ? print("no telp harus diisi")
                        : print("asas");
                  },
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: 10.0,
                    ),
                    hintText: "No. telepon",
                    border: InputBorder.none,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey,
                      )
                    ]),
              ),
            ),
          ),
        ),
        new Align(
          alignment: Alignment.centerRight,
          child: new Container(
            width: MediaQuery.of(context).size.width / 1,
            margin: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
            child: new Material(
              elevation: 4,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: new Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: new TextFormField(
                  controller: _namaLengkapController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                  decoration: new InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: 10.0,
                    ),
                    hintText: "Nama Lengkap",
                    border: InputBorder.none,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey,
                      )
                    ]),
              ),
            ),
          ),
        ),
//        new Align(
//          alignment: Alignment.center,
//          child: new Container(
//            width: MediaQuery.of(context).size.width / 1,
//            margin: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
//            child: new Material(
//              elevation: 4,
//              borderRadius: BorderRadius.all(Radius.circular(30)),
//              child: new Container(
//                width: MediaQuery.of(context).size.width / 1.5,
//                child: new DropdownButtonHideUnderline(
//                  child: new DropdownButton(
//                    hint: new Text(
//                      "Kelurahan",
//                      style: TextStyle(
//                          fontSize: 10.0
//                      ),
//                      textAlign: TextAlign.center,
//                    ),
//                    items: kecamatan.map((String value) {
//                      return new DropdownMenuItem<String>(
//                        value: value,
//                        child: new Text(value),
//                      );
//                    }).toList(),
//                    style: new TextStyle(
//                        fontSize: 14.0,
//                        color: Colors.black54,
//                    ),
//                    onChanged: (_) {},
//                  ),
//                ),
//                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 15.0, 0.0),
//                decoration: new BoxDecoration(
//                    color: Colors.white,
//                    borderRadius: BorderRadius.all(Radius.circular(30)),
//                    boxShadow: [
//                      new BoxShadow(
//                        color: Colors.grey,
//                      )
//                    ]
//                ),
//              ),
//            ),
//          ),
//        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Material(
      type: MaterialType.transparency,
      child: new SafeArea(
          child: new Stack(
        alignment: AlignmentDirectional.topStart,
        fit: StackFit.loose,
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/image/bg-register-color.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          new Container(
            alignment: Alignment(0.75, -0.5),
            child: new Text(
              "REGISTER",
              style: new TextStyle(
                fontSize: 25.0,
                foreground: Paint()..shader = linearGradient,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          new Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            body: _switchWidget(),
          ),
          new Container(
            alignment: Alignment(0.0, 0.45),
            child: new RaisedButton(
              onPressed: _submitRegister,
              color: Theme.of(context).accentColor,
              splashColor: Colors.white10,
              elevation: 4,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              padding: const EdgeInsets.fromLTRB(80.0, 10.0, 80.0, 10.0),
              child: Text(
                namedButton(),
                style: new TextStyle(
                    color: Colors.white70,
                    fontSize: 13.0,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none),
              ),
            ),
          ),
          new Container(
              alignment: Alignment(0.0, 0.53),
              child: new GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(builder: (context) => Login()));
//                      Navigator.popAndPushNamed(context, '/screen1': (BuildContext context) => new Login());
                },
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      "Sudah memiliki akun? ",
                      style: new TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.black38),
                    ),
                    new Text(
                      "Login",
                      style: new TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.normal,
                        foreground: Paint()..shader = linearGradient,
                      ),
                    ),
                  ],
                ),
              )),
          new Container(
              alignment: Alignment(0.0, 0.85),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: new Text(
                      "Register via:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: new Color(0xffcccccc), fontSize: 11.0),
                    ),
                  ),
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildBtnAlternativeRegister(), //btnNavigation
                  ),
                ],
              )),
          new Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: _onSubmit
                ? new SizedBox(
                    child: new CircularProgressIndicator(
                      strokeWidth: 3.0,
                    ),
                    height: 50.0,
                    width: 50.0,
                  )
                : new Visibility(child: new Text("visible"), visible: false),
          ),
        ],
      )),
    );
  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xff66dbff), Color(0xff3ab9e0), Color(0xff168baf)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
}

enum AuthStatus { GMAIL_AUTH, EMAIL_AUTH, PHONE_AUTH, SMS_AUTH, PROFILE_AUTH }

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterState();
}
