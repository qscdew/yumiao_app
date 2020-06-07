import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_scan/barcode_scan.dart';

var _controller = new TextEditingController();
var _controller_title = new TextEditingController();
var _controller_isbn = new TextEditingController();
var _controller_author = new TextEditingController();
var _controller_publisher = new TextEditingController();
String result2=" ";
int bookid=0;
Future<void> addbook(var data) async {

  var url = 'http://localhost:8080/api/books';
  Response response;
  Dio dio = Dio();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('user_token') ;

  var author;
  var translator;


  if(token == ''){

  }else{

    try{
      author=data['author'][0];
    }
    catch(exception){
      author="";
    }
    try{
      translator=data['translator'][0];
    }
    catch(exception){
      translator="";
    }
    _controller_author.text=author;
    _controller_isbn.text=data['isbn13'];
    _controller_publisher.text=data['publisher'];

    print("发送前:");
    response = await dio.post(url, queryParameters: {"token":token},
        data:{"title":data['title'],
        "author":author,
        "publisher":data['publisher'],
        "otitle":data['alt_title'],
        "translator":translator,
        "isbn":data['isbn13'],

        "image":data['image'],
        "brief":data['summary']});
    var data2=jsonDecode(response.toString());
    print(data2);
    result2=data2['message'];
    bookid=data2['bookid'];


  }

}

class AddNoteSpaceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("添加新的笔记区"),
        ),
        body: new Center(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new TextField(
                    controller: _controller,
                    decoration: new InputDecoration(
                      hintText: '名称',
                    ),
                  ),

                  new TextField(
                    enableInteractiveSelection: false,
                    controller: _controller_title,
                    decoration: new InputDecoration(
                      hintText: '书名',
                    ),
                  ),
                  new TextField(
                    enableInteractiveSelection: false,
                    controller: _controller_isbn,
                    decoration: new InputDecoration(
                      hintText: 'ISBN',
                    ),
                  ),
                  new TextField(
                    enableInteractiveSelection: false,
                    controller: _controller_author,
                    decoration: new InputDecoration(
                      hintText: '作者',
                    ),
                  ),
                  new TextField(
                    enableInteractiveSelection: false,
                    controller: _controller_publisher,
                    decoration: new InputDecoration(
                      hintText: '出版社',
                    ),
                  ),

                  new RaisedButton(
                      child: new Text('扫码'),
                      onPressed: ()async{
                    var result_code = await BarcodeScanner.scan();
                    print("读取出来的条码"+result_code); // The result type (barcode, cancelled, failed)
                    var url = "https://api.douban.com/v2/book/isbn/"+result_code+"?apikey=0df993c66c0c636e29ecbb5344252a4a";

                    Response response;
                    Dio dio = Dio();
                    String result;
                    try {
                      print("test");
                      response = await dio.get(url);
                      var data=jsonDecode(response.toString());
                      print(data);
                      addbook(data);
                      result=data['title'];
                      _controller_title.text=data['title'];
//                      print(result);
//                      print(data['author'][0]);
//                      print(data['translator'][0]);
//                      print(data['publisher']);
//                      print(data['alt_title']);
//                      print(data['isbn13']);
//                      print(data['summary']);
//                      print(data['binding']);
//                      print(data['image']);


                    } catch (exception) {
                      print(exception);
                      //result = 'Failed ';
                    }

                    showDialog(
                      context: context,
                      child: new AlertDialog(
                        title: new Text('信息'),
                        content: new Text("读取出来的条码："+result_code+"\n读取出来的书:"+result+"\n添加进数据库："+result2),
                      ),
                    );
                      }),

                  new RaisedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final token = prefs.getString('user_token') ;
                      final username= prefs.getString('username') ;

                      var url = 'http://localhost:8080/api/users/'+username+'/notespaces';
                      Response response;
                      Dio dio = Dio();
                      String result;

                      if(token == ''){
                        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => route == null,);
                      }
                      try {
                        print("test");
                        print("书的id"+bookid.toString());
                        response = await dio.post(url, queryParameters: {"token":token},data:{"Name": _controller.text,"BookID":bookid});
                        var data=jsonDecode(response.toString());
                        print(data);

                      } catch (exception) {
                        print(exception);
                        result = 'Failed ';
                      }
                      bookid=0;
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => route == null,);

                    },
                    child: new Text('提交'),
                  ),




                ])
        )


    );
  }
}
