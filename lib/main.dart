import 'dart:async';
import 'package:capstone/Screen/BasketScreen.dart';
import 'package:capstone/Screen/ItemManage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_plugin/models/nfc_event.dart';
import 'package:flutter_nfc_plugin/models/nfc_message.dart';
import 'package:flutter_nfc_plugin/models/nfc_state.dart';
import 'package:flutter_nfc_plugin/nfc_plugin.dart';
import 'Model/Market.dart';
import 'Model/User.dart';
import 'Screen/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screen/Receipt.dart';
import 'Screen/ResultScreen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.deepPurple));
  runApp(InitApp());
}

class InitApp extends StatefulWidget {
  InitAppState createState() => InitAppState();
}

class InitAppState extends State<InitApp> {
  // 파이어 베이스 초기화를 위한 변수
  bool _initialized = false;
  bool _error = false;

  //매장명 수신을 위한 NFC 변수
  String nfcState = 'Unknown';
  String nfcError = '';
  String nfcMessage = '';
  String nfcTechList = '';
  String nfcId = '';
  String nfcMarketNo = 'null';
  NfcMessage nfcMessageStartedWith;
  bool withNfcMode = false;

  NfcPlugin nfcPlugin = NfcPlugin();
  StreamSubscription<NfcEvent> _nfcMesageSubscription;

  Market _market = Market();
  bool isMarketLoad = false;

  //TODO : 앱 초기화시 권한 확인하기, 로그인 여부 및 계정의 종류(고객? 관리자?) 어떻게 저장할 수 있을까? -> 유저로 바꿔야지
  UserModel userModel = UserModel();
  bool isUserLoad = false;

  //NFC 태그 실행을 위한 함수
  Future<void> initPlatformState() async {
    NfcState _nfcState;

    //NFC 정보 읽기
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
          nfcMarketNo = nfcMessageStartedWith.payload[0].split('marketNo:')[1];
          if (nfcMarketNo != 'null') {
            //마켓 정보 읽기
            _market.readFromDB(nfcMarketNo);
            withNfcMode = true;
          }
        });
      }
      _market.name = " ";
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

  // Define an async function to initialize FlutterFire
  Future initializeFlutterFire() async {
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

  void initMarketWithNFC() async {
    await initPlatformState();
    setState(() {
      isMarketLoad = true;
    });
  }

  void initUser() async {
    await userModel.initUser();
    setState(() {
      isUserLoad = true;
    });
  }

  @override
  void initState() {
    //firebase null 에러 해결
    initializeFlutterFire().whenComplete(() {
      initMarketWithNFC();
      initUser();

      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text("Something wrong"),
          ),
        ),
      );
    }
    // Show a loader until FlutterFire is initialized
    if (!isMarketLoad || !_initialized || !isUserLoad) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.deepPurple,
          body: Center(
            child: Text(
              "MEGA POS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontFamily: 'Jalnan',
              ),
            ),
          ),
        ),
      );
    }

    return MyApp(market: _market, withNfcMode: withNfcMode, user: userModel);
  }
}

class MyApp extends StatefulWidget {
  Market market;
  bool withNfcMode;
  UserModel user;

  MyApp({Key key, this.market, this.withNfcMode, this.user}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    print("marketNo : ${widget.market.marketNo}");
    print("마켓번호 : ${widget.market.marketNo}\n마켓이름 : ${widget.market.name} ");
    print("사장 : ${widget.market.ceo}\n연락처 : ${widget.market.contact}");
    super.initState();
  }

  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: widget.market,
          ),
          ChangeNotifierProvider.value(
            value: widget.user,
          ),
        ],
        child: MaterialApp(
          routes: {
            '/result': (context) => ReceiptScreen(),
          },
          debugShowCheckedModeBanner: false,
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              buttonColor: Colors.deepPurple,
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          home: widget.withNfcMode ? BasketScreen() : HomeScreen(),
        ));
  }
}
