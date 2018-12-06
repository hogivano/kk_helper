import 'package:kk_helper/model/data_keluarga.dart';

class DataHilangKK {
  bool _accKecamatan;
  bool _accKelurahan;
  String _alamat;
  List<DataKeluarga> _anggotaKeluarga;
  String _date;
  String _idUser;
  String _kecamatan;
  String _kelurahan;
  String _reject;
  String _rejectKeterangan;
  String _rt;
  String _rw;
  String _kkLama;
  String _ktp;
  String _kehilanganPolisi;
  String _pengantarRtRw;
  String _key;
  String _kepalaKeluarga;

  DataHilangKK(){
    this._accKecamatan = false;
    this._accKelurahan = false;
    this._alamat = "";
    this._anggotaKeluarga = [];
    this._date = "";
    this._idUser = "";
    this._kecamatan = "";
    this._kelurahan = "";
    this._reject = "";
    this._rejectKeterangan = "";
    this._rt = "";
    this._rw = "";
    this._kkLama = "";
    this._ktp = "";
    this._kehilanganPolisi = "";
    this._pengantarRtRw = "";
    this._key = "";
    this._kepalaKeluarga = "";
  }

  bool get accKecamatan => this._accKecamatan;
  bool get accKelurahan => this._accKelurahan;
  String get alamat => this._alamat;
  List<DataKeluarga> get anggotaKeluarga => this._anggotaKeluarga;
  String get date => this._date;
  String get idUser => this._idUser;
  String get kecamatan => this._kecamatan;
  String get kelurahan => this._kelurahan;
  String get reject => this._reject;
  String get rejectKeterangan => this._rejectKeterangan;
  String get rt => this._rt;
  String get rw => this._rw;
  String get kkLama => this._kkLama;
  String get ktp => this._ktp;
  String get kehilanganPolisi => this._kehilanganPolisi;
  String get pengantarRtRw => this._pengantarRtRw;
  String get key => this._key;
  String get kepalaKeluarga => this._kepalaKeluarga;

  set setAccKecamatan(bool accKecamatan) => this._accKecamatan = accKecamatan;
  set setaccKelurahan(bool accKelurahan) => this._accKelurahan = accKelurahan;
  set setAlamat(String alamat) => this._alamat = alamat;
  set setAnggotaKeluarga (List<DataKeluarga> anggotaKeluarga) => this._anggotaKeluarga = anggotaKeluarga;
  set setDate(String date) => this._date = date;
  set setIdUser(String idUser) => this._idUser = idUser;
  set setKecamatan(String kecamatan) => this._kecamatan = kecamatan;
  set setKelurahan(String kelurahan) => this._kelurahan = kelurahan;
  set setReject(String reject) => this._reject = reject;
  set setRejectKeterangan(String rejectKeterangan) => this._rejectKeterangan = rejectKeterangan;
  set setRt(String rt) => this._rt = rt;
  set setRw(String rw) => this._rw = rw;
  set setKKLama(String kkLama) => this._kkLama = kkLama;
  set setKtp(String ktp) => this._ktp = ktp;
  set setKehilanganPolisi(String kehilanganPolisi) => this._kehilanganPolisi = kehilanganPolisi;
  set setPengantarRtRw(String pengantarRtRw) => this._pengantarRtRw = pengantarRtRw;
  set setKey(String key) => this._key = key;
  set setKepalaKeluarga(String kepalaKeluarga) => this._kepalaKeluarga = kepalaKeluarga;
}