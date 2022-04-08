import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';


void main() => runApp(MyApp());

    class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
    }

    class _MyAppState extends State <MyApp> {

      File? _image;
      final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();


      Future getImage(bool isCamera) async{
         File? image = File("/images/img.png");
         _uploadFile(image);
        if(isCamera){
          image = await ImagePicker.pickImage(source: ImageSource.camera) as File;
        }

        setState(() {
          _image = image;
        });
      }

      void _uploadFile(filePath) async {
        // Get base file name
        String fileName = basename(filePath.path);
        print("File base name: $fileName");

        try {
          FormData formData =
          new FormData.from({"file": new UploadFileInfo.fromFile(filePath, fileName)});

          Response response =
          await Dio().post("http://192.168.0.101/saveFile.php", data: formData);
          print("File upload response: $response");


          _showSnakBarMsg(response.data['message']);
        } catch (e) {
          print("Exception Caught: $e");
        }
      }


      void _showSnakBarMsg(String msg) {
        _scaffoldstate.currentState!
        .showSnackBar(new SnackBar(content: new Text(msg)));
      }

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      home:
        Scaffold(
          key: _scaffoldstate,
        backgroundColor: Colors.blue,
        appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
        child: Text(
        'G-SAVI'),
    ),
    ),
          body:
          Column(
            children: <Widget>[
              DicePage(),
              _image == null? Container() : Image.file(_image!,height: 300,width: 300,)
            ],
          ),
    ),
    );
  }

  void showSnackBar(SnackBar snackBar) {}

    }


class DicePage extends StatefulWidget {

  @override
  _DicePageState createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  int DiceNumber = 0;


  void changedata() {
    setState(() {
      getImage(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 400),
        height: 70,
        width: 300,
        color: Colors.red,
        child: FlatButton(
          onPressed: changedata,
          child: Image(image: AssetImage('images/dice$DiceNumber.png'),

          ),
        ),
      ),
    );
  }
}

File? _image;
Future getImage(bool isCamera) async {
  File? image = File("/images/img.png");
  if (isCamera) {
    image = await ImagePicker.pickImage(source: ImageSource.camera) as File;
  }
}

// class _MyHomePageState extends StatefulWidget {
//
//
//   @override
//   _MyHomePageStateState createState() => _MyHomePageStateState();
// }
//
// class _MyHomePageStateState extends State<_MyHomePageState> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }




