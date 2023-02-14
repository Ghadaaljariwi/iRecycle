import 'package:flutter/material.dart';
import 'package:irecycle/pages/ImageResult.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'Mycard.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final imagePicker = ImagePicker();
  final apiKey = 'AIzaSyDvdqwITHh09sYJE7kq0R4MPLf7OoObSCo';
  String result = '';
  String type = '';

  Future<void> _getPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }
    if (status.isGranted) {
      status = await Permission.photos.status;
      if (status.isDenied) {
        status = await Permission.photos.request();
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await imagePicker.getImage(source: source);
    if (pickedFile != null) {
      _sendImage(pickedFile.path);
    }
  }

  Future<void> _sendImage(String path) async {
    final response = await http.post(
      Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'requests': [
          {
            'image': {
              'content': base64Encode(File(path).readAsBytesSync()),
            },
            'features': [
              {
                'type': type,
                'maxResults': 1,
              },
            ],
          },
        ],
      }),
    );
    final decodedResponse = jsonDecode(response.body);
    if (type == 'OBJECT_LOCALIZATION') {
      result = decodedResponse['responses'][0]['localizedObjectAnnotations'][0]
          ['name'];
    } else if (type == 'TEXT_DETECTION') {
      result =
          decodedResponse['responses'][0]['textAnnotations'][0]['description'];
    }
    //_showResult();

    Navigator.of(context).push(PageRouteBuilder(
      //fullscreenDialog: true,
      pageBuilder: (BuildContext context, _, __) => ImageResult(
        result: result,
      ),
    ));
  }

  Future<void> _showResult() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Result'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(result),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*
              ElevatedButton(
                child: Text('Scan Object'),
                onPressed: () {
                  _getPermission();
                  _pickImage();
                  type = 'OBJECT_LOCALIZATION';
                },
              ),
              */
              ElevatedButton(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('From Gallery',
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      Padding(padding: EdgeInsets.all(5)),
                      Icon(
                        Icons.photo_library_outlined,
                        size: 30,
                      )
                    ]),
                onPressed: () {
                  _getPermission();
                  _pickImage(ImageSource.gallery);
                  type = 'TEXT_DETECTION';
                },
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('From Camera',
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      Padding(padding: EdgeInsets.all(5)),
                      Icon(
                        Icons.photo_camera,
                        size: 30,
                      )
                    ]),
                onPressed: () {
                  _getPermission();
                  _pickImage(ImageSource.camera);
                  type = 'TEXT_DETECTION';
                },
              ),
            ]),
      ),
    );
  }
}
