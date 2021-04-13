import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'models/doviz.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {
  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  String url = "https://canlidoviz.com/doviz-kurlari.jsonld";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Döviz Uygulaması"),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder(
        future: internetiKontrolEt(),
        builder: (context, snapshot) {
          if (snapshot.data == false) {
            return Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Lütfen İnternet Bağlantınızı Kontrol edin"),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: Text("Yenile"))
                  ],
                ),
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: yenile,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: FutureBuilder(
                  future: dovizBilgileriniGetir(),
                  builder:
                      (context, AsyncSnapshot<List<ItemListElement>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.teal,
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              margin: EdgeInsets.all(10),
                              child: ListTile(
                                leading: Container(
                                  width: 60,
                                  height: 150,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.yellow,
                                    child: Text(
                                      snapshot.data[index].currency,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  snapshot.data[index].currentExchangeRate.price
                                      .toString(),
                                  style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                    snapshot.data[index].currentExchangeRate
                                        .priceCurrency,
                                    style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                              ),
                            );
                          });
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<bool> internetiKontrolEt() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  Future<Null> yenile() async {
    await new Future.delayed(new Duration(milliseconds: 500));
    setState(() {});
    return null;
  }

  Future<List<ItemListElement>> dovizBilgileriniGetir() async {
    var parsedUrl = Uri.parse(url);
    var result = await http.get(parsedUrl);

    try {
      if (result.statusCode == 200) {
        var jsonResponse =
            json.decode(result.body)["mainEntity"]["itemListElement"];
        List<ItemListElement> kurlar = (jsonResponse as List)
            .map((gelenDeger) => ItemListElement.fromJson(gelenDeger))
            .toList();

        return kurlar;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}

/*



*/