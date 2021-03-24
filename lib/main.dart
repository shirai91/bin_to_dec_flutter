import 'dart:io';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Binary To Decimal Converter',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
          primarySwatch: Colors.green,
          primaryColor: Colors.green
      ),
      home: BinaryConverter(),
    );
  }
}

class BinaryConverter extends StatefulWidget {
  _BinaryConverterState createState() => _BinaryConverterState();
}

class _BinaryConverterState extends State<BinaryConverter> {
  final _biggerFont = TextStyle(fontSize: 18.0);
  final _textFieldController = TextEditingController();
  String _decimal = "";

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  String _binaryToDecimal(String binaryValue) {
    int decValue = 0;
    int base = 1;
    int temp = int.parse(binaryValue);

    while (temp > 0) {
      int lastDigit = temp % 10;
      temp = (temp / 10).floor();
      decValue += lastDigit * base;
      base = base * 2;
    }

    return decValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Binary To Decimal Converter'),
        ),
        body: Column(
            children: <Widget>[
              Container(
                child: TextField(
                  controller: _textFieldController,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(hintText: 'Type a binary'),
                  inputFormatters: [BinaryTextInputFormatter()],
                  maxLength: 8,
                  style: _biggerFont,
                  onChanged: (String value) async {
                    setState(() {
                      if (value.isNotEmpty) {
                        final decimalValue = _binaryToDecimal(value);
                        _decimal = 'Decimal value is $decimalValue';
                      } else {
                        _decimal = 'Please input binary value';
                      }
                    });
                  },
                ),
                margin: EdgeInsets.only(top: 10, left: 10, right: 10,)
              ),
              Container(
                child: Text(_decimal, style: _biggerFont),
                margin: EdgeInsets.only(top: 20),
              )
            ]
        ));
  }
}

class BinaryTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    final regEx = RegExp(r"[01]*");
    String newString = regEx.stringMatch(newValue.text) ?? "";
    return newString == newValue.text ? newValue : oldValue;
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll((generateWordPairs().take(10)));
          }

          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(pair.asPascalCase, style: _biggerFont),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      final tiles = _saved.map((WordPair pair) {
        return ListTile(title: Text(pair.asPascalCase, style: _biggerFont));
      });
      final divided =
      ListTile.divideTiles(context: context, tiles: tiles).toList();
      return Scaffold(
          appBar: AppBar(
            title: Text('Saved Suggestion'),
          ),
          body: ListView(
            children: divided,
          ));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Startup Name Generator'),
          actions: [IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)],
        ),
        body: _buildSuggestions());
  }
}
