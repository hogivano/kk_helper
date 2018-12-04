import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kk_helper/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kk_helper/widget/masked_text.dart';
import 'package:kk_helper/widget/reactive_refresh_indicator.dart';
import 'dart:ui';

class Login_coba extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoginState();
}

enum AuthStatus { SOCIAL_AUTH, PHONE_AUTH, SMS_AUTH, PROFILE_AUTH }

class _LoginState extends State<StatefulWidget>{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static const String TAG = "AUTH";
  AuthStatus status = AuthStatus.PHONE_AUTH;

  //keys
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<MaskedTextFieldState> _maskedPhoneKey = GlobalKey<MaskedTextFieldState>();

  TextEditingController smsCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String _errorMessage;
  String _verificationId;
  Timer _codeTimer;

  bool _isRefreshing = false;
  bool _codeTimeOut = false;
  bool _codeVerifed = false;
  Duration _timeOut = const Duration(minutes: 1);

  final decorationStyle = TextStyle(color: Colors.grey[50], fontSize: 16.0);
  final hintStyle = TextStyle(color: Colors.white24);

  verificationCompleted(FirebaseUser user) async {
    Logger.log(TAG, message: "on VerificationComplete, user: $user");

  }

  String get phoneNumber {
    String unmaskText = _maskedPhoneKey.currentState.unmaskedText;
    String formatted = "+62$unmaskText".trim();
    return formatted;
  }

  Future<Null> _verifyPhoneNumber() async {
    Logger.log(TAG, message: "Got number phone as: ${this.phoneNumber}");
  }

  //phone send code
  codeSent(String verificationId, [int forceResendingToken]) async {
    Logger.log(TAG,
        message:
        "Verification code sent to number ${phoneNumberController.text}");
    _codeTimer = Timer(_timeOut, (){
      setState(() {
        _codeTimeOut = true;
      });
    });
    _updateRefreshing(false);
    setState(() {
      this._verificationId = verificationId;
      this.status = AuthStatus.SMS_AUTH;
      Logger.log(TAG, message: "Changed status to $status");
    });
  }

  //
  Future<bool> _onCodeVerified(FirebaseUser user) async {
    final isUserValid = (user != null && user.phoneNumber != null && user.phoneNumber.isNotEmpty);
    if (isUserValid){
      setState(() {
        this.status = AuthStatus.PROFILE_AUTH;
        Logger.log(TAG, message: "Changed status to $status");
      });
    } else {
      _showErrorSnackbar("Tidak bisa membaca verifikasi code");
    }

    return isUserValid;
  }

