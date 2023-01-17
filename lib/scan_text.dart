import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final imagePicker = ImagePicker();
  final apiKey = 'AIzaSyDvdqwITHh09sYJE7kq0R4MPLf7OoObSCo';
  String result = '';

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

  Future<void> _pickImage() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
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
                'type': 'TEXT_DETECTION',
                'maxResults': 1,
              },
            ],
          },
        ],
      }),
    );
    final decodedResponse = jsonDecode(response.body);
    result = decodedResponse['responses'][0]['localizedObjectAnnotations'][0]
        ['name'];
    _showResult();
  }

  Future<void> _showResult() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Result'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(result),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
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
        child: Container(
          height: 100,
          width: 100,
          color: Colors.yellow,
          child: ElevatedButton(
            child: Text('Take Picture'),
            onPressed: () {
              _getPermission();
              _pickImage();
            },
          ),
        ),
      ),
    );
  }
}
