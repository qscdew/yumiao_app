import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumiao/add_notespace.dart';
import 'package:yumiao/show_notespace.dart';
import 'about.dart';
import 'login.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:barcode_scan/barcode_scan.dart';

void main() {
  runApp(new MaterialApp(

    title: 'Flutter Tutorial',
    home: new Counter(),
    routes: <String, WidgetBuilder> {
      '/login':(_) => new SecondScreen(),

    },
  ));
}



class Counter extends StatefulWidget {
  // This class is the configuration for the state. It holds the
  // values (in this nothing) provided by the parent and used by the build
  // method of the State. Fields in a Widget subclass are always marked "final".

  @override
  _CounterState createState() {

    return new _CounterState();
  }
}
String usernam="";
class _CounterState extends State<Counter> {

  List<List> entries;
  var data;
  var username1="";
  var _controller_edit = new TextEditingController();

  @override
  void initState()  {
    super.initState();
    // 初始化
    entries=[];

    _increment();

  }


  _increment() async{
    entries=[];
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token') ;
    final username= prefs.getString('username') ;

    if(token == null){

      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new SecondScreen()),
      );
    }
    else{
      var url = 'http://localhost:8080/api/users/'+username+'/notespaces';
      Response response;
      Dio dio = Dio();
      response = await dio.get(url, queryParameters: {"token": token});
       data=jsonDecode(response.toString());

    }
    setState(()  {
      List result=data['data'];

      username1=username;

  int j=0;
      for(int i =0;i<result.length-3;i+=3){
        entries.add(result.sublist(i,i+3));
        j=i+3;
      }
      entries.add(result.sublist(j));






    });
  }

  @override
  Widget build(BuildContext context) {
    //Scaffold是Material中主要的布局组件.
    return new Scaffold(
      appBar: new AppBar(
//        leading: new IconButton(
//          icon: new Icon(Icons.menu),
//          tooltip: 'Navigation menu',
//          onPressed: (){
//
//          },
//        ),
        title: new Text('我的笔记架'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () async {

              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new SecondScreen()),
              );
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children:  <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.pink,
              ),
              child: Text(
                username1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          InkWell(
            onTap: (){
                Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new SecondScreen()),
              );
            },
            child: ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('登录'),

            ),

          ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('信息'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('设置'),
            ),

            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new HomeScreen()),
                );
              },
              child: ListTile(
                leading: Icon(Icons.textsms),
                title: Text('关于'),

              ),

            ),
          ],
        ),
      ),

      //body占屏幕的大部分
      body: new Center(
          child: ListView(
            children: <Widget>[
              Table(

                children: _tableRowList(),
              ),
            ],
          )
      ),

      floatingActionButton: new FloatingActionButton(
        tooltip: 'Add', // used by assistive technologies
        child: new Icon(Icons.add),
        onPressed: (){
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new AddNoteSpaceScreen()),
          );
        },
      ),
    );
  }

  _tableRowList() {


    if(entries.length<1){

    }

    var count = entries.length;
    dynamic content;
    List<TableRow> Tlist = <TableRow>[];
    for (var i = 0; i < count; i++) {
      content = TableRow(
        children: _tableRow(entries[i])
      );
      Tlist.add(content);
    }


    return Tlist;
  }

  _tableRow(List<dynamic> entri){

    List<Widget> children =  <Widget>[];
    dynamic a;
    for(var e in entri){
      a= Container(
          margin: const EdgeInsets.all(8.0),
          child:InkWell(
          onLongPress:(){
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return SimpleDialog(
                    title: Text("操作"),
                    titlePadding: EdgeInsets.only(top:20,bottom: 15.0, left: 10.0),
                    children: <Widget>[
                    TextField(
                    controller: _controller_edit,
                    decoration: new InputDecoration(
                      hintText: '修改名称',
                    ),

                  ),
                      SimpleDialogOption(
                        child: Text("修改"),
                        onPressed: () {
                          print("点击了第二行"+_controller_edit.text);
                          _increment();
                          Navigator.of(context).pop();
                        },
                      ),
                      SimpleDialogOption(
                        child: Text("删除"),
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final token = prefs.getString('user_token') ;
                          print("删除  "+token);

                          var url = 'http://localhost:8080/api/notespaces/'+e['ID'].toString();
                          Response response;
                          Dio dio = Dio();
                          String result;

                          if(token == ''){

                          }
                          try {

                            print("书的id"+bookid.toString());
                            response = await dio.delete(url, queryParameters: {"token":token});
                            var data=jsonDecode(response.toString());
                            print(data);

                          } catch (exception) {
                            print(exception);
                            result = 'Failed ';
                          }

                          _increment();
                          Navigator.of(context).pop();

                        },
                      ),

                      Text("")
                    ],
                    contentPadding: EdgeInsets.only(left: 40.0),

                  );
                }
            );
          },
          onTap: (){

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowNoteSpaceScreen(id: e['ID'])));

          },
              child:new Column(
            children: <Widget>[
              Card(child:new Image.network('http://localhost:8080/api/notespaces/'+e['ID'].toString()+'/image', fit: BoxFit.cover,)),

              Center(child:new Text(' ${e['Name']}'),)
            ],



          )

      ));
      children.add(a);
    }
    if(children.length==2){

        a= Center();
        children.add(a);
    }
    else if(children.length==1){
      a= Center();
      children.add(a);
      children.add(a);
    }
    else if(children.length==0){
      a= Center();
      children.add(a);
      children.add(a);
      children.add(a);
    }
    return children;
  }

}

