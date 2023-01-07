import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';


class WritePost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WritePost();
}

class _WritePost extends State<WritePost> {
  TextEditingController writingTextController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  FocusNode writingTextFocus = FocusNode();
  bool _isLoading = false;

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          displayArrows: false,
          focusNode: _nodeText1,
        ),
        KeyboardActionsItem(
          displayArrows: false,
          focusNode: writingTextFocus,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () {
                  print('Select Image');
                  _getImageAndCrop();
                },
                child: Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.add_photo_alternate, size: 28),
                      Text(
                        "Add Image",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        centerTitle: true,
        actions: <Widget>[
          ElevatedButton(
              onPressed: () {
                
              },
              child: Text(
                'Post',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: Stack(
        children: <Widget>[
          KeyboardActions(
            config: _buildConfig(context),
            child: Column(
              children: <Widget>[
                Container(
                    width: size.width,
                    height: size.height -
                        MediaQuery.of(context).viewInsets.bottom -
                        80,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 14.0, left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    width: 40,
                                    height: 40,
                                    child: Image.asset(
                                        'images/recycling.png')),
                              ),
                              Text(
                         'name',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1,
                            color: Colors.black,
                          ),
                          TextFormField(
                            autofocus: true,
                            focusNode: writingTextFocus,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Writing anything.',
                              hintMaxLines: 4,
                            ),
                            controller: writingTextController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          ),
                          Container(),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getImageAndCrop() async {
    File imageFileFromGallery =
        (await ImagePicker().getImage(source: ImageSource.gallery)) as File;
        
    if (imageFileFromGallery != null) {
      File cropImageFile =
          imageFileFromGallery; //await cropImageFile(imageFileFromGallery);
      if (cropImageFile != null) {
        setState(() {
   
        });
      }
    }
  }
}
