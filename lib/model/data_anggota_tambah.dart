import 'package:kk_helper/model/anggota_tambah.dart';

class DataAnggotaTambah2 {
  bool _accKecamatan;
  bool _accKelurahan;
  String _alamat;
  List<AnggotaTambah2> _anggotaTambah;
  String _date;
  String _idUser;
  String _noKK;
  String _kecamatan;
  String _kelurahan;
  String _reject;
  String _rejectKeterangan;
  String _rt;
  String _rw;
  String _kk;
  String _pengantar;
  List<String> _kawin;
  List<String> _kkLama;
  List<String> _aktaKelahiran;
  String _key;
  String _kepalaKeluarga;

  DataAnggotaTambah2() {
    this._accKecamatan = false;
    this._accKelurahan = false;
    this._alamat = "";
    this._anggotaTambah = [];
    this._date = "";
    this._idUser = "";
    this._noKK = "";
    this._kecamatan = "";
    this._kelurahan = "";
    this._reject = "";
    this._rejectKeterangan = "";
    this._rt = "";
    this._rw = "";
    this._pengantar = "";
    this._kk = "";
    this._kawin = [];
    this._kkLama = [];
    this._aktaKelahiran = [];
    this._key = "";
    this._kepalaKeluarga = "";
  }

  bool get accKecamatan => this._accKecamatan;
  bool get accKelurahan => this._accKelurahan;
  String get alamat => this._alamat;
  List<AnggotaTambah2> get AnggotaTambah => this._anggotaTambah;
  String get date => this._date;
  String get idUser => this._idUser;
  String get noKK => this._noKK;
  String get kecamatan => this._kecamatan;
  String get kelurahan => this._kelurahan;
  String get reject => this._reject;
  String get rejectKeterangan => this._rejectKeterangan;
  String get rt => this._rt;
  String get rw => this._rw;
  String get kk => this._kk;
  String get pengantar => this._pengantar;
  List<String> get kkLama => this._kkLama;
  List<String> get aktaKelahiran => this._aktaKelahiran;
  List<String> get kawin => this._kawin;
  String get key => this._key;
  String get kepalaKeluarga => this._kepalaKeluarga;

  set setAccKecamatan(bool accKecamatan) => this._accKecamatan = accKecamatan;
  set setaccKelurahan(bool accKelurahan) => this._accKelurahan = accKelurahan;
  set setAlamat(String alamat) => this._alamat = alamat;
  set setAnggotaTambah(List<AnggotaTambah2> anggotaTambah) =>
      this._anggotaTambah = anggotaTambah;
  set setDate(String date) => this._date = date;
  set setIdUser(String idUser) => this._idUser = idUser;
  set setNoKK(String noKK) => this._noKK = noKK;
  set setKecamatan(String kecamatan) => this._kecamatan = kecamatan;
  set setKelurahan(String kelurahan) => this._kelurahan = kelurahan;
  set setReject(String reject) => this._reject = reject;
  set setRejectKeterangan(String rejectKeterangan) =>
      this._rejectKeterangan = rejectKeterangan;
  set setRt(String rt) => this._rt = rt;
  set setRw(String rw) => this._rw = rw;
  set setKK(String kk) => this._kk = kk;
  set setPengantar(String pengantar) => this._pengantar = pengantar;
  set setKKLama(List<String> kkLama) => this._kkLama = kkLama;
  set setAktaKelahiran(List<String> aktaKelahiran) =>
      this._aktaKelahiran = aktaKelahiran;
  set setKawin(List<String> kawin) =>
      this._kawin = kawin;
  set setKey(String key) => this._key = key;
  set setKepalaKeluarga(String kepalaKeluarga) =>
      this._kepalaKeluarga = kepalaKeluarga;
}
