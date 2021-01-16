import 'package:capstone/Model/Item.dart';
import 'package:capstone/Model/Market.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ItemAdd.dart';
import 'package:provider/provider.dart';



class ItemManage extends StatefulWidget {
  @override
  _ItemManageState createState() => _ItemManageState();
}

class _ItemManageState extends State<ItemManage> {
  TextEditingController _searchController;
  bool isSearch = false;

  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false, //키보드 올라올 때 오버플로우 발생 방지
      body: Column(children: [
        Container(
          //상품 관리 타이틀
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top), //상태바 크기만큼 위쪽 마진
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 5.0),
                color: Colors.deepPurple,
                child: Column(
                  children: [
                    Text(
                      '상품 관리',
                      style: TextStyle(
                          fontFamily: 'Jalnan',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: TextField(
                                  onEditingComplete: (){
                                    setState(() {
                                      isSearch = !isSearch;
                                      if(!isSearch)
                                        isSearch = !isSearch;
                                    });

                                  },
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      hintText: '상품명을 검색하세요',
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none),
                                ),
                              ),
                            ),
                            IconButton(
                                icon: isSearch ? Icon(Icons.clear) : Icon(Icons.search), onPressed: (){
                                  setState(() {
                                    if(isSearch)
                                      _searchController.clear();
                                    isSearch = !isSearch;
                                  });
                            })
                          ],
                        )),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5.0),
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("사진"),
                    Text("이름"),
                    Text("가격"),
                    Text("재고량"),
                  ],
                ),
              ),
              Divider(
                thickness: 2,
              ),
            ],
          ),
        ),
        Expanded(child: ItemList(isSearch: isSearch, keyword: _searchController.text,)),
      ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ItemAdd(
                    item: ItemModel(),
                        isNew: true,
                      )));
          setState(() {});
        },
      ),
    );
  }
}

class ItemList extends StatefulWidget {
  bool isSearch;
  String keyword;

  ItemList({this.isSearch, this.keyword});

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final marketNo = context.watch<Market>().marketNo;

    CollectionReference firestore = FirebaseFirestore.instance
        .collection('Store')
        .doc(marketNo)
        .collection('Product');

    void justSetState(){
      setState(() {

      });
    }

    return FutureBuilder(
        future: widget.isSearch ? firestore.where('Keyword', arrayContains: widget.keyword).get() : firestore.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return ItemTile(
                  key: ValueKey(document.id),
                  item: ItemModel(
                    itemNo: document.id,
                    name: document.data()['Name'],
                    detail: document.data()['Detail'],
                    price: document.data()['Price'],
                    stock: document.data()['Stock'],
                    image: document.data()['Image'],
                  ),
                  updateList: justSetState,
                );
              }).toList(),
            );
          } else
            return Text("loading");
        });
  }
}

class ItemTile extends StatefulWidget {
  ItemModel item;
  Function updateList;

  ItemTile({
    Key key,
    this.item,
    this.updateList
  }) : super(key: key);

  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return InkWell(
      onLongPress: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ItemAdd(
                      item: widget.item,
                      isNew: false,
                    )));
        widget.updateList();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
        height: size.height * 0.1,
        width: size.width * 0.1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.black12, width: 3)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                  height: size.height * 0.07,
                  child: Image.network(widget.item.image)
            ),),
            Expanded(flex: 1, child: Text('${widget.item.name} ${widget.item.detail}')),
            Expanded(flex: 1, child: Text('${widget.item.price}원')),
            Expanded(flex: 1, child: Text('${widget.item.stock}개'))
          ],
        ),
      ),
    );
  }
}
