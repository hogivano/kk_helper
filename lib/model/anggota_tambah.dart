class AnggotaTambah2{
  String _nama;
  String _nik;
  String _alasanKurang;

  AnggotaTambah2(){
    this._nama = "";
    this._nik = "";
    this._alasanKurang = "";
  }

  String get nama => this._nama;
  String get nik => this._nik;
  String get alasanKurang => this._alasanKurang;

  set setNama(String nama) => this._nama = nama;
  set setNik(String nik) => this._nik = nik;
  set setAlasanKurang(String alasan) => this._alasanKurang = alasan;

  AnggotaTambah2.fromJson(Map<String, dynamic> json){
    _nama = json["nama"];
    _nik = json["nik"];
    _alasanKurang = json["alasanKurang"];
  }
}