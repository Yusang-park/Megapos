import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SearchImage extends StatefulWidget {
  @override
  _SearchImageState createState() => _SearchImageState();
}

class _SearchImageState extends State<SearchImage> {
  TextEditingController _searchController;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  List<String> _list = [];

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        //상품 관리 타이틀
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top), //상태바 크기만큼 위쪽 마진
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 5.0),
              color: Colors.deepPurple,
              child: Column(
                children: [
                  Text(
                    '상품 이미지 검색',
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
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: '   상품명을 검색하세요',
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none),
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.search), onPressed: (){
                                loadImages(_searchController.text);
                                _searchController.clear();
                          })
                        ],
                      )),
                ],
              ),
            ),
            
            
            //상품을 띄워보자
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 5.0
                ),
                itemCount: _list.length,
                itemBuilder: (context, index){
                  return InkWell(
                    onTap: (){
                      Navigator.pop(context, _list[index]);
                    },
                    child: Image.network(_list[index],
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.height * 0.15),
                  );
                },
              ),
            )


          ],
        ),
      ),
    );
  }


  Future<void> loadImages(String name) async{
    setState(() {
      _list.clear();
    });

    firebase_storage.ListResult result =
    await storage.ref().child(name).listAll();

    result.items.forEach((element) {
      element.getDownloadURL().then((value){
        setState(() {
          _list.add(value);
        });
      }).catchError((onError) => print("loadImage error"));
    });
  }
}
