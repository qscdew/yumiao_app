import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'add_note.dart';

var _controller = new TextEditingController();

int notespace_id;
class ShowNoteSpaceScreen extends StatefulWidget {
  int id;
  ShowNoteSpaceScreen({Key key, @required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    notespace_id=id;
    return _ShowNoteState();
  }
}

class _ShowNoteState extends State<ShowNoteSpaceScreen>{

  List notes;
  var data;



  @override
  Widget build(BuildContext context) {


    return new Scaffold(

        appBar: new AppBar(
          title: new Text(notespace_id.toString()),
        ),
            body: new Center(
                child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                    padding: const EdgeInsets.all(8),
                    itemCount: notes.length,
                    itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child:new Text(' ${notes[index]['Text']}'),
           );
        }
    )
        ),




      floatingActionButton: new FloatingActionButton(
      tooltip: 'Add', // used by assistive technologies
      child: new Icon(Icons.add),
      onPressed: (){
        _navigateAndDisplaySelection(context);


      },
    ),

    );
  }

  @override
  void initState()  {
    super.initState();
    // 初始化
    notes=[];
    _increment();

  }
  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that will complete after we call
    // Navigator.pop on the Selection Screen!
    final result = await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new AddNoteScreen(id: notespace_id)),
    );

    // After the Selection Screen returns a result, show it in a Snackbar!
   var r=result;
if(r==1){
  notes=[];
  _increment();
r==0;
}
  }
  _increment() async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token') ;
    if(token == ''){
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => route == null,);
    }
    else{
      var url = 'http://localhost:8080/api/notespaces/'+notespace_id.toString()+"/notes";
      Response response;
      Dio dio = Dio();
      response = await dio.get(url, queryParameters: {"token": token});
      data=jsonDecode(response.toString());

    }
    setState(()  {
       notes=data['data'];



    });
  }

  }


