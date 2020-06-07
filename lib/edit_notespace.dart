import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';

var _controller = new TextEditingController();
var _controller2 = new TextEditingController();

class EditNoteSpaceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("修改"),
        ),
        body: new Center(
            child: new Column(




            )
        )


    );
  }
}
