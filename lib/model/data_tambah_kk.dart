import 'package:kk_helper/model/data_keluarga.dart';

class DataTambahKK {
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
  String _ketDomisili;
  List<String> _aktaKawin;
  List<String> _pekerjaan;
  List<String> _pindahdatang;
  String _key;
  String _kepalaKeluarga;

  DataTambahKK(){
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
    this._ketDomisili = "";
    this._aktaKawin = [];
    this._pekerjaan = [];
    this._pindahdatang = [];
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
  String get ketDomisili => this._ketDomisili;
  List<String> get aktaKawin => this._aktaKawin;
  List<String> get pekerjaan => this._pekerjaan;
  List<String> get pindahDaatng => this._pindahdatang;
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
  set setKetDomisili(String ketDomisili) => this._ketDomisili = ketDomisili;
  set setAktaKawin(List<String> aktaKawin) => this._aktaKawin = aktaKawin;
  set setPekerjaan(List<String> pekerjaan) => this._pekerjaan = pekerjaan;
  set setPindahDatang(List<String> pindahDatang) => this._pindahdatang = pindahDatang;
  set setKey(String key) => this._key = key;
  set setKepalaKeluarga(String kepalaKeluarga) => this._kepalaKeluarga = kepalaKeluarga;
}