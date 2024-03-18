import 'package:chat_app/model/my_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/message.dart';
import '../model/room.dart';

class DatabaseUtils {
  static CollectionReference<MyUser> getUserCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
          fromFirestore: (snapshot, _) => MyUser.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        );
  }

  static Future<void> registerUser(MyUser user) {
    return getUserCollection().doc(user.id).set(user);
  }

  static Future<MyUser?> getUser(String userId) async {
    var documentSnapshot = await getUserCollection().doc(userId).get();
    return documentSnapshot.data();
  }

  static CollectionReference<Room> getRoomCollection() {
    return FirebaseFirestore.instance
        .collection(Room.collectionName)
        .withConverter<Room>(
          fromFirestore: (snapshot, _) => Room.fromJson(snapshot.data()!),
          toFirestore: (room, _) => room.toJson(),
        );
  }

  static Future<void> addRoom(Room room) {
    var docRef = getRoomCollection().doc();
    room.roomId = docRef.id;
    return docRef.set(room);
  }

  static Stream<QuerySnapshot<Room>> getRooms() {
    return getRoomCollection().snapshots();
  }

  static addRoomParticipant(Room room, List<dynamic> participants) {
    FirebaseFirestore.instance
        .collection(Room.collectionName)
        .doc(room.roomId)
        .update({'participants': participants});
    print("you were added to the room successfully!");
    print(room.participants);
  }

  static removeRoomParticipant(Room room, List<dynamic> participants) {
    FirebaseFirestore.instance
        .collection(Room.collectionName)
        .doc(room.roomId)
        .update({'participants': participants});
    print("you left the room successfully!");
    print(room.participants);
  }

  static CollectionReference<Message> getMessageCollection(String roomId) {
    return FirebaseFirestore.instance
        .collection(Room.collectionName)
        .doc(roomId)
        .collection(Message.collectionName)
        .withConverter<Message>(
          fromFirestore: (snapshot, _) => Message.fromJson(snapshot.data()!),
          toFirestore: (message, _) => message.toJson(),
        );
  }

  static Future<void> insertMessage(Message message) {
    var docRef = getMessageCollection(message.roomId).doc();
    message.id = docRef.id;
    return docRef.set(message);
  }

  static Stream<QuerySnapshot<Message>> getMessages(String roomId) {
    return getMessageCollection(roomId).orderBy('date_time').snapshots();
  }

  static Future<List<Message>> fetchData(String query, String roomId) async {
    List<Message> messages_list = [];
    QuerySnapshot<Message> querySnapshot =
        await getMessageCollection(roomId).get();
    messages_list = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(messages_list.length);
    return messages_list;
  }
}
