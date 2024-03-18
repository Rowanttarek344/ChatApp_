import 'package:chat_app/database/database_utils.dart';
import 'package:chat_app/model/message.dart';
import 'package:chat_app/view/messageWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/room.dart';

class customSearchDelegate extends SearchDelegate<Message> {
  String roomId;
  customSearchDelegate({required this.roomId});
  @override
  List<Widget>? buildActions(BuildContext context) {
    //like actions after search query
    return [
      IconButton(
          onPressed: () {
            showResults(context);
          },
          icon: Icon(Icons.search))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    //icon before search query
    return IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.close));
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(Room.collectionName)
            .doc(roomId)
            .collection(Message.collectionName).snapshots(),
        builder: (context, snapshots) {
          return (snapshots.connectionState == ConnectionState.waiting)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshots.data!.docs[index].data()
                        as Map<String, dynamic>;
                    print(index);
                    print(data['content'].toString());
                    if (data['content']
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase())){
                        print(true);
                        return(Text('mawgod'));
                      }
                    return Container();



                  });
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text('');
  }
}
