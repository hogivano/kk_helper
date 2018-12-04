class DataKeluarga {
  String _nama;
  String _noKtpPen;
  String _alamatSblm;
  String _jenisKelamin;
  String _tempatLahir;
  String _ttl;
  String _umur;
  String _golDarah;
  String _agama;
  String _statusKawin;
  String _statusHub;
  String _kelainanFisik;
  String _penyandangCacat;
  String _pendidikanTerakhir;
  String _pekerjaan;
  String _namaIbu;
  String _namaAyah;

  DataKeluarga(){
    this._nama = "";
    this._noKtpPen = "";
    this._alamatSblm = "";
    this._jenisKelamin = "";
    this._tempatLahir = "";
    this._ttl = "";
    this._umur = "";
    this._golDarah = "";
    this._agama = "";
    this._statusKawin = "";
    this._statusHub = "";
    this._kelainanFisik = "";
    this._penyandangCacat = "";
    this._pendidikanTerakhir = "";
    this._pekerjaan = "";
    this._namaIbu ="";
    this._namaAyah = "";
  }

  String get nama => _nama;
  String get noKtpPen => _noKtpPen;
  String get alamatSblm => _alamatSblm;
  String get jenisKelamin => _jenisKelamin;
  String get tempatLahir => _tempatLahir;
  String get ttl => _ttl;
  String get umur => _umur;
  String get golDarah => _golDarah;
  String get agama => _agama;
  String get statusKawin => _statusKawin;
  String get statusHub => _statusHub;
  String get kelainanFisik => _kelainanFisik;
  String get penyandangCacat => _penyandangCacat;
  String get pendidikanTerakhir => _pendidikanTerakhir;
  String get pekerjaan => _pekerjaan;
  String get namaIbu => _namaIbu;
  String get namaAyah => _namaAyah;

  set setNama(String nama) => this._nama = nama;
  set setNoKtpPen(String noKtpPen) => this._noKtpPen = noKtpPen;
  set setAlamatSblm(String alamatSblm) => this._alamatSblm = alamatSblm;
  set setJenisKelamin(String jenisKelamin) => this._jenisKelamin = jenisKelamin;
  set setTempatLahir(String tempatLahir) => this._tempatLahir = tempatLahir;
  set setTtl (String ttl) => this._ttl = ttl;
  set setUmur (String umur) => this._umur = umur;
  set setGolDarah (String golDarah) => this._golDarah = golDarah;
  set setAgama (String agama) => this._agama = agama;
  set setStatusKawin (String statusKawin) => this._statusKawin = statusKawin;
  set setStatusHub (String statusHub) => this._statusHub = statusHub;
  set setKelainanFisik (String kelainanFisik) => this._kelainanFisik = kelainanFisik;
  set setPenyandangCacat (String penyandangCacat) => this._penyandangCacat = penyandangCacat;
  set setPendidikanTerakhir (String pendidikaTerakhir) => this._pendidikanTerakhir = pendidikaTerakhir;
  set setPekerjaan (String pekerjaan) => this._pekerjaan = pekerjaan;
  set setNamaIbu (String namaIbu) => this._namaIbu = namaIbu;
  set setNamaAyah (String namaAyah) => this._namaAyah = namaAyah;
}