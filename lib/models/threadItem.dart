import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:irecycle/common/utils.dart';

class ThreadItem extends StatefulWidget {
  final BuildContext parentContext;
  final DocumentSnapshot data;
  
  final bool isFromThread;
  final int commentCount;
  ThreadItem(
      {required this.data,

     
      required this.isFromThread,
      required this.commentCount,
      required this.parentContext});

  @override
  State<StatefulWidget> createState() => _ThreadItem();
}

class _ThreadItem extends State<ThreadItem> {
 

  @override
  void initState() {
 
   
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 6),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                 
                },
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6.0, 2.0, 10.0, 2.0),
                      child: Container(
                          width: 48,
                          height: 48,
                          child: 
                          
                          Image.asset(
                                'assets/images/recycling.png')),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(

                          widget.data['userName']
                          ,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            "",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                   ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 4, 10),
                  child: Text(
                    (widget.data['postContent'] as String).length > 200
                        ? '${widget.data['postContent'].substring(0, 132)} ...'
                        : widget.data['postContent'],
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    maxLines: 3,
                  ),
                ),
              ),
              widget.data['postImage'] != 'NONE'
                  ? GestureDetector(
                      onTap: () {
                          },
                      child: Utils.cacheNetworkImageWithEvent(
                          context, widget.data['postImage'], 0, 0))
                  : Container(),
              Divider(
                height: 2,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.thumb_up,
                              size: 18,
                              color:  Colors.black),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '600',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                      
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.mode_comment, size: 18),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Comment ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