  void _showErrorSnackbar(String s) {
    _updateRefreshing(false);
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(s)),
    );
  }

  Future<Null> _updateRefreshing(bool isRefreshing) async {
    Logger.log(TAG, message: "Setting _isRefreshing  ($_isRefreshing) to $isRefreshing");
    if (_isRefreshing){
      setState(() {
        this._isRefreshing =false;
      });
    }

    setState(() {
      this._isRefreshing = isRefreshing;
    });
  }

  Future<void> signInWithPhoneNumber() async {
    final errorMessage = "tidak bisa verifikasi kode, coba lagi!!";
    await _firebaseAuth.signInWithPhoneNumber(verificationId: _verificationId, smsCode: smsCodeController.text)
      .then((user) async{
        await _onCodeVerified(user).then((codeVerifed) async {
          this._codeVerifed = codeVerifed;
          Logger.log(TAG, message: "pengembalian ${this._codeVerifed} from _onCodeVerifed");
          if (this._codeVerifed){
            await _finishSignIn(user);
          } else {
            _showErrorSnackbar(errorMessage);
          }
        });
    }, onError: (error) {
      print("faild verifed sms code");
      _showErrorSnackbar(errorMessage);
    });
  }

  _finishSignIn(FirebaseUser user) async {
    await _onCodeVerified(user).then((result) {
      if (result) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text("berhasil finish")),
        );
      } else {
        setState(() {
          this.status = AuthStatus.SMS_AUTH;
        });
        
        _showErrorSnackbar("We couldn't create your profile for now, please try again later");
      }
    });
  }

  String _phoneInputValidator(){
    if (phoneNumberController.text.isEmpty){
      return "Phone number kosong";
    } else if (phoneNumberController.text.length < 10){
      return "Phone number tidak boleh kurang dari 10 digit";
    } else if (phoneNumberController.text.length > 13){
      return "Phone number tidak boleh lebih dari 13 digit";
    }
    return null;
  }

  String _smsCodeValidator(){
    if (smsCodeController.text.isEmpty){
      return "Sms code kosong";
    } else if (smsCodeController.text.length < 6){
      return "Sms code kurang dari 6 digit";
    }
    return null;
  }


  Future<Null> _signIn() async {
    Logger.log(TAG, message: "Just got user as: phone");
  }


  Future<Null> _onRefresh() async {
//    switch (this.status){
//      case AuthStatus.PHONE_AUTH:
//        return await _signIn();
//        break;
//      case AuthStatus.SMS_AUTH:
//        return await _submitSmsCode();
//        break;
//      case AuthStatus.PROFILE_AUTH:
//        break;
//    }
  }


  //Widget
  Widget _widgetLogin(){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Ini App Bar"),
        backgroundColor: Color(0xFF000000),
      ),
      body: new Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              new TextField(
                controller: phoneNumberController,
                decoration: new InputDecoration.collapsed(
                  hintText: "phone number",
                ),
                keyboardType: TextInputType.numberWithOptions(),
              ),
              new TextField(
                controller: smsCodeController,
                decoration: new InputDecoration.collapsed(
                    hintText: "sms code verification",
                ),
              ),
            ],
          )
      ),
    );
  }

  Widget _buildConfirmInputButton(){
    final theme = Theme.of(context);
    return IconButton(
      icon: Icon(Icons.check),
      color: theme.accentColor,
      disabledColor: theme.buttonColor,
      onPressed: (this.status == AuthStatus.PROFILE_AUTH)
            ? null : () => _updateRefreshing(true),
    );
  }

  Widget _buildPhoneNumberInput(){
    return MaskedTextField(
      key: _maskedPhoneKey,
      mask: "xxx-xxxx-xxxx",
      keyboardType: TextInputType.number,
      maskedTextFieldController: phoneNumberController,
      maxLength: 13,
      onSubmitted: (text) => _updateRefreshing(true),
      style: Theme
          .of(context)
          .textTheme
          .subhead
          .copyWith(fontSize: 18.0, color: Colors.white),
      inputDecoration: InputDecoration(
        counterText: "",
        enabled: this.status == AuthStatus.PHONE_AUTH,
        icon: const Icon(
          Icons.phone,
          color: Colors.white,
        ),
        labelText: "Phone",
        labelStyle: decorationStyle,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  }

  Widget _buildPasswordInput(){
    return MaskedTextField(
    key: _maskedPhoneKey,
    mask: "xxx-xxxx-xxxx",
    keyboardType: TextInputType.number,
    maskedTextFieldController: passwordController,
    maxLength: 13,
    onSubmitted: (text) => _updateRefreshing(true),
    style: Theme
      .of(context)
      .textTheme
      .subhead
      .copyWith(fontSize: 18.0, color: Colors.white),
    inputDecoration: InputDecoration(
      counterText: "",
      enabled: this.status == AuthStatus.PHONE_AUTH,
      icon: const Icon(
        Icons.phone,
        color: Colors.white,
      ),
      labelText: "Phone",
      labelStyle: decorationStyle,
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  }

  Widget _buildBody(){
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Text(
                  "asasas",
                  style: TextStyle(
                    color : Colors.blue
                  ),
                ),
              ),
            )
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _buildBody(),
        ],
      )
    );
  }
}