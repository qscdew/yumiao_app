import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';

var _controller = new TextEditingController();


class AddNoteScreen extends StatelessWidget {
  int id;
  AddNoteScreen({Key key, @required this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("添加新的笔记"),
        ),
        body: new Center(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new TextField(
                    maxLines:10,
                    controller: _controller,
                    decoration: new InputDecoration(
                      hintText: '名称',
                    ),

                  ),


                  new RaisedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final token = prefs.getString('user_token') ;
                      final username= prefs.getString('username') ;
                      var url = 'http://localhost:8080/api/notespaces/'+id.toString()+'/notes';
                      Response response;
                      Dio dio = Dio();
                      String result;

                      if(token == ''){
                        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => route == null,);
                      }
                      try {
                        print("test");
                        response = await dio.post(url, queryParameters: {"token":token},data:{"Text": _controller.text});
                        _controller.text="";
                        var data=jsonDecode(response.toString());
                        print(data);

                      } catch (exception) {
                        print(exception);
                        result = 'Failed ';
                      }
                      var c=1;
                      Navigator.pop(context, 1);


                    },
                    child: new Text('DONE'),
                  ),




                ])
        )


    );
  }


}
