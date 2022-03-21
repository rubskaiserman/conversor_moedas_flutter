// ignore_for_file: unnecessary_const, prefer_const_constructors, unnecessary_new
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=fb1d8618";

void main() async {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Map> table = getData();

  final TextEditingController _realController = new TextEditingController();
  final TextEditingController _dollarController = new TextEditingController();
  final TextEditingController _euroController = new TextEditingController();

  double dollar = 0;
  double euro = 0;

  void realChanged() {
    if (_realController.text == '') {
      _dollarController.text = '';
      _euroController.text = '';
    } else {
      double _real = double.parse(_realController.text);
      setState(() {
        _dollarController.text = (_real / dollar).toStringAsFixed(2);
        _euroController.text = (_real / euro).toStringAsFixed(2);
      });
    }
  }

  void dollarChanged() {
    double _dollar = double.parse(_dollarController.text);
    setState(() {
      _realController.text = (_dollar * dollar).toStringAsFixed(2);
      _euroController.text = ((_dollar * dollar) / euro).toStringAsFixed(2);
    });
  }

  void euroChanged() {
    double _euro = double.parse(_euroController.text);
    setState(() {
      _realController.text = (_euro * euro).toStringAsFixed(2);
      _dollarController.text = ((_euro * euro) / dollar).toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        title: const Text(
          "Currencies converter",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: Text(
                    'Carregando Dados',
                    style: TextStyle(color: Colors.amber),
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error"),
                  );
                } else {
                  dollar = snapshot.data['USD']['buy'];
                  euro = snapshot.data['EUR']['buy'];
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                            padding: const EdgeInsets.all(20),
                            child: const Icon(
                              Icons.monetization_on,
                              color: Colors.amber,
                              size: 240,
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                            child: TextField(
                              onChanged: (_realController) {
                                realChanged();
                              },
                              controller: _realController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  gapPadding: 1000,
                                  borderSide: const BorderSide(
                                      color: Colors.amber, width: 3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                    gapPadding: 1000,
                                    borderSide: const BorderSide(
                                        color: Colors.amber, width: 3),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: 'Real',
                                hintStyle: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700),
                              ),
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                            child: TextField(
                              onChanged: (_dollarController) {
                                dollarChanged();
                              },
                              controller: _dollarController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  gapPadding: 1000,
                                  borderSide: const BorderSide(
                                      color: Colors.amber, width: 3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                    gapPadding: 1000,
                                    borderSide: const BorderSide(
                                        color: Colors.amber, width: 3),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: 'Dollar',
                                hintStyle: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700),
                              ),
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                            child: TextField(
                              onChanged: (_euroController) {
                                euroChanged();
                              },
                              controller: _euroController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  gapPadding: 1000,
                                  borderSide: const BorderSide(
                                      color: Colors.amber, width: 3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                    gapPadding: 1000,
                                    borderSide: const BorderSide(
                                        color: Colors.amber, width: 3),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: 'Euro',
                                hintStyle: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700),
                              ),
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ))
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body)['results']['currencies'];
}
