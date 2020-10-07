import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';


void main() {
  runApp(MaterialApp(
    title: "My Apps",
    home: HalamanJson(),
  ));
}

class HalamanJson extends StatefulWidget {
  @override
  _HalamanJsonState createState() => _HalamanJsonState();
}

class _HalamanJsonState extends State<HalamanJson> {
  int nomor;
  List datadariJSON;

  Future ambildata() async {
    http.Response hasil = await http.get(
        Uri.encodeFull(
            "https://al-quran-8d642.firebaseio.com/data.json?print=pretty"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      datadariJSON = json.decode(hasil.body);
    });
  }

  @override
  void initState() {
    this.ambildata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Al Quran XII RPL", style: TextStyle(fontSize: 18),),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: datadariJSON == null ? 0 : datadariJSON.length,
            itemBuilder: (context, i) {
              // subtitle = toString(datadariJSON[i]['ayat']) ?? "";
              return Card(
                child: ListTile(
                  title: Text(datadariJSON[i]['nama'] ?? ""),
                  subtitle: Text(datadariJSON[i]['arti'] +
                    " " + "(" +
                    datadariJSON[i]['ayat'].toString() +
                    " Ayat" + ")" ??
                    ""),
              trailing: Text(datadariJSON[i]['asma'] ?? "", style: TextStyle(fontSize: 20),),
              
              onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) {
              var datadariJSON2 = datadariJSON[i];
              return DetailAlQuran(
              nomor: datadariJSON2['nomor'],
              nama: datadariJSON2['nama']);
              },
              ),
              );
              },
              )
              );
            }),
      ),
    );
  }
}

class DetailAlQuran extends StatefulWidget {
  final String nomor;
  final String nama;

  DetailAlQuran({this.nomor, this.nama});
  @override
  _DetailAlQuran createState() => _DetailAlQuran();
}

class _DetailAlQuran extends State<DetailAlQuran> {
  List dataAlquranJSON;

  Future ambildata() async {
    http.Response hasil = await http.get(
        Uri.encodeFull(
            "https://al-quran-8d642.firebaseio.com/surat/${widget.nomor}.json?print=pretty"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      dataAlquranJSON = json.decode(hasil.body);
    });
  }

  @override
  void initState() {
    this.ambildata();
  }

  // final String data = ambildata();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text(" ${widget.nama}"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: dataAlquranJSON == null ? 0 : dataAlquranJSON.length,
          itemBuilder: (context, i) {
            return Card(
              child: ListTile(
                leading: Text(dataAlquranJSON[i]['nomor'] ?? "", style: TextStyle(fontSize: 10),textDirection: TextDirection.rtl,),
                title: Text(dataAlquranJSON[i]['ar'] ?? "", style: TextStyle(fontSize: 20),textDirection: TextDirection.rtl,),
                subtitle: Text(dataAlquranJSON[i]['id'] ?? "", style: TextStyle(fontSize: 10),textDirection: TextDirection.rtl,),
              ),
            );
          },
        ),
      ),
    );
  }
}