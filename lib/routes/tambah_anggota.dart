import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:kk_helper/routes/track.dart';
import 'package:kk_helper/widget/Ddrawer.dart';
import 'package:kk_helper/local_disk.dart';
import 'package:kk_helper/model/users.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:kk_helper/list_kec_kel.dart';
import 'package:kk_helper/model/data_keluarga.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:kk_helper/model/anggota_tambah.dart';

class TambahAnggota extends StatefulWidget{
  final FirebaseUser firebaseUser;
  const TambahAnggota({Key key, @required this.firebaseUser})
      :assert(firebaseUser != null),
        super(key : key);
  @override
  State<StatefulWidget> createState() => new _TambahAnggotaState();
}

class _TambahAnggotaState extends State<TambahAnggota>{
  final GlobalKey<ScaffoldState> _scaffoldStateKey = new GlobalKey<ScaffoldState>();

  List<TextEditingController> _namaAnggotaController = [];
  List<TextEditingController> _nikAnggotaController = [];
  List<TextEditingController> _alasanKurangController = [];

  List<TextEditingController> _namaKeluargaController = [];
  List<TextEditingController> _nikKeluargaController = [];
  List<String> _shdk = [];

  TextEditingController _kepalaController = new TextEditingController();
  TextEditingController _noKKController = new TextEditingController();
  TextEditingController _alamatController = new TextEditingController();
  TextEditingController _rtController = new TextEditingController();
  TextEditingController _rwController = new TextEditingController();
  TextEditingController _jumlahAnggotaController =new TextEditingController();

  List<String> listKecamatan = ListKecKel.getListKecamatan();
  List<List<String>> listKelurahan = ListKecKel.getListKelurahan();

  String kepala = "";
  String noKK = "";
  String alamat = "";
  String kelurahan = "";
  String kecamatan = "";
  String rt = "";
  String rw = "";

  Users user = new Users();

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  int posForm = 0;
  int posKecamatan = -1;
  bool kirimData = false;

  int _jumlahTambah = 0;
  int _jumlahAnggota = 0;

  List<String> listDay = [];
  List<String> listMonth = [];
  List<String> listYear = [];

  List<AnggotaTambah> listKurangAnggota = [];
  List<DataKeluarga> listDataKeluarga = [];

  File _imageKK;
  File _imagePengantarRtRw;
  List<File> _imageKeteranganPindah = [];
  List<File> _imageKematian = [];

  String _urlImageKK = "";
  String _urlImagePengantarRtRw = "";
  List<String> _urlImageKeteranganPindah = [];
  List<String> _urlImageKematian = [];

  String kondisiKirim = "";

