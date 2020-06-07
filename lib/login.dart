import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumiao/register.dart';

var _controller = new TextEditingController();
var _controller2 = new TextEditingController();

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("登录"),
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
                    obscureText: true,
                    controller: _controller2,
                    decoration: new InputDecoration(
                      icon: Icon(Icons.lock),

                      hintText: '密码',
                    ),

                  ),

                  new RaisedButton(
                    onPressed: () async {
                      var url = 'http://localhost:8080/api/auth';
                      Response response;
                      Dio dio = Dio();
                      String result;
                      try {

                        response = await dio.get(url, queryParameters: {"username": _controller.text, "password": _controller2.text});
                        var data=jsonDecode(response.toString());
                        result=data['data']['token'];
                        final prefs = await SharedPreferences.getInstance();

                        final setTokenResult = await prefs.setString('user_token', result);
                        if(setTokenResult){
                          print('保存登录token成功');
                          final setUsername = await prefs.setString('username', _controller.text);
                          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => route == null,);
                        }else{
                          result="ssss";
                          print('error, 保存登录token失败');
                        }

                      } catch (exception) {
                        result = 'Failed ';
                      }
//                      showDialog(
//                        context: context,
//                        child: new AlertDialog(
//                          title: new Text('What you typed'),
//                          content: new Text(result),
//                        ),
//                      );

                    },
                    child: new Text('登录'),
                  ),
            new RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new RegisterScreen())) ;

              },
              child: new Text('注册'),
            ),




                ])
        )


    );
  }
}
