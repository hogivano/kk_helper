import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:kk_helper/widget/Ddrawer.dart';
import 'dart:io';
import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'package:kk_helper/local_disk.dart';
import 'package:kk_helper/model/users.dart';
import 'package:kk_helper/model/data_keluarga.dart';
import 'package:flutter_date_picker/flutter_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kk_helper/routes/track.dart';
import 'package:random_string/random_string.dart';
import 'package:path_provider/path_provider.dart';

class HilangKK extends StatefulWidget{
  final FirebaseUser firebaseUser;
  const HilangKK({Key key, @required this.firebaseUser})
      :assert(firebaseUser != null),
        super(key : key);
  @override
  State<StatefulWidget> createState() => new _hilangKKState();
}

class _hilangKKState extends State<HilangKK>{
  final GlobalKey<ScaffoldState> _scaffoldStateKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _namaKepalaController = new TextEditingController();
  final TextEditingController _alamatController = new TextEditingController();
  final TextEditingController _kelurahanController =new TextEditingController();
  final TextEditingController _rtController = new TextEditingController();
  final TextEditingController _rwController = new TextEditingController();
  final TextEditingController _jumlahKeluargaController = new TextEditingController();

  List<TextEditingController> _namaController = [];
  List<TextEditingController> _noKtpPenController = [];
  List<TextEditingController> _alamatSblmControlller = [];
  List<TextEditingController> _tempatLahirController = [];
  List<TextEditingController> _umurController = [];
  List<TextEditingController> _golDarahController = [];
  List<TextEditingController> _agamaController = [];
  List<TextEditingController> _statusKawinController = [];
  List<TextEditingController> _statusHubController = [];
  List<TextEditingController> _kelainanFisikController = [];
  List<TextEditingController> _penyandangCacatController = [];
  List<TextEditingController> _pendidikanTerakhirController = [];
  List<TextEditingController> _pekerjaanController = [];
  List<TextEditingController> _namaIbuController = [];
  List<TextEditingController> _namaAyahController = [];

  List<String> _hari = [];
  List<String> _bulan = [];
  List<String> _tahun = [];

  VoidCallback _showBottomSheetCallback;
  bool showDatePicker = false;
  int posBtnTtl = -1;

  List<GlobalKey<DatePickerState>> dobKeyDate = [];

  List<String> listDay = [];
  List<String> listMonth = [];
  List<String> listYear = [];