  _storeData() async {
    DatabaseReference database = _database.reference().child("kurang_anggota").push();
    var anggota = [];
    var kurang = [];

    _storeUpload().whenComplete((){
      setState(() {
        kondisiKirim = "Mengirim Data...";
      });
      for(int i = 0; i < _jumlahAnggota; i++){
        anggota.add({
          'nama' : listDataKeluarga[i].nama,
          'noKtpPen' : listDataKeluarga[i].noKtpPen,
          'alamatSblm' : listDataKeluarga[i].alamatSblm,
          'jenisKelamin' : listDataKeluarga[i].jenisKelamin,
          'tempatLahir' : listDataKeluarga[i].tempatLahir,
          'ttl' : listDataKeluarga[i].ttl,
          'umur' : listDataKeluarga[i].umur,
          'golDarah' : listDataKeluarga[i].golDarah,
          'agama' : listDataKeluarga[i].agama,
          'statusKawin' : listDataKeluarga[i].statusKawin,
          'statusHub' : listDataKeluarga[i].statusHub,
          'kelainanFisik' : listDataKeluarga[i].kelainanFisik,
          'penyandangCacat' : listDataKeluarga[i].penyandangCacat,
          'pendidikanTerakhir' : listDataKeluarga[i].pendidikanTerakhir,
          'pekerjaan' : listDataKeluarga[i].pekerjaan,
          'namaIbu' : listDataKeluarga[i].namaIbu,
          'namaAyah' : listDataKeluarga[i].namaAyah
        });
      }

      for(int i = 0; i <_jumlahTambah; i++){
        kurang.add({
          'nama' : listKurangAnggota[i].nama,
          'nik' : listKurangAnggota[i].nik,
          'alasanKurang' : listKurangAnggota[i].alasanKurang
        });
      }
      database.set({
        'idUser' : this.user.Key,
        'kepalaKeluarga' : this.kepala,
        'accKelurahan' : false,
        'accKecamatan' : false,
        'reject' : '',
        'rejectKeterangan' : '',
        'noKK' : noKK,
        'alamat' : alamat,
        'rt' : rt,
        'rw' : rw,
        'kecamatan' : kecamatan,
        'kelurahan' : kelurahan,
        'date' : new DateTime.now().year.toString() + "-" + new DateTime.now().month.toString() +
            "-" + new DateTime.now().day.toString() + " " + new DateTime.now().hour.toString() + ":" + new DateTime.now().minute.toString(),
        'anggotaKeluarga' : anggota,
        'kurangAnggota' : kurang,
        'image' : {
          'kk' : _urlImageKK,
          'pengantarRtRw' : _urlImagePengantarRtRw,
          'keteranganPindah' : _urlImageKeteranganPindah,
          'keteranganKematian' : _urlImageKematian,
        }
      }).whenComplete((){
        setState(() {
          kirimData = false;
        });
        Fluttertoast.showToast(msg: "Semua data berhasil dikirim").whenComplete((){
          Fluttertoast.showToast(msg: "Silahkan tunggu acc dari kelurahan dan kecamatan", toastLength: Toast.LENGTH_LONG);
          Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (context) => Track(
              firebaseUser: widget.firebaseUser,
            ),
          ));
        });
      }).catchError((err){
        setState(() {
          kirimData = false;
        });
        Fluttertoast.showToast(msg: "gagal mengirim data");
      });
    }).catchError((err){
      setState(() {
        kirimData = false;
      });
      Fluttertoast.showToast(msg: "gagal mengirim data");
    });
  }

  _storeUpload() async {
    String rand = randomNumeric(10);

    setState(() {
      kondisiKirim = "Upload Gambar...";
    });

    final StorageReference firebaseKK = FirebaseStorage.instance.ref().child("kurangAnggota_kk_" + rand);
    await firebaseKK.putFile(_imageKK).onComplete.then((kk) {
      kk.ref.getDownloadURL().then((url){
        this._urlImageKK = url.toString();
      });
    }, onError: (err){
      setState(() {
        kirimData = false;
      });
      Fluttertoast.showToast(msg: "maaf terjadi kesalahan upload");
    });

    final StorageReference firebaseKetRTRW = FirebaseStorage.instance.ref().child("kurangAnggota_pengantarRTRW_" + rand);
    await firebaseKetRTRW.putFile(_imagePengantarRtRw).onComplete.then((kk) {
      kk.ref.getDownloadURL().then((url){
        this._urlImagePengantarRtRw = url.toString();
      });
    }, onError: (err){
      setState(() {
        kirimData = false;
      });
      Fluttertoast.showToast(msg: "maaf terjadi kesalahan upload");
    });

    for(int i = 0; i < _imageKematian.length; i++){
      StorageReference firebaseRef = FirebaseStorage.instance.ref().child("kurangAnggota_kematian_" + i.toString() + "_"  + rand);
      await firebaseRef.putFile(_imageKematian[i]).onComplete.then((kawin) {
        kawin.ref.getDownloadURL().then((url){
          this._urlImageKematian.add(url.toString());
        });
      }, onError: (err){
        setState(() {
          kirimData = false;
        });
        Fluttertoast.showToast(msg: "maaf terjadi kesalahan upload");
      });
    }

    for(int i = 0; i < _imageKeteranganPindah.length; i++){
      StorageReference firebaseRef = FirebaseStorage.instance.ref().child("kurangAnggota_keteranganPindah_" + i.toString() + "_"  + rand);
      await firebaseRef.putFile(_imageKeteranganPindah[i]).onComplete.then((kawin) {
        kawin.ref.getDownloadURL().then((url){
          this._urlImageKeteranganPindah.add(url.toString());
        });
      }, onError: (err){
        setState(() {
          kirimData = false;
        });
        Fluttertoast.showToast(msg: "maaf terjadi kesalahan upload");
      });
    }

    for(int i = 0; i < 1; i++){
      StorageReference firebaseRef = FirebaseStorage.instance.ref().child("kurangAnggota_dummy");
      await firebaseRef.putFile(_imageKK).onComplete.then((kawin) {

      }, onError: (err){
        setState(() {
          kirimData = false;
        });
        Fluttertoast.showToast(msg: "maaf terjadi kesalahan upload");
      });
    }
  }
  _backConfrim(){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Apa anda yakin keluar?'),
        content: new Text('Semua data yang diisi akan hilang'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              'Tidak',
              style: TextStyle(
                  color: Color(0xff6ba3ff)
              ),
            ),
          ),
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              Navigator.of(context).pop(true);
            },
            child: new Text(
              'Ya',
              style: TextStyle(
                  color: Color(0xff6ba3ff)
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showConfirmKirim(){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Yakin untuk mengirim data?'),
        content: new Text('Pastikan data kamu telah benar dan tidak ada yang salah'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              'Tidak',
              style: TextStyle(
                  color: Color(0xff6ba3ff)
              ),
            ),
          ),
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              setState(() {
                kirimData = true;
              });
              _storeData();
            },
            child: new Text(
              'Ya',
              style: TextStyle(
                  color: Color(0xff6ba3ff)
              ),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  getImageKK() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (image.lengthSync() > 10000000) {
        Fluttertoast.showToast(
            msg: "minimal gambar ukuran 1MB", toastLength: Toast.LENGTH_SHORT);
      } else {
        setState(() {
          _imageKK = image;
        });
      }
    }
  }

  getImagePengantarRtRw() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (image.lengthSync() > 10000000) {
        Fluttertoast.showToast(
            msg: "minimal gambar ukuran 1MB", toastLength: Toast.LENGTH_SHORT);
      } else {
        setState(() {
          _imagePengantarRtRw = image;
        });
      }
    }
  }

  getImageKeteranganPindah() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null){
      if (image.lengthSync() > 10000000) {
        Fluttertoast.showToast(msg: "minimal gambar ukuran 1MB", toastLength: Toast.LENGTH_SHORT);
      } else {
        setState(() {
          _imageKeteranganPindah.add(image);
        });
      }
    }
  }

  getImageKematian() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null){
      if (image.lengthSync() > 10000000) {
        Fluttertoast.showToast(msg: "minimal gambar ukuran 1MB", toastLength: Toast.LENGTH_SHORT);
      } else {
        setState(() {
          _imageKematian.add(image);
        });
      }
    }
  }

  Future<bool> _showHelpKK(){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Kartu Keluarga'),
        content: new SingleChildScrollView (
          scrollDirection: Axis.vertical,
          child: new Text('aksnkalnsnahifhLFD HAOWI FHOIIOA FSJFASJ AOSJ PASOJ'),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              'Tutup',
              style: TextStyle(
                  color: Color(0xff6ba3ff)
              ),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<bool> _showHelpPengantarRtRw(){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Surat Pengantar RT/RW'),
        content: new SingleChildScrollView (
          scrollDirection: Axis.vertical,
          child: new Text('aksnkalnsnahifhLFD HAOWI FHOIIOA FSJFASJ AOSJ PASOJ'),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              'Tutup',
              style: TextStyle(
                  color: Color(0xff6ba3ff)
              ),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<bool> _showHelpKeteranganPindah(){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Surat Keterangan Pindah'),
        content: new SingleChildScrollView (
          scrollDirection: Axis.vertical,
          child: new Text('aksnkalnsnahifhLFD HAOWI FHOIIOA FSJFASJ AOSJ PASOJ'),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              'Tutup',
              style: TextStyle(
                  color: Color(0xff6ba3ff)
              ),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<bool> _showHelpKematian(){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Surat Kematian'),
        content: new SingleChildScrollView (
          scrollDirection: Axis.vertical,
          child: new Text('aksnkalnsnahifhLFD HAOWI FHOIIOA FSJFASJ AOSJ PASOJ'),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              'Tutup',
              style: TextStyle(
                  color: Color(0xff6ba3ff)
              ),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  void _setInputForm1(){
    _kepalaController.text = kepala;
    _noKKController.text = noKK;
    _alamatController.text = alamat;
    _rtController.text = rt;
    _rwController.text = rw;
  }

  bool _cekInputForm1(){
    if (kepala == "" || noKK == "" || alamat == "" || rt == "" || rw == "" ||
        kelurahan == "" || kecamatan == "" || _jumlahTambah <= 0 || _jumlahAnggota <= 0){
      Fluttertoast.showToast(msg: "semua data harus diisi", toastLength: Toast.LENGTH_SHORT);
      return false;
    } else if (noKK.length != 16) {
      Fluttertoast.showToast(msg: "jumlah nokk sebanyak 16 digit");
      return false;
    } else if (_jumlahAnggota <= _jumlahTambah) {
      Fluttertoast.showToast(msg: "isi jumlah keluarga dengan benar");
      return false;
    } else {
      return true;
    }
  }

  bool _cekInputForm2(){
    bool cek = true;
    for(int i = 0; i < _jumlahTambah ; i++){
      if (listKurangAnggota[i].nama == "" || listKurangAnggota[i].nik == "" || listKurangAnggota[i].alasanKurang == ""){
        Fluttertoast.showToast(msg: "Semua data anggota harus diisi", toastLength: Toast.LENGTH_SHORT);
        cek = false;
      } else if (listKurangAnggota[i].nik.length != 16){
        Fluttertoast.showToast(msg: "No nik harus 16 digit", toastLength: Toast.LENGTH_SHORT);
        cek = false;
      }

      if (!cek){
        break;
      }
    }
    return cek;
  }

  bool _cekInputForm3(){
    bool cek = true;
    if (_imageKK == null){
      Fluttertoast.showToast(msg: "kartu keluarga harus diisi");
      cek = false;
    } else if (_imagePengantarRtRw == null){
      Fluttertoast.showToast(msg: "pengantar RT/RW harus diisi");
      cek = false;
    } else if (_imageKeteranganPindah.length == 0 && _imageKematian.length == 0){
      Fluttertoast.showToast(msg: "setiap penggurangan anggota harus ada bukti kematian/perpindahan", toastLength: Toast.LENGTH_LONG);
      cek = false;
    } else if ((_imageKeteranganPindah.length + _imageKematian.length) < _jumlahTambah){
      Fluttertoast.showToast(msg: "upload bukti kematian/perpindahan masih kurang").whenComplete((){
        Fluttertoast.showToast(msg: "setiap anggota yang dikurangi harus ada bukti kematian/perpindahan");
      });
      cek = false;
    }

    return cek;
  }

  List<Widget> _btnNextPrev(int pos){
    if (pos == 0 ){
      return <Widget> [
        new Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
          child: new RaisedButton(
            onPressed: (){
              if (_cekInputForm1()){
                setState(() {
                  posForm++;
                });
              }
            },
            color: Color(0xff6ba3ff),
            child: new Text(
              "Next",
              style: new TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        )
      ];
    } else if (pos == 2){
      return <Widget> [
        new Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
          child: new RaisedButton(
            onPressed: (){
              setState(() {
                posForm--;
              });
            },
            color: Color(0xff6ba3ff),
            child: new Text(
              "Prev",
              style: new TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        ),
        new Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
          child: new RaisedButton(
            onPressed: (){
              if (_cekInputForm3()){
                setState(() {
                  _showConfirmKirim();
                });
              }
            },
            color: Color(0xff41f4a0),
            child: new Text(
              "Kirim",
              style: new TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        )
      ];
    } else {
      return <Widget> [
        new Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
          child: new RaisedButton(
            onPressed: (){
              setState(() {
                if (posForm == 1){
                  _setInputForm1();
                }
                posForm--;
              });
            },
            color: Color(0xff6ba3ff),
            child: new Text(
              "Prev",
              style: new TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        ),
        new Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
          child: new RaisedButton(
            onPressed: (){
              setState(() {
                bool cek = posForm == 1 ? _cekInputForm2() : _cekInputForm3();
                if (cek){
                  setState(() {
                    posForm++;
                  });
                }
              });
            },
            color: Color(0xff6ba3ff),
            child: new Text(
              "Next",
              style: new TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        )
      ];
    }
  }

  List<Widget> _switchForm(int pos){
    switch (pos){
      case 0:
        return _showForm1(MediaQuery.of(context).size.width / 22);
        break;
      case 1:
        return _showForm2(MediaQuery.of(context).size.width / 22);
        break;
      case 2:
        return _showForm3(MediaQuery.of(context).size.width / 22);
        break;
    }
  }

  List<Widget> _showForm1(double fontForm){
    return <Widget>[
      new Container(
        alignment: Alignment.centerLeft,
        child: new Text("Kepala Keluarga :"),
        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
      ), new Container(
        margin: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width / 1,
        alignment: Alignment.center,
        child: new TextField(
          controller: _kepalaController,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: fontForm,
            color: Colors.black54,
          ),
          decoration: new InputDecoration(
            hintStyle: TextStyle(
              fontSize: fontForm - 5,
            ),
            hintText: "nama lengkap",
            border: InputBorder.none,
          ),
          onChanged: (val){
            setState(() {
              kepala = val;
            });
          },
        ),
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              kepala == "" ?
              new BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, 0.2),
                  blurRadius: 0.2
              ) :
              new BoxShadow(
                  color: Colors.blue,
                  offset: Offset(0, 0.28),
                  blurRadius: 1
              )
            ]
        ),
      ), new Container(
        alignment: Alignment.centerLeft,
        child: new Text("No KK :"),
        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
      ), new Container(
        margin: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width / 1,
        alignment: Alignment.center,
        child: new TextField(
          controller: _noKKController,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: fontForm,
            color: Colors.black54,
          ),
          decoration: new InputDecoration(
            hintStyle: TextStyle(
              fontSize: fontForm - 5,
            ),
            hintText: "no kk",
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.number,
          onChanged: (val){
            setState(() {
              noKK = val;
            });
          },
        ),
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              noKK == "" ?
              new BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, 0.2),
                  blurRadius: 0.2
              ) :
              new BoxShadow(
                  color: Colors.blue,
                  offset: Offset(0, 0.28),
                  blurRadius: 1
              )
            ]
        ),
      ), new Container(
        alignment: Alignment.centerLeft,
        child: new Text("Alamat :"),
        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
      ), new Container(
        margin: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width / 1,
        alignment: Alignment.center,
        child: new TextField(
          controller: _alamatController,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: fontForm,
            color: Colors.black54,
          ),
          decoration: new InputDecoration(
            hintStyle: TextStyle(
              fontSize: fontForm - 5,
            ),
            hintText: "alamat lengkap",
            border: InputBorder.none,
          ),
          onChanged: (val){
            setState(() {
              alamat = val;
            });
          },
        ),
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              alamat == "" ?
              new BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, 0.2),
                  blurRadius: 0.2
              ) :
              new BoxShadow(
                  color: Colors.blue,
                  offset: Offset(0, 0.28),
                  blurRadius: 1
              )
            ]
        ),
      ), new Row(
        children: <Widget>[
          new Flexible(
              child: new Container(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      alignment: Alignment.centerLeft,
                      child: new Text("RT :"),
                      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                    ), new Container(
                      margin: const EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width / 1,
                      alignment: Alignment.center,
                      child: new TextField(
                        controller: _rtController,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: fontForm,
                          color: Colors.black54,
                        ),
                        decoration: new InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: fontForm - 5,
                          ),
                          hintText: "rt",
                          border: InputBorder.none,
                        ),
                        onChanged: (val){
                          setState(() {
                            rt = val;
                          });
                        },
                        keyboardType: TextInputType.number,
                      ),
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: [
                            rt == "" ?
                            new BoxShadow(
                                color: Colors.black38,
                                offset: Offset(0, 0.2),
                                blurRadius: 0.2
                            ) :
                            new BoxShadow(
                                color: Colors.blue,
                                offset: Offset(0, 0.28),
                                blurRadius: 1
                            )
                          ]
                      ),
                    ),
                  ],
                ),
              )
          ), new Flexible(
              child: new Container(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      alignment: Alignment.centerLeft,
                      child: new Text("RW :"),
                      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                    ), new Container(
                      margin: const EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width / 1,
                      alignment: Alignment.center,
                      child: new TextField(
                        controller: _rwController,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: fontForm,
                          color: Colors.black54,
                        ),
                        decoration: new InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: fontForm - 5,
                          ),
                          hintText: "rw",
                          border: InputBorder.none,
                        ),
                        onChanged: (val){
                          setState(() {
                            rw = val;
                          });
                        },
                        keyboardType: TextInputType.number,
                      ),
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: [
                            rw == "" ?
                            new BoxShadow(
                                color: Colors.black38,
                                offset: Offset(0, 0.2),
                                blurRadius: 0.2
                            ) :
                            new BoxShadow(
                                color: Colors.blue,
                                offset: Offset(0, 0.28),
                                blurRadius: 1
                            )
                          ]
                      ),
                    ),
                  ],
                ),
              )
          )
        ],
      ),new Container(
        alignment: Alignment.centerLeft,
        child: new Text("Kecamatan :"),
        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
      ), new Container(
        margin: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width / 1,
        child: new DropdownButtonHideUnderline(
          child: new DropdownButton(
            hint: new Text(
              kecamatan == "" ? "kecamatan" : kecamatan,
              style: TextStyle(
                  fontSize: fontForm - 3
              ),
              textAlign: TextAlign.center,
            ),
            items: listKecamatan.map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            style: new TextStyle(
              fontSize: fontForm - 3,
              color: Colors.black54,
            ),
            onChanged: (value) {
              setState(() {
                kecamatan = value;
                kelurahan = "";
                for (int i = 0; i < listKecamatan.length; i++){
                  if (listKecamatan[i] == value){
                    posKecamatan = i;
                  }
                }
              });
            },
          ),
        ),
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              kecamatan == "" ?
              new BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, 0.2),
                  blurRadius: 0.2
              ) :
              new BoxShadow(
                  color: Colors.blue,
                  offset: Offset(0, 0.28),
                  blurRadius: 1
              )
            ]
        ),
      ), new Container(
        alignment: Alignment.centerLeft,
        child: new Text("Kelurahan :"),
        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
      ), new Container(
        margin: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width / 1,
        child: new DropdownButtonHideUnderline(
          child: new DropdownButton(
            hint: new Text(
              kelurahan == "" ? "kelurahan" : kelurahan,
              style: TextStyle(
                  fontSize: fontForm - 3
              ),
              textAlign: TextAlign.center,
            ),
            items: posKecamatan == -1 ? null : listKelurahan[posKecamatan].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList()
            ,style: new TextStyle(
            fontSize: fontForm - 3,
            color: Colors.black54,
          ),
            onChanged: (value) {
              setState(() {
                kelurahan = value;
              });
            },
          ),
        ),
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              kelurahan == "" ?
              new BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, 0.2),
                  blurRadius: 0.2
              ) :
              new BoxShadow(
                  color: Colors.blue,
                  offset: Offset(0, 0.28),
                  blurRadius: 1
              )
            ]
        ),
      ), new Row(
        children: <Widget>[
          new Flexible(
            child: new Column(
              children: <Widget>[
                new Container(
                  alignment: Alignment.centerLeft,
                  child: new Text("Jumlah Pertambahan :"),
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                ), new Container(
                  margin: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width / 1,
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton(
                      hint: new Text(
                        _jumlahTambah == 0 ? "pengurangan" : _jumlahTambah.toString(),
                        style: TextStyle(
                            fontSize: fontForm - 3
                        ),
                        textAlign: TextAlign.center,
                      ),
                      items: ["1", "2", "3", "4", "5"].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList()
                      ,style: new TextStyle(
                      fontSize: fontForm - 3,
                      color: Colors.black54,
                    ),
                      onChanged: (value) {
                        setState(() {
                          _jumlahTambah = int.parse(value);
                        });
                      },
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        _jumlahTambah == 0 ?
                        new BoxShadow(
                            color: Colors.black38,
                            offset: Offset(0, 0.2),
                            blurRadius: 0.2
                        ) :
                        new BoxShadow(
                            color: Colors.blue,
                            offset: Offset(0, 0.28),
                            blurRadius: 1
                        )
                      ]
                  ),
                ),
              ],
            ),
          ), new Flexible(
            child: new Column(
              children: <Widget>[
                new Container(
                  alignment: Alignment.centerLeft,
                  child: new Text("Jumlah Anggota :"),
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                ),  new Container(
                  margin: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width / 1,
                  alignment: Alignment.center,
                  child: new TextField(
                    controller: _jumlahAnggotaController,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: fontForm,
                      color: Colors.black54,
                    ),
                    decoration: new InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: fontForm - 5,
                      ),
                      hintText: "jumlah keluarga",
                      border: InputBorder.none,
                    ),
                    onChanged: (val){
                      setState(() {
                        _jumlahAnggota = int.parse(val);
                      });
                    },
                    keyboardType: TextInputType.number,
                  ),
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        _jumlahAnggota == 0 ?
                        new BoxShadow(
                            color: Colors.black38,
                            offset: Offset(0, 0.2),
                            blurRadius: 0.2
                        ) :
                        new BoxShadow(
                            color: Colors.blue,
                            offset: Offset(0, 0.28),
                            blurRadius: 1
                        )
                      ]
                  ),
                ),
              ],
            ),
          )
        ],
      )
    ];
  }

  List<Widget> _showForm2(double fontForm){
    List<Widget> list = [];
    if (listKurangAnggota.length == 0){
      for(int i = 0; i < _jumlahTambah; i++){
        _namaAnggotaController.add(new TextEditingController());
        _nikAnggotaController.add(new TextEditingController());
        _alasanKurangController.add(new TextEditingController());

        listKurangAnggota.add(new AnggotaTambah());
      }
    } else {
      if (listKurangAnggota.length < _jumlahTambah) {
        int jumlah = _jumlahTambah - listKurangAnggota.length;
        for (int i = 0; i < jumlah; i++) {
          _namaAnggotaController.add(new TextEditingController());
          _nikAnggotaController.add(new TextEditingController());
          _alasanKurangController.add(new TextEditingController());

          listKurangAnggota.add(new AnggotaTambah());
        }
      }
    }

    for (int i = 1; i <= _jumlahTambah; i++){
      list.add(
          new ExpansionTile(
            initiallyExpanded: false,
            title: new Text(
                listKurangAnggota[i-1].nama == "" ? i.toString() + ".Data Anggota" : i.toString() + "." + listKurangAnggota[i-1].nama
            ),
            children: <Widget>[
              new Container(
                alignment: Alignment.centerLeft,
                child: new Text("Anggota Keluarga :"),
                padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
              ), new Container(
                margin: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width / 1,
                alignment: Alignment.center,
                child: new TextField(
                  controller: _namaAnggotaController[i-1],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: fontForm,
                    color: Colors.black54,
                  ),
                  decoration: new InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: fontForm - 5,
                    ),
                    hintText: "nama lengkap",
                    border: InputBorder.none,
                  ),
                  onChanged: (val){
                    setState(() {
                      listKurangAnggota[i-1].setNama = val;
                    });
                  },
                ),
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: [
                      listKurangAnggota[i-1].nama == "" ?
                      new BoxShadow(
                          color: Colors.black38,
                          offset: Offset(0, 0.2),
                          blurRadius: 0.2
                      ) :
                      new BoxShadow(
                          color: Colors.blue,
                          offset: Offset(0, 0.28),
                          blurRadius: 1
                      )
                    ]
                ),
              ), new Container(
                alignment: Alignment.centerLeft,
                child: new Text("NIK :"),
                padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
              ), new Container(
                margin: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width / 1,
                alignment: Alignment.center,
                child: new TextField(
                  controller: _nikAnggotaController[i-1],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: fontForm,
                    color: Colors.black54,
                  ),
                  decoration: new InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: fontForm - 5,
                    ),
                    hintText: "nik",
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val){
                    setState(() {
                      listKurangAnggota[i-1].setNik = val;
                    });
                  },
                ),
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: [
                      listKurangAnggota[i-1].nik == "" ?
                      new BoxShadow(
                          color: Colors.black38,
                          offset: Offset(0, 0.2),
                          blurRadius: 0.2
                      ) :
                      new BoxShadow(
                          color: Colors.blue,
                          offset: Offset(0, 0.28),
                          blurRadius: 1
                      )
                    ]
                ),
              ), new Container(
                alignment: Alignment.centerLeft,
                child: new Text("Alasan Pengurangan :"),
                padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
              ), new Container(
                margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
                width: MediaQuery.of(context).size.width / 1,
                child: new DropdownButtonHideUnderline(
                  child: new DropdownButton(
                    hint: new Text(
                      listKurangAnggota[i-1].alasanKurang == "" ? "alasan" : listKurangAnggota[i-1].alasanKurang,
                      style: TextStyle(
                          fontSize: fontForm - 3
                      ),
                      textAlign: TextAlign.center,
                    ),
                    items: ["perpindahan", "kematian"].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    style: new TextStyle(
                      fontSize: fontForm - 3,
                      color: Colors.black54,
                    ),
                    onChanged: (value) {
                      setState(() {
                        listKurangAnggota[i-1].setAlasanKurang = value;
                      });
                    },
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: [
                      listKurangAnggota[i-1].alasanKurang == "" ?
                      new BoxShadow(
                          color: Colors.black38,
                          offset: Offset(0, 0.2),
                          blurRadius: 0.2
                      ) :
                      new BoxShadow(
                          color: Colors.blue,
                          offset: Offset(0, 0.28),
                          blurRadius: 1
                      )
                    ]
                ),
              ),
            ],
          )
      );
    }

    return list;
  }

  List<Widget> _showForm3(double fontForm){
    return <Widget> [
      new Container(
          margin: const EdgeInsets.all(15.0),
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text(
                    "Kartu Keluarga",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0
                    ),
                  ), IconButton(
                      alignment: Alignment.topLeft,
                      splashColor: Colors.transparent,
                      icon: new Icon(
                        Icons.help,
                        size: 15.0,
                      ),
                      onPressed: _showHelpKK
                  ),
                ],
              ),
              new Container(
                child: _imageKK == null
                    ? new Text('Gambar Belum Dipilih.')
                    : new Image.file(
                  _imageKK,
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                )
                ,margin: const EdgeInsets.only(bottom: 10.0, top: 5.0),
              )
              , new RaisedButton(
                onPressed: getImageKK,
                color: Color(0xff30a8ff),
                splashColor: Colors.white10,
                elevation: 4,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                child: Text(
                  "Kartu Keluarga",
                  style: new TextStyle(
                      color: Colors.white70,
                      fontSize: 13.0,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none
                  ),
                ),
              ),
            ],
          )
      ), new Container(
          margin: const EdgeInsets.all(15.0),
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text(
                    "Pengantar RT/RW",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0
                    ),
                  ), IconButton(
                      alignment: Alignment.topLeft,
                      splashColor: Colors.transparent,
                      icon: new Icon(
                        Icons.help,
                        size: 15.0,
                      ),
                      onPressed: _showHelpPengantarRtRw
                  ),
                ],
              ),
              new Container(
                child: _imagePengantarRtRw == null
                    ? new Text('Gambar Belum Dipilih.')
                    : new Image.file(
                  _imagePengantarRtRw,
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                )
                ,margin: const EdgeInsets.only(bottom: 10.0, top: 5.0),
              )
              , new RaisedButton(
                onPressed: getImagePengantarRtRw,
                color: Color(0xff30a8ff),
                splashColor: Colors.white10,
                elevation: 4,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                child: Text(
                  "Pengantar RT/RW",
                  style: new TextStyle(
                      color: Colors.white70,
                      fontSize: 13.0,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none
                  ),
                ),
              ),
            ],
          )
      ), new Container(
          margin: const EdgeInsets.all(15.0),
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text(
                    "KET PINDAH (Jika Pindah)",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0
                    ),
                  ), IconButton(
                      alignment: Alignment.topLeft,
                      splashColor: Colors.transparent,
                      icon: new Icon(
                        Icons.help,
                        size: 15.0,
                      ),
                      onPressed: _showHelpKeteranganPindah
                  ),
                ],
              ),
              new Container(
                child: _imageKeteranganPindah.length == 0 ? new Text ("Gambar belum dipilih") : _imageKeteranganPindah.length == 1 ?
                new Stack(
                  children: <Widget>[
                    new Container(
                      width: MediaQuery.of(context).size.width,
                      margin: new EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: new BoxDecoration(
                          color: Colors.amber
                      ),
                      child: new Image.file (
                        _imageKeteranganPindah.first,
                        height: 200.0,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ), new Container(
                      child: new IconButton(
                        icon: new Icon(
                          Icons.close,
                          color: Colors.black87,
                        ),
                        onPressed: (){
                          setState(() {
                            _imageKeteranganPindah.removeAt(_imageKeteranganPindah.indexOf(_imageKeteranganPindah.first));
                          });
                        },
                        splashColor: Colors.transparent,
                      ),
                      alignment: Alignment.topRight,
                    )
                  ],
                ) :
                new CarouselSlider(
                  items: _imageKeteranganPindah.map( (file) {
                    return new Builder(
                      builder: (BuildContext context) {
                        return new Stack(
                          children: <Widget>[
                            new Container(
                              width: MediaQuery.of(context).size.width,
                              margin: new EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: new BoxDecoration(
                                  color: Colors.amber
                              ),
                              child: new Image.file (
                                file,
                                height: 200.0,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                            ), new Container(
                              child: new IconButton(
                                icon: new Icon(
                                  Icons.close,
                                  color: Colors.black87,
                                ),
                                onPressed: (){
                                  setState(() {
                                    _imageKeteranganPindah.removeAt(_imageKeteranganPindah.indexOf(file));
                                  });
                                },
                                splashColor: Colors.transparent,
                              ),
                              alignment: Alignment.topRight,
                            )
                          ],
                        );
                      },
                    );
                  }).toList(),
                  height: 200.0,
                )
                , margin: const EdgeInsets.only(bottom: 10.0, top: 5.0),
              )
              , new RaisedButton(
                onPressed: getImageKeteranganPindah,
                color: Color(0xff30a8ff),
                splashColor: Colors.white10,
                elevation: 4,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                child: Text(
                  "Keterangan Pindah",
                  style: new TextStyle(
                      color: Colors.white70,
                      fontSize: 13.0,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none
                  ),
                ),
              ),
            ],
          )
      ),  new Container(
          margin: const EdgeInsets.all(15.0),
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text(
                    "KEMATIAN (Jika Meninggal)",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0
                    ),
                  ), IconButton(
                      alignment: Alignment.topLeft,
                      splashColor: Colors.transparent,
                      icon: new Icon(
                        Icons.help,
                        size: 15.0,
                      ),
                      onPressed: _showHelpKematian
                  ),
                ],
              ),
              new Container(
                child: _imageKematian.length == 0 ? new Text ("Gambar belum dipilih") : _imageKematian.length == 1 ?
                new Stack(
                  children: <Widget>[
                    new Container(
                      width: MediaQuery.of(context).size.width,
                      margin: new EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: new BoxDecoration(
                          color: Colors.amber
                      ),
                      child: new Image.file (
                        _imageKematian.first,
                        height: 200.0,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ), new Container(
                      child: new IconButton(
                        icon: new Icon(
                          Icons.close,
                          color: Colors.black87,
                        ),
                        onPressed: (){
                          setState(() {
                            _imageKematian.removeAt(_imageKematian.indexOf(_imageKematian.first));
                          });
                        },
                        splashColor: Colors.transparent,
                      ),
                      alignment: Alignment.topRight,
                    )
                  ],
                ) :
                new CarouselSlider(
                  items: _imageKematian.map( (file) {
                    return new Builder(
                      builder: (BuildContext context) {
                        return new Stack(
                          children: <Widget>[
                            new Container(
                              width: MediaQuery.of(context).size.width,
                              margin: new EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: new BoxDecoration(
                                  color: Colors.amber
                              ),
                              child: new Image.file (
                                file,
                                height: 200.0,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                            ), new Container(
                              child: new IconButton(
                                icon: new Icon(
                                  Icons.close,
                                  color: Colors.black87,
                                ),
                                onPressed: (){
                                  setState(() {
                                    _imageKematian.removeAt(_imageKematian.indexOf(file));
                                  });
                                },
                                splashColor: Colors.transparent,
                              ),
                              alignment: Alignment.topRight,
                            )
                          ],
                        );
                      },
                    );
                  }).toList(),
                  height: 200.0,
                )
                , margin: const EdgeInsets.only(bottom: 10.0, top: 5.0),
              )
              , new RaisedButton(
                onPressed: getImageKematian,
                color: Color(0xff30a8ff),
                splashColor: Colors.white10,
                elevation: 4,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                child: Text(
                  "Keterangan Kematian",
                  style: new TextStyle(
                      color: Colors.white70,
                      fontSize: 13.0,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none
                  ),
                ),
              ),
            ],
          )
      )
    ];
  }

  Future<bool> _onWillPop(){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Apa anda yakin keluar?'),
        content: new Text('Semua data yang diisi akan hilang'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              'Tidak',
              style: TextStyle(
                  color: Color(0xff6ba3ff)
              ),
            ),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text(
              'Ya',
              style: TextStyle(
                  color: Color(0xff6ba3ff)
              ),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double fontForm = MediaQuery.of(context).size.width / 22;
    double fontJudul = MediaQuery.of(context).size.width / 10;
    // TODO: implement build
    return new Material(
        child: new WillPopScope(
            onWillPop: _onWillPop,
            child: new Scaffold(
              backgroundColor: Colors.white70,
              key: _scaffoldStateKey,
              appBar: new GradientAppBar(
                elevation: 4.0,
                backgroundColorStart: Color(0xFF35ade0),
                backgroundColorEnd: Color(0xff20b7f7),
                leading: new IconButton(
                    icon: new Icon(
                      Icons.arrow_back,
                      size: 30.0,
                      color: Colors.white70,
                    ),
                    onPressed: (){
                      _backConfrim();
                    }
                ),
                title: new Align(
                  alignment: Alignment(-0.15, 0),
                  child: new Text (
                    "Pertambahan Anggota",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              body: new SafeArea(
                  child: new Stack(
                    children: <Widget>[
                      new SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: new Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Container (
                              child: new Text(
                                posForm == 0 ?  "Data KK" : posForm == 1 ? "Pertambahan Anggota" : "UPLOAD KELENGKAPAN"
                                ,textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              alignment: Alignment.topCenter,
                              padding: const EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 15.0),
                            ),
                            new Container(
                              margin: const EdgeInsets.symmetric(vertical: 15.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Container(
                                    child: new CircleAvatar(
                                      child: new Text(
                                        "1",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      ),
                                      backgroundColor: Color(0xff639fff),
                                    ),
                                    width: fontForm * 2.5,
                                    height: fontForm * 2.5,
                                    padding: const EdgeInsets.all(1.0),
                                    decoration: new BoxDecoration(
                                      color: Color(0xff639fff),
                                      shape: BoxShape.circle,
                                    ),
                                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                  ),
                                  new Container(
                                    child: new CircleAvatar(
                                      child: new Text(
                                        "2",
                                        style: TextStyle(
                                          color: posForm > 0 ? Colors.white : Color(0xff639fff),
                                        ),
                                      ),
                                      backgroundColor: posForm > 0 ? Color(0xff639fff) : Colors.white,
                                    ),
                                    width: fontForm * 2.5,
                                    height: fontForm * 2.5,
                                    padding: const EdgeInsets.all(1.0),
                                    decoration: new BoxDecoration(
                                        color: posForm > 0 ? Color(0xff639fff) : Colors.black,
                                        shape: BoxShape.circle
                                    ),
                                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                  ),
                                  new Container(
                                    child: new CircleAvatar(
                                      child: new Text(
                                        "3",
                                        style: TextStyle(
                                          color: posForm > 1 ? Colors.white : Color(0xff639fff),
                                        ),
                                      ),
                                      backgroundColor: posForm > 1 ? Color(0xff639fff) : Colors.white,
                                    ),
                                    width: fontForm * 2.5,
                                    height: fontForm * 2.5,
                                    padding: const EdgeInsets.all(1.0),
                                    decoration: new BoxDecoration(
                                        color: posForm > 1 ? Color(0xff639fff) : Colors.black,
                                        shape: BoxShape.circle
                                    ),
                                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                  ), new Container(
                                    child: new CircleAvatar(
                                      child: new Text(
                                        "4",
                                        style: TextStyle(
                                          color: posForm == 3 ? Colors.white : Color(0xff639fff),
                                        ),
                                      ),
                                      backgroundColor: posForm == 3 ? Color(0xff639fff) : Colors.white,
                                    ),
                                    width: fontForm * 2.5,
                                    height: fontForm * 2.5,
                                    padding: const EdgeInsets.all(1.0),
                                    decoration: new BoxDecoration(
                                        color: posForm == 3 ? Color(0xff639fff) : Colors.black,
                                        shape: BoxShape.circle
                                    ),
                                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                  )
                                ],
                              ),
                            ),
                            new Column(
                              mainAxisSize: MainAxisSize.max,
                              children: _switchForm(posForm),
                            ), new Container(
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              child: new Stack(
                                  children: _btnNextPrev(posForm)
                              ),
                            )
                          ],
                        ),
                      ),
                      kirimData == true ? new Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.black38,
                          alignment: Alignment(0.0, 0.0),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new SizedBox(
                                child: new CircularProgressIndicator(
                                  strokeWidth:5.0,
                                ),
                                height: 80.0,
                                width: 80.0,
                              ),
                              new Container(
                                margin: const EdgeInsets.symmetric(vertical: 20.0),
                                child: new Text(
                                    kondisiKirim,
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0
                                    )
                                ),
                              )
                            ],
                          )
                      ) : new Text("")
                    ],
                  )
              ),
            )
        )
    );
  }

  @override
  void initState(){
    super.initState();

    var now = new DateTime.now();
    for(int i = now.year; i >= 1900; i--){
      this.listYear.add(i.toString());
    };

    for(int i = 1; i <= now.month; i++){
      this.listMonth.add(i.toString());
    };

    for(int i = 1; i <= 31; i++){
      this.listDay.add(i.toString());
    };

    new LocalDisk().getString("user").then((str){
      if (str == null){
        _database.reference().child("user").once().then((DataSnapshot snapshot){
          Map<dynamic, dynamic> values = snapshot.value;
          if (values != null) {
            values.forEach((key, value) {
              if (value["noTelp"] == widget.firebaseUser.phoneNumber) {
                user.setKey = key;
                user.setNama = value["nama"];
                user.setNoTelp = value["noTelp"];
                user.setImage = value["image"];
                user.setRole = value["role"];

                new LocalDisk().setString("user", jsonEncode(user.toJsonWithKey()));
              } else if (value["email"] == widget.firebaseUser.email){
                user.setKey = key;
                user.setNama = value["nama"];
                user.setEmail = value["email"];
                user.setImage = value["image"];
                user.setRole = value["role"];

                new LocalDisk().setString("user", jsonEncode(user.toJsonWithKey()));
              }
            });
          }
        });
      } else {
        Map<dynamic, dynamic> userMap = jsonDecode(str);
        this.user = new Users.fromJsonWithKey(userMap);
        print("user key " + this.user.Key);
      }
    }, onError: (){
      Fluttertoast.showToast(msg: "error pengambilan local disk");
    });
  }
}