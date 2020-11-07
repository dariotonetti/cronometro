import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(Cronometro());
}

//Classe Cronometro, crea il titolo dell'applicazione e inserisce i primi layout della pagina.
class Cronometro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cronometro',
      theme: ThemeData(primarySwatch: Colors.red, buttonColor: Colors.red),
      home: Home(),
    );
  }
}

//Classe Home, crea lo stato base del cronometro identificato nella classe HomeState
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

//Classe Home State Privata
//Ha il compito di creare i bottoni di avvio, stop e ripristino, il cronometro con millisecondi, secondi e minuti.
class _HomeState extends State<Home> {
  String _buttonText =
      'Start'; //Testo presente nel bottone di avvio con simbolo '>'
  String _stopwatchText =
      '00:00:00'; //Testo del cronometro che aumenta ogni millisecondo
  final _stopWatch = new Stopwatch();
  final _timeout = const Duration(
      milliseconds: 1); //Incremento della durata ogni millisecondo

  //Funzione per la creazione di un nuovo Timer con attributi:
  //timeout private per far aumentare il cronometro di un millisecondo continuamente
  //handleTimeout private per richiamare la funzione handleTimeout
  void _startTimeout() {
    new Timer(_timeout, _handleTimeout);
  }

  //Funzione per modificare il cronometro composto da 00:00:00
  void _handleTimeout() {
    if (_stopWatch.isRunning) {
      _startTimeout();
    }
    setState(() {
      _setStopwatchText();
    });
  }

//Funzione che modifica il pulsante di avvio a stop e viceversa.
  void _startStopButtonPressed() {
    setState(() {
      if (_stopWatch.isRunning) {
        _buttonText = 'Start';
        _stopWatch.stop();
      } else {
        _buttonText = 'Stop';
        _stopWatch.start();
        _startTimeout();
      }
    });
  }

//Funzione utilizzata per resettare il pulsante premuto una volta che viene bloccata l'esecuzione infita del cronometro
  void _resetButtonPressed() {
    if (_stopWatch.isRunning) {
      _startStopButtonPressed();
    }
    setState(() {
      _stopWatch.reset();
      _setStopwatchText();
    });
  }

//Funzione utilizzata per:
//Far aumentare i millisecondi fino a 100,
//Far aumentare i secondi fino a 60
//Far aumentare i minuti fino a 60
  void _setStopwatchText() {
    _stopwatchText = (_stopWatch.elapsed.inMinutes % 60)
            .toString()
            .padLeft(2, '0') +
        ':' +
        (_stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, '0') +
        ':' +
        (_stopWatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0');
  }

//Creazione grafica dell'applicazione
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cronometro',
            style: TextStyle(fontSize: 30, color: Colors.white)),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: FittedBox(
            fit: BoxFit.none,
            child: Text(
              _stopwatchText,
              style: TextStyle(fontSize: 80),
            ),
          ),
        ),
        Center(
          child: Row(
            children: <Widget>[
              RaisedButton(
                child: Icon(
                    //Se il bottone 'Start' è stato premuto quando aveva l'icona '>' viene modificata nell'icona di 'stop'
                    _buttonText == 'Start' ? Icons.play_arrow : Icons.stop),
                onPressed: _startStopButtonPressed,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.black,
                        width: 2.0) //Bordi Neri di spessore 2.0
                    ),
              ),
              RaisedButton(
                child: Text(
                  'Ripristina',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onPressed: _resetButtonPressed,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.black,
                        width: 2.0) //Bordi Neri di spessore 2.0
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
