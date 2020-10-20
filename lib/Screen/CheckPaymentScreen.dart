import 'package:capstone/Model/Market.dart';
import 'package:capstone/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckPaymentScreen extends StatefulWidget {
  @override
  _CheckPaymentScreenState createState() => _CheckPaymentScreenState();
}

class _CheckPaymentScreenState extends State<CheckPaymentScreen> {
  List<ReceiptTile> _list = [];

  @override
  Widget build(BuildContext context) {
    final _market = context.watch<Market>();
    final _user = context.watch<UserModel>();

    CollectionReference firestore = FirebaseFirestore.instance
        .collection('User')
        .doc(_user.userNo)
        .collection('Receipt');

    print(_user.userNo);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text("결제내역",
              style: TextStyle(
                  fontFamily: 'Jalnan',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: firestore.get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView(
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          return ReceiptTile(
                            marketName: document.data()["MarketName"],
                            time: document.data()["Time"],
                            sumPrice: document.data()["Price"],
                            list: document.data()["List"],
                          );
                        }).toList(),
                      );
                    } else
                      return Text("loading");
                  }),
            )
          ],
        ));
  }
}

class ReceiptTile extends StatefulWidget {
  String marketName;
  String time;
  int sumPrice;
  List<dynamic> list;
  bool isExpanded;

  ReceiptTile(
      {Key key,
      this.marketName,
      this.time,
      this.sumPrice,
      this.list,
      this.isExpanded = false})
      : super(key: key);

  @override
  _ReceiptTileState createState() => _ReceiptTileState();
}

class _ReceiptTileState extends State<ReceiptTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    widget.marketName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(widget.time)
                ],
              ),
              Text(
                '${widget.sumPrice}원',
                style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              IconButton(
                  icon: widget.isExpanded
                      ? Icon(Icons.arrow_upward)
                      : Icon(Icons.arrow_downward),
                  onPressed: () {
                    setState(() {
                      widget.isExpanded = !widget.isExpanded;
                    });
                  })
            ],
          ),
          widget.isExpanded
              ? ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: 20.0, maxHeight: (30.0 * widget.list.length)),
                  child: ListView.builder(
                      itemCount: widget.list.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex : 1,
                                child: Text(
                                  '${widget.list[index].toString().split(',')[0]}',
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex : 1,
                                child: Text(
                                  '${widget.list[index].toString().split(',')[1]}',
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex : 1,
                                child: Text(
                                  '${widget.list[index].toString().split(',')[2]}',
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      }))
              : Container()
        ],
      ),
    );
  }
}

class ReceiptHeader extends StatelessWidget {
  ReceiptHeader(this.marketName, this.time, this.sumPrice);

  final String marketName;
  final String time;
  final int sumPrice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                marketName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(time)
            ],
          ),
          Text(
            '$sumPrice원',
            style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class ReceiptBody extends StatelessWidget {
  ReceiptBody(this.list);

  final List<String> list;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Container(
            padding: EdgeInsets.all(10.0), child: Text(list[index]));
      },
    );
  }
}
