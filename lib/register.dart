import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';

var _controller = new TextEditingController();
var _controller2 = new TextEditingController();
var _controller_email = new TextEditingController();

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("注册"),
        ),
        body: new Center(
            child: new Column(

                children: [
                  new TextField(

                    controller: _controller,
                    decoration: new InputDecoration(
                      icon: Icon(Icons.account_circle),

                      hintText: '账号',
                    ),
                  ),
                  new TextField(

                    controller: _controller_email,
                    decoration: new InputDecoration(
                      icon: Icon(Icons.email),

                      hintText: '邮箱',
                    ),
                  ),
                  new TextField(
                    obscureText: true,
                    controller: _controller2,
                    decoration: new InputDecoration(
                      icon: Icon(Icons.lock),

                      hintText: '密码',
                    ),

                  ),

                  new RaisedButton(
                    onPressed: () async {
                      var url = 'http://localhost:8080/api/auth/register';
                      Response response;
                      Dio dio = Dio();
                      String result;
                      try {

                        response = await dio.post(url, data: {"username": _controller.text, "password": _controller2.text,"email":_controller_email.text});
                        var data=jsonDecode(response.toString());
                        result=data['message'];

                      } catch (exception) {
                        result = 'Failed ';
                      }
                      showDialog(
                        context: context,
                        child: new AlertDialog(
                          title: new Text('信息'),
                          content: new Text(result),
                        ),
                      );

                    },
                    child: new Text('注册'),
                  ),




                ])
        )


    );
  }
}
