
import 'package:chat_app/components/my_drawer.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

import '../components/user_tile.dart';
import 'chat_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  //chat and auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 98.0),
          child: Text("Home"),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,

      ),
      drawer: MyDrawer(),
      body: _buildUserList(),
    );
  }

  //build a list of users except for the current logged in user
  Widget _buildUserList(){
    return StreamBuilder(
        stream: _chatService.getUsersStreamExcludingBlocked(),
        builder: (context, snapshot) {
          //error
          if(snapshot.hasError){
            return Text("Error");
          }
          //loading
          if(snapshot.connectionState == ConnectionState.waiting){
            return Text("Loading..");

          }
          //return list view
          return ListView(
            children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData,context)).toList(),
          );
        },
    );
  }

  //build individual list tile for user
   Widget _buildUserListItem(Map<String , dynamic> userData, BuildContext context){
    // display all users except current user
    if(userData["email"] != _authService.getCurrentUser()!.email){
      return UserTile(
        text: userData["email"],
        onTap: (){
          //tapped on a user -> go to chat page
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
            receiverEmail: userData["email"],
            receiverID: userData["uid"],
          ),));
        },
      );
    }
    else{
      return Container();
    }
   }
}
