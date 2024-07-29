import 'package:chat_app/modules/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier{
  //get instance of firestore & auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //get user stream
  Stream<List<Map<String , dynamic>>> getUserStream(){
    return _firestore.collection("Users").snapshots().map((snapshot){
     return snapshot.docs
         .where((doc) => doc.data()['email'] != _auth.currentUser!.email)
         .map((doc) => doc.data())
         .toList();
    });
  }

  //get all users stream except blocked users
  Stream<List<Map<String , dynamic>>> getUsersStreamExcludingBlocked(){
    final currentUser = _auth.currentUser;
    return _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async{

      //get blocked user ids
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

      //get all users
      final userSnapshot = await _firestore.collection('Users').get();

      //return as stream list , excluding current user and blocked users
      return userSnapshot.docs
          .where((doc) =>
               doc.data()['email'] != currentUser.email &&
               !blockedUserIds.contains(doc.id))
               .map((doc) => doc.data())
               .toList();
    });
  }
  // send message
 Future<void> sendMessage(String receiverID , message) async{
    //get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();


   // create a new message
   Message newMessage = Message(
       senderID: currentUserID,
       senderEmail: currentUserEmail,
       receiverID: receiverID,
       message: message,
       timestamp: timestamp,
   );

   // consturct chat room ID for the two users(sorted to ensure uniqueness)
   List<String> ids = [currentUserID , receiverID];
   ids.sort(); //sort the ids(this ensure chatroomID is the same for any 2 people)
   String chatRoomID = ids.join('_');

   // add new message to database

   await _firestore
       .collection("chat_rooms")
       .doc(chatRoomID)
       .collection("messages")
       .add(newMessage.toMap());


 }
  // get message
  Stream<QuerySnapshot> getMessage(String userID , otherUserID){
    //construct a chatroom ID for the two users
    List<String> ids = [userID , otherUserID];
    ids.sort();
    String chatRoomID= ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp" , descending: false)
        .snapshots();
  }

  // Report user
  Future<void> reportUser(String messageId, String userId) async{
    final currentUser = _auth.currentUser;
    final report = {
      'reportedBy':currentUser!.uid,
      'messageId':messageId,
      'messageOwnerId':userId,
      'timestamp':FieldValue.serverTimestamp(),
    };

    await _firestore.collection("Reports").add(report);
  }

  // Block user
  Future<void> blockUser(String userId) async{
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(userId)
        .set({});
    notifyListeners();
  }

  // Unblock user
  Future<void> unblockUser(String blockedUserId) async{
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(blockedUserId)
        .delete();

  }

  // Get blocked users stream
  Stream<List<Map<String , dynamic>>> getBlockedUsersStream(String userId){
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {

      //get list of blocked user ids
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

      final userDocs = await Future.wait(
          blockedUserIds
          .map((id) => _firestore.collection('Users').doc(id).get()));

      // return as a list
      return userDocs.map((doc) => doc.data() as Map<String ,dynamic>).toList();
    });

  }

}