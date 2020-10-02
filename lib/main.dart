import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_plugin/models/nfc_event.dart';
import 'package:flutter_nfc_plugin/models/nfc_message.dart';
import 'package:flutter_nfc_plugin/models/nfc_state.dart';
import 'package:flutter_nfc_plugin/nfc_plugin.dart';
import 'Screen/HomeScreen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Color(0xFFF9F9F9)));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //매장명 수신을 위한 NFC 변수
  String nfcState = 'Unknown';
  String nfcError = '';
  String nfcMessage = '';
  String nfcTechList = '';
  String nfcId = '';
//=============================
  NfcMessage nfcMessageStartedWith;

  NfcPlugin nfcPlugin = NfcPlugin();
  StreamSubscription<NfcEvent> _nfcMesageSubscription;

  //파이어베이스 설정을 위한 변수
  bool _initialized = false;
  bool _error = false;

  //파이어베이스 초기화 함수
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

//NFC 태그 실행을 위한 함수
  Future<void> initPlatformState() async {
    NfcState _nfcState;

    try {
      _nfcState = await nfcPlugin.nfcState;
      print('NFC state is $_nfcState');
    } on PlatformException {
      print('Method "NFC state" exception was thrown');
    }
    try {
      final NfcEvent _nfcEventStartedWith = await nfcPlugin.nfcStartedWith;
      print('NFC event started with is ${_nfcEventStartedWith.toString()}');
      if (_nfcEventStartedWith != null) {
        setState(() {
          nfcMessageStartedWith = _nfcEventStartedWith.message;
        });
      }
    } on PlatformException {
      print('Method "NFC event started with" exception was thrown');
    }

    if (_nfcState == NfcState.enabled) {
      _nfcMesageSubscription = nfcPlugin.onNfcMessage.listen((NfcEvent event) {
        if (event.error.isNotEmpty) {
          setState(() {
            nfcMessage = 'ERROR: ${event.error}';
            nfcId = '';
          });
        } else {
          setState(() {
            nfcMessage = event.message.payload.toString();
            nfcTechList = event.message.techList.toString();
            nfcId = event.message.id;
          });
        }
      });
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      nfcState = _nfcState.toString();
    });
  }

  @override
  void initState() {
    initializeFlutterFire(); //파이어베이스 초기화
    initPlatformState();
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.black, //기본컬러이며 위젯들이 보색을 띄게 된다.
          textTheme: TextTheme(
            title: TextStyle(
                color: Colors.deepPurple,
                fontFamily: 'Jalnan',
                fontWeight: FontWeight.bold),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          buttonTheme: ButtonThemeData(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            buttonColor: Colors.deepPurple,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        home: HomeScreen());
  }
}
