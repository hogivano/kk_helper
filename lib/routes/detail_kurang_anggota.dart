import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:kk_helper/model/data_anggota_kurang.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailKurangAnggota extends StatefulWidget {
  final DataAnggotaKurang data;

  const DetailKurangAnggota({Key key, @required this.data})
      : assert(data != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _detailKurangAnggotaState();
}

class _detailKurangAnggotaState extends State<DetailKurangAnggota> {
  final GlobalKey<ScaffoldState> _scaffoldStateKey = new GlobalKey<ScaffoldState>();

  List<Widget> _getListUpload(){
    return <Widget> [
      new Container(
          margin: const EdgeInsets.all(15.0),
          child: new Column(
            children: <Widget>[
              new Container(
                child: new Text(
                  "1. Kartu Keluarga",
                ), alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(bottom: 10.0),
              ),
              new Container(
                child: new Image.network (
                  widget.data.kk,
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ), margin: const EdgeInsets.only(bottom: 10.0, top: 5.0),
              )
            ],
          )
      ), new Container(
          margin: const EdgeInsets.all(15.0),
          child: new Column(
            children: <Widget>[
              new Container(
                child: new Text(
                  "2. Surat Pengantar RT/RW",
                ), alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(bottom: 10.0),
              ),
              new Container(
                child: new Image.network (
                  widget.data.pengantar,
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ), margin: const EdgeInsets.only(bottom: 10.0, top: 5.0),
              )
            ],
          )
      ), new Container(
        margin: const EdgeInsets.all(15.0),
        child: new Column(
          children: <Widget>[
            new Container(
              child: new Text(
                "3. Surat Keterangan Pindah",
              ), alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(bottom: 10.0),
            ),
            widget.data.pindah.length > 0 ?new CarouselSlider(
              items: widget.data.pindah.map( (file) {
                return new Builder(
                  builder: (BuildContext context) {
                    return new Container(
                      width: MediaQuery.of(context).size.width,
                      margin: new EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: new BoxDecoration(
                          color: Colors.white
                      ),
                        child: new Image.network (
                          file,
                          height: 200.0,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        )
                    );
                  },
                );
              }).toList(),
              height: 200.0,
            ) : new Container(
              child: new Text(
                "gambar tidak ada",
              ), alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 10.0),
            ),
          ],
        ),
      ), new Container(
        margin: const EdgeInsets.all(15.0),
        child: new Column(
          children: <Widget>[
            new Container(
              child: new Text(
                "4. Surat Keterangan Kematian",
              ), alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(bottom: 10.0),
            ),
            widget.data.kematian.length > 0 ? new CarouselSlider(
              items: widget.data.kematian.map( (file) {
                return new Builder(
                  builder: (BuildContext context) {
                    return new Container(
                      width: MediaQuery.of(context).size.width,
                      margin: new EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: new BoxDecoration(
                          color: Colors.white
                      ),
                      child: new Image.network (
                        file,
                        height: 200.0,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      )
                    );
                  },
                );
              }).toList(),
              height: 200.0,
            ) : new Container(
              child: new Text(
                "gambar tidak ada",
              ), alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 10.0),
            ),
          ],
        ),
      )
    ];
  }

  Widget _getImage(String src){
    try{
      new Image.network (
        src,
        height: 200.0,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      );
    } on NoSuchMethodError {
      Fluttertoast.showToast(msg: "Photo tidak ditemukan");
    }
  }

  List<Widget> _getListKurangAnggota() {
    List<Widget> list = [];

    for(int i = 0; i < widget.data.anggotaKurang.length; i++){
      list.add(
          new ExpansionTile(
            initiallyExpanded: false,
            title: new Text(
                (i+1).toString() + ". " + widget.data.anggotaKurang[i].nama
            ),
            children: <Widget>[
              new Container(
                alignment: Alignment.centerLeft,
                child: new Text("Anggota Keluarga :"),
                padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
              ), new Container(
                margin: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width / 1,
                alignment: Alignment.centerLeft,
                child: new Text(
                    widget.data.anggotaKurang[i].nama
                ),
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.black38,
                          offset: Offset(0, 0.2),
                          blurRadius: 0.2
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
                alignment: Alignment.centerLeft,
                child: new Text(
                    widget.data.anggotaKurang[i].nik
                ),
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.black38,
                          offset: Offset(0, 0.2),
                          blurRadius: 0.2
                      )
                    ]
                ),
              ), new Container(
                alignment: Alignment.centerLeft,
                child: new Text("Alasan Pengurangan :"),
                padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
              ), new Container(
                margin: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width / 1,
                alignment: Alignment.centerLeft,
                child: new Text(
                    widget.data.anggotaKurang[i].alasanKurang
                ),
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.black38,
                          offset: Offset(0, 0.2),
                          blurRadius: 0.2
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
  List<Widget> _getListAnggotaKeluarga(){
    List<Widget> list = [];
    for (int i = 0; i < widget.data.anggotaKeluarga.length; i++){
      list.add(
          new ExpansionTile(
            initiallyExpanded: false,
            title: new Text(
              (i+1).toString() + ". " + widget.data.anggotaKeluarga[i].nama
            ),
            children: <Widget>[
              new Container(
                alignment: Alignment.centerLeft,
                child: new Text("Anggota Keluarga :"),
                padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
              ), new Container(
                margin: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width / 1,
                alignment: Alignment.centerLeft,
                child: new Text(
                    widget.data.anggotaKeluarga[i].nama
                ),
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.black38,
                          offset: Offset(0, 0.2),
                          blurRadius: 0.2
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
                alignment: Alignment.centerLeft,
                child: new Text(
                    widget.data.anggotaKeluarga[i].noKtpPen
                ),
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.black38,
                          offset: Offset(0, 0.2),
                          blurRadius: 0.2
                      )
                    ]
                ),
              ), new Container(
                alignment: Alignment.centerLeft,
                child: new Text("Status Hubungan :"),
                padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
              ), new Container(
                margin: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width / 1,
                alignment: Alignment.centerLeft,
                child: new Text(
                    widget.data.anggotaKeluarga[i].statusHub
                ),
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.black38,
                          offset: Offset(0, 0.2),
                          blurRadius: 0.2
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Material(
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              title: new Align(
                alignment: Alignment(-0.15, 0),
                child: new Text(
                  "Detail Kurang Anggota",
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
                child: new SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: new Stack(
                      children: <Widget>[
                        new Column(
                          children: <Widget>[
                            new Container (
                              child: new Text(
                                "Data KK"
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
                              alignment: Alignment.centerLeft,
                              child: new Text("Kepala Keluarga :"),
                              padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                            ), new Container(
                              margin: const EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width / 1,
                              alignment: Alignment.centerLeft,
                              child: new Text(
                                  widget.data.kepalaKeluarga
                              ),
                              padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  boxShadow: [
                                    new BoxShadow(
                                        color: Colors.black38,
                                        offset: Offset(0, 0.2),
                                        blurRadius: 0.2
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
                              alignment: Alignment.centerLeft,
                              child: new Text(
                                  widget.data.noKK
                              ),
                              padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  boxShadow: [
                                    new BoxShadow(
                                        color: Colors.black38,
                                        offset: Offset(0, 0.2),
                                        blurRadius: 0.2
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
                              alignment: Alignment.centerLeft,
                              child: new Text(
                                  widget.data.alamat
                              ),
                              padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  boxShadow: [
                                    new BoxShadow(
                                        color: Colors.black38,
                                        offset: Offset(0, 0.2),
                                        blurRadius: 0.2
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
                                            alignment: Alignment.centerLeft,
                                            child: new Text(
                                                widget.data.rt
                                            ),
                                            padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                                            decoration: new BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                boxShadow: [
                                                  new BoxShadow(
                                                      color: Colors.black38,
                                                      offset: Offset(0, 0.2),
                                                      blurRadius: 0.2
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
                                            alignment: Alignment.centerLeft,
                                            child: new Text(
                                                widget.data.rw
                                            ),
                                            padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                                            decoration: new BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                boxShadow: [
                                                  new BoxShadow(
                                                      color: Colors.black38,
                                                      offset: Offset(0, 0.2),
                                                      blurRadius: 0.2
                                                  )
                                                ]
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                              ],
                            ),  new Row(
                              children: <Widget>[
                                new Flexible(
                                    child: new Container(
                                      child: new Column(
                                        children: <Widget>[
                                          new Container(
                                            alignment: Alignment.centerLeft,
                                            child: new Text("Kelurahan :"),
                                            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                                          ), new Container(
                                            margin: const EdgeInsets.all(10.0),
                                            width: MediaQuery.of(context).size.width / 1,
                                            alignment: Alignment.centerLeft,
                                            child: new Text(
                                                widget.data.kelurahan
                                            ),
                                            padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                                            decoration: new BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                boxShadow: [
                                                  new BoxShadow(
                                                      color: Colors.black38,
                                                      offset: Offset(0, 0.2),
                                                      blurRadius: 0.2
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
                                            child: new Text("Kecamatan :"),
                                            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                                          ), new Container(
                                            margin: const EdgeInsets.all(10.0),
                                            width: MediaQuery.of(context).size.width / 1,
                                            alignment: Alignment.centerLeft,
                                            child: new Text(
                                                widget.data.kecamatan
                                            ),
                                            padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                                            decoration: new BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                boxShadow: [
                                                  new BoxShadow(
                                                      color: Colors.black38,
                                                      offset: Offset(0, 0.2),
                                                      blurRadius: 0.2
                                                  )
                                                ]
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                              ],
                            ), new Container (
                              child: new Text(
                                "List Anggota Keluarga"
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
                            new Column(
                              children: _getListAnggotaKeluarga(),
                            ), new Container (
                              child: new Text(
                                "List Kurang Anggota"
                                ,textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              alignment: Alignment.topCenter,
                              padding: const EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 15.0),
                            ), new Column(
                              children: _getListKurangAnggota(),
                            ),  new Container (
                              child: new Text(
                                "Bukti Upload"
                                ,textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              alignment: Alignment.topCenter,
                              padding: const EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 15.0),
                            ), new Column(
                              children: _getListUpload(),
                            )
                          ],
                        ),
                      ],
                    )
                )
            )
        )
    );
  }
}