  Users user = new Users();
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  var listKecamatan = [
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
  var listKelurahan = [
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

  String kepalaKeluarga = "";
  String alamat = "";
  String kelurahan = "";
  String kecamatan = "";
  String rt = "";
  String rw = "";
  int jumlahKeluarga = 0;
  int posKecamatan = -1;

  var dataKeluarga = [];
  List<DataKeluarga> listDataKeluarga = [];

  int posForm = 0;
  String foos = "one";

  File _imageKK;
  File _imageKehilanganPolisi;
  File _imagePengantarRtRw;
  File _imageKtp;

  String _urlKK = "";
  String _urlKehilanganPolisi = "";
  String _urlPengantarRtRw = "";
  String _urlKtp = "";

  bool kirimData = false;
  String kondisiKirim = "";

  void _setListDay(int index, String mount, String year){
    print(mount + " " + year);
    try {
      if (mount != 0){
        if (int.parse(mount) == 2){
          print ("masukk");
          if (year == ""){
            listDay = [];
            for(int i = 1; i <= 28; i++){
              listDay.add(i.toString());
            }
            if (int.parse(_hari[index]) > 28){
              _hari[index] = "";
            }
          } else {
            print ("oyee");
            if (int.parse(year) % 400 == 0){
              listDay = [];
              for(int i = 1; i <= 29; i++){
                listDay.add(i.toString());
              }
              if (int.parse(_hari[index]) > 29){
                _hari[index] = "";
              }
            } else if (int.parse(year) % 4 == 0 && int.parse(year) % 400 != 0 && int.parse(year) % 100 != 0){
              listDay = [];
              for(int i = 1; i <= 29; i++){
                listDay.add(i.toString());
              }
              if (int.parse(_hari[index]) > 29){
                _hari[index] = "";
              }
            } else {
              listDay = [];
              for(int i = 1; i <= 28; i++){
                listDay.add(i.toString());
              }
              if (int.parse(_hari[index]) > 28){
                _hari[index] = "";
              }
            }
          }
        } else if (int.parse(mount) < 8){
          if (int.parse(mount) % 2 == 0){
            listDay = [];
            for(int i = 1; i <= 30; i++){
              listDay.add(i.toString());
            }

            if (_hari[index] == "31"){
              _hari[index] = "30";
            }
          } else {
            listDay = [];
            for(int i = 1; i <= 31; i++){
              listDay.add(i.toString());
            }
          }
        } else {
          if (int.parse(mount) % 2 == 1){
            listDay = [];
            for(int i = 1; i <= 30; i++){
              listDay.add(i.toString());
            }

            if (_hari[index] == "31"){
              _hari[index] = "30";
            }
          } else {
            listDay = [];
            for(int i = 1; i <= 31; i++){
              listDay.add(i.toString());
            }
          }
        }
      }
    } catch (error){
      print(error.toString());
    }
  }

  _storeData(){
    DatabaseReference database = _database.reference().child("hilang_kk").push();
    var anggota = [];
//    setState(() {
//      kondisiKirim = "Mengirim Data...";
//    });
    _storeUpload().whenComplete((){
      setState(() {
        kondisiKirim = "Mengirim Data...";
      });
      for(int i = 0; i < jumlahKeluarga; i++){
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
      database.set({
        'idUser' : this.user.Key,
        'kepalaKeluarga' : this.kepalaKeluarga,
        'accKelurahan' : false,
        'accKecamatan' : false,
        'reject' : '',
        'rejectKeterangan' : '',
        'alamat' : alamat,
        'rt' : rt,
        'rw' : rw,
        'kecamatan' : kecamatan,
        'kelurahan' : kelurahan,
        'date' : new DateTime.now().year.toString() + "-" + new DateTime.now().month.toString() +
            "-" + new DateTime.now().day.toString() + " " + new DateTime.now().hour.toString() + ":" + new DateTime.now().minute.toString(),
        'anggotaKeluarga' : anggota,
        'image' : {
          'kk' : _urlKK,
          'ktp' : _urlKtp,
          'kehilangan' : _urlKehilanganPolisi,
          'pengantar' : _urlPengantarRtRw,
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

  Future<Null> _storeUpload () async {
    String rand = randomNumeric(10);

    setState(() {
      kondisiKirim = "Upload Gambar...";
    });

    final StorageReference firebaseRefKK = FirebaseStorage.instance.ref().child("kkHilang_kk_" + rand);
    await firebaseRefKK.putFile(_imageKK).onComplete.then((kk) {
      kk.ref.getDownloadURL().then((url){
        this._urlKK = url.toString();
      });
    }, onError: (err){
      setState(() {
        kirimData = false;
      });
      Fluttertoast.showToast(msg: "maaf terjadi kesalahan upload");
    });

    final StorageReference firebaseRefKtp = FirebaseStorage.instance.ref().child("kkHilang_ktp_" + rand);
    await firebaseRefKtp.putFile(_imageKtp).onComplete.then((ktp) {
      ktp.ref.getDownloadURL().then((url){
        this._urlKtp = url.toString();
      });
    }, onError: (err){
      setState(() {
        kirimData = false;
      });
      Fluttertoast.showToast(msg: "maaf terjadi kesalahan upload");
    });

    final StorageReference firebaseRefKehilangan = FirebaseStorage.instance.ref().child("kkHilang_kehilangan_" + rand);
    await firebaseRefKehilangan.putFile(_imageKehilanganPolisi).onComplete.then((kehilangan) {
      kehilangan.ref.getDownloadURL().then((url){
        this._urlKehilanganPolisi = url.toString();
      });
    }, onError: (err){
      setState(() {
        kirimData = false;
      });
      Fluttertoast.showToast(msg: "maaf terjadi kesalahan upload");
    });

    final StorageReference firebaseRefPengantar = FirebaseStorage.instance.ref().child("kkHilang_pengantar_" + rand);
    await firebaseRefPengantar.putFile(_imagePengantarRtRw).onComplete.then((pengantar) {
      pengantar.ref.getDownloadURL().then((url){
        this._urlPengantarRtRw = url.toString();
      });
    }, onError: (err){
      setState(() {
        kirimData = false;
      });
      Fluttertoast.showToast(msg: "maaf terjadi kesalahan upload");
    });

    for(int i = 0; i < 1; i++){
      StorageReference firebaseRef = FirebaseStorage.instance.ref().child("kkHilang_dummy");
      await firebaseRef.putFile(_imagePengantarRtRw).onComplete.then((dumm) {

      }, onError: (err){
        setState(() {
          kirimData = false;
        });
        Fluttertoast.showToast(msg: "maaf terjadi kesalahan upload");
      });
    }
  }

  List<Widget> _switchForm(int pos){
    switch (pos) {
      case 0:
        return _widgetForm1(MediaQuery.of(context).size.width / 22);
        break;
      case 1:
        return _widgetForm2(MediaQuery.of(context).size.width / 22);
        break;
      case 2:
        return _widgetForm3(MediaQuery.of(context).size.width / 22);
        break;
    }
  }

  void _setInputForm1(){
    _namaKepalaController.text = kepalaKeluarga;
    _alamatController.text = alamat;
    _rtController.text = rt;
    _rwController.text = rw;
    _jumlahKeluargaController.text = jumlahKeluarga.toString();
  }

  bool _cekInputForm1(){
    if(_namaKepalaController.text == "" || _alamatController.text == "" || _rtController.text == "" ||
        _rwController.text == "" || _jumlahKeluargaController.text == "" || kecamatan == "" || kelurahan == ""){
      Fluttertoast.showToast(msg: "semua data harus diisi!!", toastLength: Toast.LENGTH_SHORT);
      return false;
    } else if (int.parse(_jumlahKeluargaController.text) >= 100 || int.parse(_jumlahKeluargaController.text) < 1){
      Fluttertoast.showToast(msg: "isi jumlah keluarga dengan benar");
      return false;
    } else {
      kepalaKeluarga = _namaKepalaController.text;
      alamat = _alamatController.text;
      rt = _rtController.text;
      rw = _rwController.text;
      jumlahKeluarga = int.parse(_jumlahKeluargaController.text);
      return true;
    }
  }

  bool _cekInputForm2(){
    bool cek = true;
    for(int i = 0; i < jumlahKeluarga ; i++){
      if (listDataKeluarga[i].nama == "" || listDataKeluarga[i].alamatSblm == "" || listDataKeluarga[i].ttl == "" ||
          listDataKeluarga[i].jenisKelamin == "" || listDataKeluarga[i].tempatLahir == "" || listDataKeluarga[i].umur == "" ||
          listDataKeluarga[i].golDarah == "" || listDataKeluarga[i].agama == "" || listDataKeluarga[i].statusKawin == "" ||
          listDataKeluarga[i].statusHub == "" || listDataKeluarga[i].kelainanFisik == "" || listDataKeluarga[i].penyandangCacat == "" ||
          listDataKeluarga[i].pendidikanTerakhir == "" || listDataKeluarga[i].pekerjaan == "" || listDataKeluarga[i].namaIbu == "" ||
          listDataKeluarga[i].namaAyah == ""){
        int no = i + 1;
        Fluttertoast.showToast(msg: "Semua data anggota keluarga harus diisi", toastLength: Toast.LENGTH_SHORT);
        cek = false;
      } else if (listDataKeluarga[i].noKtpPen != ""){
        if (listDataKeluarga[i].noKtpPen.length != 16){
          Fluttertoast.showToast(msg: "No Ktp/Pend harus 16 digit", toastLength: Toast.LENGTH_SHORT).whenComplete((){
            Fluttertoast.showToast(msg: "Jika belum memiliki bisa dikosongkan", toastLength: Toast.LENGTH_SHORT);
          });
          cek = false;
        }
      }

      if (!cek){
        break;
      }
    }
    return cek;
  }

  bool _cekInputForm3(){
    bool cek = true;
    if (_imagePengantarRtRw == null){
      Fluttertoast.showToast(msg: "surat pengantar RT/RW harus diisi");
      cek = false;
    } else if (_imageKtp == null){
      Fluttertoast.showToast(msg: "ktp kepala/anggota keluarga harus diisi");
      cek = false;
    }

    return cek;
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

  getImageKtp () async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (image.lengthSync() > 10000000) {
        Fluttertoast.showToast(
            msg: "minimal gambar ukuran 1MB", toastLength: Toast.LENGTH_SHORT);
      } else {
        setState(() {
          _imageKtp = image;
        });
      }
    }
  }

  getKehilanganPolisi() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (image.lengthSync() > 10000000) {
        Fluttertoast.showToast(
            msg: "minimal gambar ukuran 1MB", toastLength: Toast.LENGTH_SHORT);
      } else {
        setState(() {
          _imageKehilanganPolisi = image;
        });
      }
    }
  }

  getPengantarRtRw() async{
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
                  kirimData = true;
                });
                _storeData();
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
                _setInputForm1();
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
                if (_cekInputForm2()){
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

  List<Widget> _widgetForm1 (double fontForm){
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
          controller: _namaKepalaController,
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
              kepalaKeluarga = val;
            });
          },
        ),
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              kepalaKeluarga == "" ?
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
            hintText: "alamat rumah sekarang",
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
      ), new Container(
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
          keyboardType: TextInputType.number,
          onChanged: (val){
            setState(() {
              rt = val;
            });
          },
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
      ),new Container(
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
          keyboardType: TextInputType.number,
          onChanged: (val){
            setState(() {
              rw = val;
            });
          },
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
      ), new Container(
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
      ),  new Container(
        alignment: Alignment.centerLeft,
        child: new Text("Jumlah Keluarga :"),
        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
      ), new Container(
        margin: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width / 1,
        alignment: Alignment.center,
        child: new TextField(
          controller: _jumlahKeluargaController,
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
          keyboardType: TextInputType.number,
          onChanged: (val){
            if (val == ""){
              setState(() {
                jumlahKeluarga = 0;
              });
            } else {
              setState(() {
                jumlahKeluarga = int.parse(val);
              });
            }
          },
        ),
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              jumlahKeluarga == 0 ?
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
    ];
  }

  List<Widget> _widgetForm2 (double fontForm){
    List<Widget> list = [];
    if (listDataKeluarga.length == 0){
      for(int i = 0; i < jumlahKeluarga; i++){
        listDataKeluarga.add(new DataKeluarga());
        _namaController.add(new TextEditingController());
        _noKtpPenController.add(new TextEditingController());
        _alamatSblmControlller.add(new TextEditingController());
        _tempatLahirController.add(new TextEditingController());
        _umurController.add(new TextEditingController());
        _golDarahController.add(new TextEditingController());
        _agamaController.add(new TextEditingController());
        _statusKawinController.add(new TextEditingController());
        _statusHubController.add(new TextEditingController());
        _kelainanFisikController.add(new TextEditingController());
        _penyandangCacatController.add(new TextEditingController());
        _pendidikanTerakhirController.add(new TextEditingController());
        _pekerjaanController.add(new TextEditingController());
        _namaIbuController.add(new TextEditingController());
        _namaAyahController.add(new TextEditingController());

        dobKeyDate.add(new GlobalKey<DatePickerState>());

        _hari.add("");
        _bulan.add("");
        _tahun.add("");
      }
    } else {
      if (listDataKeluarga.length < jumlahKeluarga){
        int jumlah = jumlahKeluarga - listDataKeluarga.length;
        for(int i = 0; i < jumlah; i++){
          listDataKeluarga.add(new DataKeluarga());
          _namaController.add(new TextEditingController());
          _noKtpPenController.add(new TextEditingController());
          _alamatSblmControlller.add(new TextEditingController());
          _tempatLahirController.add(new TextEditingController());
          _umurController.add(new TextEditingController());
          _golDarahController.add(new TextEditingController());
          _agamaController.add(new TextEditingController());
          _statusKawinController.add(new TextEditingController());
          _statusHubController.add(new TextEditingController());
          _kelainanFisikController.add(new TextEditingController());
          _penyandangCacatController.add(new TextEditingController());
          _pendidikanTerakhirController.add(new TextEditingController());
          _pekerjaanController.add(new TextEditingController());
          _namaIbuController.add(new TextEditingController());
          _namaAyahController.add(new TextEditingController());

          dobKeyDate.add(new GlobalKey<DatePickerState>());

          _hari.add("");
          _bulan.add("");
          _tahun.add("");
        }
      }
    }

    for (int i = 1; i <= jumlahKeluarga; i++){
      list.add(
          new ExpansionTile(
              initiallyExpanded: false,
              title: new Text(
                  i == 1 ? listDataKeluarga[i-1].nama == "" ? "1.Kepala Keluarga" : "1." + listDataKeluarga[i-1].nama
                      : listDataKeluarga[i-1].nama == "" ? i.toString() + ".Anggota Keluarga" : i.toString() + "." + listDataKeluarga[i-1].nama
              ),
              children: [
                new Container(
                  alignment: Alignment.centerLeft,
                  child: new Text(
                      i == 1 ? "Nama Kepala :" : "Nama :"
                  ),
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                ), new Container(
                  margin: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width / 1,
                  alignment: Alignment.center,
                  child: new TextField(
                    controller: _namaController[i-1],
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
                        listDataKeluarga[i-1].setNama = val;
                      });
                    },
                  ),
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        listDataKeluarga[i-1].nama == "" ?
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
                  child: new Text("No Ktp/Pend :"),
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                ), new Container(
                  margin: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width / 1,
                  alignment: Alignment.center,
                  child: new TextField(
                    controller: _noKtpPenController[i-1],
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: fontForm,
                      color: Colors.black54,
                    ),
                    decoration: new InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: fontForm - 5,
                      ),
                      hintText: "no ktp atau no penduduk lama",
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (val){
                      setState(() {
                        listDataKeluarga[i-1].setNoKtpPen = val;
                      });
                    },
                  ),
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        listDataKeluarga[i-1].noKtpPen == "" ?
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
                  child: new Text("Alamat Sebelumnya :"),
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                ), new Container(
                  margin: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width / 1,
                  alignment: Alignment.center,
                  child: new TextField(
                    controller: _alamatSblmControlller[i-1],
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: fontForm,
                      color: Colors.black54,
                    ),
                    onChanged: (val){
                      setState(() {
                        listDataKeluarga[i-1].setAlamatSblm = val;
                      });
                    },
                    decoration: new InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: fontForm - 5,
                      ),
                      hintText: "alamat sebelumnya",
                      border: InputBorder.none,
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        listDataKeluarga[i-1].alamatSblm == "" ?
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
                ),new Container(
                  alignment: Alignment.centerLeft,
                  child: new Text("Jenis Kelamin :"),
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                ), new Container(
                  margin: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width / 1,
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton(
                      hint: new Text(
                        listDataKeluarga[i-1].jenisKelamin == "" ? "jenis kelamin" : listDataKeluarga[i-1].jenisKelamin,
                        style: TextStyle(
                            fontSize: fontForm - 3
                        ),
                        textAlign: TextAlign.center,
                      ),
                      items: ["Pria", "Wanita"].map((String value) {
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
                          listDataKeluarga[i-1].setJenisKelamin = value;
                        });
                      },
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        listDataKeluarga[i-1].jenisKelamin == "" ?
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
                  child: new Text("Tempat Lahir :"),
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                ), new Container(
                  margin: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width / 1,
                  alignment: Alignment.center,
                  child: new TextField(
                    controller: _tempatLahirController[i-1],
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: fontForm,
                      color: Colors.black54,
                    ),
                    decoration: new InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: fontForm - 5,
                      ),
                      hintText: "tempat lahir",
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        listDataKeluarga[i-1].setTempatLahir = value;
                      });
                    },
                  ),
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        listDataKeluarga[i-1].tempatLahir == "" ?
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
                  child: new Text("Tanggal Lahir :"),
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                ), new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      margin: const EdgeInsets.all(10.0),
                      child: new DropdownButtonHideUnderline(
                        child: new DropdownButton(
                          hint: new Text(
                            _hari[i-1]  == "" ? "hari" : _hari[i-1],
                            style: TextStyle(
                                fontSize: fontForm - 3
                            ),
                            textAlign: TextAlign.center,
                          ),
                          items: listDay.map((String value) {
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
                              _hari[i-1] = value;
                              if (_tahun[i-1] != "" && _bulan[i-1] != ""){
                                listDataKeluarga[i-1].setTtl = _hari[i-1] + "/" + _bulan[i-1] + "/" + _tahun[i-1];
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
                            _hari[i-1] == "" ?
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
                    ),new Container(
                      margin: const EdgeInsets.all(10.0),
                      child: new DropdownButtonHideUnderline(
                        child: new DropdownButton(
                          hint: new Text(
                            _bulan[i-1]  == "" ? "bulan" : _bulan[i-1],
                            style: TextStyle(
                                fontSize: fontForm - 3
                            ),
                            textAlign: TextAlign.center,
                          ),
                          items: listMonth.map((String value) {
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
                              _bulan[i-1] = value;
                              if (_tahun[i-1] != "" && _hari[i-1] != ""){
                                listDataKeluarga[i-1].setTtl = _hari[i-1] + "/" + _bulan[i-1] + "/" + _tahun[i-1];
                              }
                              int index = i-1;
                              _setListDay(index, _bulan[i-1], _tahun[i-1]);
                            });
                          },
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: [
                            _bulan[i-1] == "" ?
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
                      margin: const EdgeInsets.all(10.0),
                      child: new DropdownButtonHideUnderline(
                        child: new DropdownButton(
                          hint: new Text(
                            _tahun[i-1]  == "" ? "tahun" : _tahun[i-1],
                            style: TextStyle(
                                fontSize: fontForm - 3
                            ),
                            textAlign: TextAlign.center,
                          ),
                          items: listYear.map((String value) {
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
                              _tahun[i-1] = value;
                              if (_bulan[i-1] != "" && _hari[i-1] != ""){
                                listDataKeluarga[i-1].setTtl = _hari[i-1] + "/" + _bulan[i-1] + "/" + _tahun[i-1];
                              }
                              int index = i-1;
                              _setListDay(index, _bulan[i-1], _tahun[i-1]);
                            });
                          },
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: [
                            _tahun[i-1] == "" ?
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
                ), new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Expanded(
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            child: new Text("Umur :"),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                          ), new Container(
                            margin: const EdgeInsets.all(10.0),
                            child: new TextField(
                              controller: _umurController[i-1],
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: fontForm,
                                color: Colors.black54,
                              ),
                              decoration: new InputDecoration(
                                hintStyle: TextStyle(
                                  fontSize: fontForm - 5,
                                ),
                                hintText: "umur",
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  listDataKeluarga[i-1].setUmur = value;
                                });
                              },
                            ),
                            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                boxShadow: [
                                  listDataKeluarga[i-1].umur == "" ?
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
                    ), new Expanded(
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Container(
                              child: new Text("Golongan Darah :"),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                            ), new Container(
                              margin: const EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width / 1,
                              child: new DropdownButtonHideUnderline(
                                child: new DropdownButton(
                                  hint: new Text(
                                    listDataKeluarga[i-1].golDarah  == "" ? "golongan darah" : listDataKeluarga[i-1].golDarah,
                                    style: TextStyle(
                                        fontSize: fontForm - 3
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  items: ["A", "B", "AB", "O", "A +", "A -", "B +", "B -", "AB +", "AB -", "O +", "O -",
                                  "Tidak Tahu"].map((String value) {
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
                                      listDataKeluarga[i-1].setGolDarah = value;
                                    });
                                  },
                                ),
                              ),
                              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  boxShadow: [
                                    listDataKeluarga[i-1].golDarah == "" ?
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
                    ),
                  ],
                ), new Row(
                  children: <Widget>[
                    new Expanded(
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              alignment: Alignment.centerLeft,
                              child: new Text("Agama :"),
                              padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                            ), new Container(
                              margin: const EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width / 1,
                              child: new DropdownButtonHideUnderline(
                                child: new DropdownButton(
                                  hint: new Text(
                                    listDataKeluarga[i-1].agama  == "" ? "agama" : listDataKeluarga[i-1].agama,
                                    style: TextStyle(
                                        fontSize: fontForm - 3
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  items: ["Islam", "Kristen", "Katolik", "Hindu", "Buddha", "Kong Hu Cu", "Kepercayaan"].map((String value) {
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
                                      listDataKeluarga[i-1].setAgama = value;
                                    });
                                  },
                                ),
                              ),
                              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  boxShadow: [
                                    listDataKeluarga[i-1].agama == "" ?
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
                    ), new Expanded(
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              alignment: Alignment.centerLeft,
                              child: new Text("Status Kawin :"),
                              padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                            ), new Container(
                              margin: const EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width / 1,
                              child: new DropdownButtonHideUnderline(
                                child: new DropdownButton(
                                  hint: new Text(
                                    listDataKeluarga[i-1].statusKawin  == "" ? "status kawin" : listDataKeluarga[i-1].statusKawin,
                                    style: TextStyle(
                                        fontSize: fontForm - 3
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  items: ["Belum Kawin", "Kawin", "Cerai Hidup", "Cerai Mati"].map((String value) {
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
                                      listDataKeluarga[i-1].setStatusKawin = value;
                                    });
                                  },
                                ),
                              ),
                              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  boxShadow: [
                                    listDataKeluarga[i-1].statusKawin == "" ?
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
                    )
                  ],
                ), new Container(
                  alignment: Alignment.centerLeft,
                  child: new Text("Status Hubungan :"),
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                ), new Container(
                  margin: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width / 1,
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton(
                      hint: new Text(
                        listDataKeluarga[i-1].statusHub  == "" ? "status hubungan dengan kepala keluarga"
                            : listDataKeluarga[i-1].statusHub,
                        style: TextStyle(
                            fontSize: fontForm - 3
                        ),
                        textAlign: TextAlign.center,
                      ),
                      items: ["Kepala Keluarga", "Suami", "Istri", "Anak", "Menantu", "Cucu", "Orang Tua", "Mertua",
                      "Famili Lain", "Pembantu", "Lainnya"].map((String value) {
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
                          listDataKeluarga[i-1].setStatusHub = value;
                        });
                      },
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        listDataKeluarga[i-1].statusHub == "" ?
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
                    new Expanded(
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              alignment: Alignment.centerLeft,
                              child: new Text("Kelainan Fisik :"),
                              padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                            ), new Container(
                              margin: const EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width / 1,
                              child: new DropdownButtonHideUnderline(
                                child: new DropdownButton(
                                  hint: new Text(
                                    listDataKeluarga[i-1].kelainanFisik  == "" ? "kelainan fisik"
                                        : listDataKeluarga[i-1].kelainanFisik,
                                    style: TextStyle(
                                        fontSize: fontForm - 3
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  items: ["Ada", "Tidak Ada"].map((String value) {
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
                                      listDataKeluarga[i-1].setKelainanFisik = value;
                                    });
                                  },
                                ),
                              ),
                              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  boxShadow: [
                                    listDataKeluarga[i-1].kelainanFisik == "" ?
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
                    ), new Expanded(
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              alignment: Alignment.centerLeft,
                              child: new Text("Cacat :"),
                              padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                            ), new Container(
                              margin: const EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width / 1,
                              child: new DropdownButtonHideUnderline(
                                child: new DropdownButton(
                                  hint: new Text(
                                    listDataKeluarga[i-1].penyandangCacat  == "" ? "cacat"
                                        : listDataKeluarga[i-1].penyandangCacat,
                                    style: TextStyle(
                                        fontSize: fontForm - 3
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  items: ["Cacat Fisik", "Cacat Netra", "Cacat Rungu", "Cacat Mental",
                                  "Cacat Lainnya", "Tidak Ada"].map((String value) {
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
                                      listDataKeluarga[i-1].setPenyandangCacat = value;
                                    });
                                  },
                                ),
                              ),
                              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  boxShadow: [
                                    listDataKeluarga[i-1].penyandangCacat == "" ?
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
                    ),
                  ],
                ), new Container(
                  alignment: Alignment.centerLeft,
                  child: new Text("Pendidikan Terakhir :"),
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                ), new Container(
                  margin: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width / 1,
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton(
                      hint: new Text(
                        listDataKeluarga[i-1].pendidikanTerakhir  == "" ? "pendidikan terakhir"
                            : listDataKeluarga[i-1].pendidikanTerakhir,
                        style: TextStyle(
                            fontSize: fontForm - 3
                        ),
                        textAlign: TextAlign.center,
                      ),
                      items: ["Tidak/Belum Sekolah", "Belum Tamat SD", "Tamat SD", "SLTP/Sederajat", "SLTA/Sederajat",
                      "Diploma I/II", "Akademi/Diploma III", "Diploma IV", "Strata I", "Strata II", "Strata III"].map((String value) {
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
                          listDataKeluarga[i-1].setPendidikanTerakhir = value;
                        });
                      },
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        listDataKeluarga[i-1].pendidikanTerakhir == "" ?
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
                  child: new Text("Pekerjaan :"),
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                ), new Container(
                  margin: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width / 1,
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton(
                      hint: new Text(
                        listDataKeluarga[i-1].pekerjaan  == "" ? "pekerjaan"
                            : listDataKeluarga[i-1].pekerjaan,
                        style: TextStyle(
                            fontSize: fontForm - 3
                        ),
                        textAlign: TextAlign.center,
                      ),
                      items: ["Belum/Tidak Bekerja", "Mengurus Rumah Tangga", "Pelajar/Mahasiswa",
                      "Pensiunan", "PNS", "TNI", "POLRI", "Perdagangan", "Petani/Pekebun", "Peternak", "Nelayan/Perikanan",
                      "Industri", "Konstruksi", "Transportasi", "Karyawan Swasta", "Karyawan BUMN", "Karyawan BUMD",
                      "Karyawan Honorer", "Buruh Harian Lepas", "Buruh Tani/Perkebunan", "Buruh Nelayan/Perikanan",
                      "Buruh Peternakan" ,"Pembantu Rumah Tangga", "Tukang Cukur", "Tukang Listrik", "Tukang Batu", "Tukang Kayu",
                      "Tukang Sol Sepatu", "Tukang Las", "Tukang Jahit", "Tukang Gigi", "Penata Rias", "Penata Busana", "Penata Rambut",
                      "Mekanik", "Seniman", "Tabib", "Paraji", "Perancang Busana", "Penterjemah", "Imam Masjid", "Pendeta", "Pastor",
                      "Wartawan", "Ustadz/Mubaligh", "Juru Masak", "Promotor Acara", "Anggota DPR-RI", "Anggota DPD", "Anggota BPK",
                      "Presiden", "Wakil Presiden", "Anggota MK", "Anggota Mentri", "Duta Besar", "Gubernur", "Wakil Gubernur",
                      "Bupati", "Wakil Bupati", "Walikota", "Wakil walikota", "Anggota DPRD", "Dosen", "Guru", "Pilot", "Pengacara",
                      "Notaris", "Arsitek", "Akuntan", "Konsultan", "Dokter", "Bidan", "Perawat", "Apoteker","Psikiater/Psikolog",
                      "Penyiar Televisi", "Penyiar Radio", "Pelaut", "Peneliti", "Sopir", "Pialang", "Paranormal", "Pedagang",
                      "Perangkat Desa", "Kepala desa", "Biarawati", "Wiraswasta"].map((String value) {
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
                          listDataKeluarga[i-1].setPekerjaan = value;
                        });
                      },
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        listDataKeluarga[i-1].pekerjaan == "" ?
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
                  child: new Text("Nama Ayah :"),
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                ), new Container(
                  margin: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width / 1,
                  alignment: Alignment.center,
                  child: new TextField(
                    controller: _namaAyahController[i-1],
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: fontForm,
                      color: Colors.black54,
                    ),
                    decoration: new InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: fontForm - 5,
                      ),
                      hintText: "nama ayah bersangkutan",
                      border: InputBorder.none,
                    ),
                    onChanged: (val){
                      setState(() {
                        listDataKeluarga[i-1].setNamaAyah = val;
                      });
                    },
                  ),
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        listDataKeluarga[i-1].namaAyah == "" ?
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
                  child: new Text("Nama Ibu :"),
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                ), new Container(
                  margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 30.0),
                  width: MediaQuery.of(context).size.width / 1,
                  alignment: Alignment.center,
                  child: new TextField(
                    controller: _namaIbuController[i-1],
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: fontForm,
                      color: Colors.black54,
                    ),
                    decoration: new InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: fontForm - 5,
                      ),
                      hintText: "nama ibu bersangkutan",
                      border: InputBorder.none,
                    ),
                    onChanged: (val){
                      setState(() {
                        listDataKeluarga[i-1].setNamaIbu = val;
                      });
                    },
                  ),
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        listDataKeluarga[i-1].namaIbu == "" ?
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
              ]
          )
      );
    }
    return list;
  }


  List<Widget> _widgetForm3(double fontForm){
    return <Widget> [
      new Container(
          margin: const EdgeInsets.all(15.0),
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text(
                    "Kartu Keluarga (Jika ada)",
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
                    "KTP Kepala/Anggota",
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
                      onPressed: _showHelpKtp
                  ),
                ],
              ),
              new Container(
                child: _imageKtp == null
                    ? new Text('Gambar Belum Dipilih.')
                    : new Image.file(
                  _imageKtp,
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                )
                ,margin: const EdgeInsets.only(bottom: 10.0, top: 5.0),
              )
              , new RaisedButton(
                onPressed: getImageKtp,
                color: Color(0xff30a8ff),
                splashColor: Colors.white10,
                elevation: 4,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                child: Text(
                  "KTP",
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
                    "Surat Kehilangan (Jika KK Hilang)",
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
                      onPressed: _showHelpKehilangan
                  ),
                ],
              ),
              new Container(
                child: _imageKehilanganPolisi == null
                    ? new Text('Gambar Belum Dipilih.')
                    : new Image.file(
                  _imageKehilanganPolisi,
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                )
                ,margin: const EdgeInsets.only(bottom: 10.0, top: 5.0),
              )
              , new RaisedButton(
                onPressed: getKehilanganPolisi,
                color: Color(0xff30a8ff),
                splashColor: Colors.white10,
                elevation: 4,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                child: Text(
                  "Kehilangan",
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
                      onPressed: _showHelpPengantar
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
                onPressed: getPengantarRtRw,
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
      )
    ];
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

    _showBottomSheetCallback = null;
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

  Future<bool> _showHelpKtp(){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('KTP'),
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

  Future<bool> _showHelpKehilangan(){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Surat Kehilangan Polisi'),
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

  Future<bool> _showHelpPengantar(){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Pengantar Surat Hilang/Rusak'),
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
                backgroundColorEnd: Color(0xff4b72f2),
                leading: new IconButton(
                    icon: new Icon(
                      Icons.menu,
                      size: 30.0,
                      color: Colors.white70,
                    ),
                    onPressed: (){
                      _scaffoldStateKey.currentState.openDrawer();
                    }
                ),
                title: new Align(
                  alignment: Alignment(-0.15, 0),
                  child: new Text (
                    "KK Hilang/Rusak",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              drawer: new Ddrawer(firebaseUser: widget.firebaseUser),
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
                                posForm == 0 ?  "Data KK" : posForm == 1 ? "DATA KELUARGA" : "UPLOAD KELENGKAPAN"
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
                                          color: posForm == 2 ? Colors.white : Color(0xff639fff),
                                        ),
                                      ),
                                      backgroundColor: posForm == 2 ? Color(0xff639fff) : Colors.white,
                                    ),
                                    width: fontForm * 2.5,
                                    height: fontForm * 2.5,
                                    padding: const EdgeInsets.all(1.0),
                                    decoration: new BoxDecoration(
                                        color: posForm == 2 ? Color(0xff639fff) : Colors.black,
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
}