import 'package:database_ally/core/intent.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

//inent 1 --> settings profile attach image
//intent 2 -->chat
class PicturesScreen extends StatefulWidget {
   static String tag = 'picture-screen-page';
  int intent;

  String chatId;
  String senderId;
  String senderPhoneNumber;
  String recepientId;
  String recepientPhoneNumber;

  String groupId;
  String groupName;

  PicturesScreen(
      { this.intent = Intent.intentZeroAction,
       this.chatId = "",
       this.senderId = "",
       this.senderPhoneNumber= "",
       this.recepientId = "",
       this.recepientPhoneNumber= "",
       this.groupId = "",
       this.groupName = ""});
  @override
  PicturesScreenState createState() {
    return new PicturesScreenState();
  }
}

class PicturesScreenState extends State<PicturesScreen> {
  static const platform = const MethodChannel('com.araizen/modules/utils');

  Future<List<dynamic>> _getContacts() async {
    List<dynamic> _conts = [];

    try {
      _conts = await platform.invokeMethod('getImagePaths') as List<dynamic>;
    } on PlatformException catch (e) {
      print("\n\n Failed to get ciontacts : '${e.message}'. \n\n");
    }

    return _conts;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<dynamic> values = snapshot.data;

if(values!=null && values.length >0 ){
    return new ListView.builder(
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            new ListTile(
              title: new Text(
                path.basenameWithoutExtension(
                  '${values[index]}',
                ),
                style: TextStyle(fontSize: 13.0),
              ),
              onTap: () {
               
              },
              onLongPress: () {},
            ),
            new Divider(
              height: 2.0,
            ),
          ],
        );
      },
    );
}else{
  return Center(child: Text("No picture Available"),);
}
  }

  Widget _showAppropriatewidget() {
//    if(_contacts.length > 0){
    return Container(
        child: FutureBuilder<List<dynamic>>(
      future: _getContacts(), //_calculateDistance( model,  store),
      initialData: ["kamau"], //0.0,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return createListView(context, snapshot);
        } else if (snapshot.hasError) {
          return Text("errror ${snapshot.error}");
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _showAppropriatewidget());
  }
}
