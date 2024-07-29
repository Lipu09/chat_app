import 'package:chat_app/services/chat/chat_service.dart';
import 'package:chat_app/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;
  const ChatBubble({Key? key,
    required this.message,
    required this.isCurrentUser,
    required this.messageId,
    required this.userId,
  }) : super(key: key);

  //show options
  void showOptions(BuildContext context , String messageId , String userId){
    showModalBottomSheet(context: context, builder: (context) {
      return SafeArea(child: Wrap(
        children: [
          // report button
          ListTile(
            leading: Icon(Icons.flag),
            title: Text("Report"),
            onTap: (){
              Navigator.pop(context);
              _reportMessage(context,messageId ,userId);
            },
          ),
          //block user button
          ListTile(
            leading: Icon(Icons.block),
            title: Text("Block user"),
            onTap: (){
               Navigator.pop(context);
              _blocUser(context,userId);
            },
          ),

          // cancel button
          ListTile(
            leading: Icon(Icons.cancel),
            title: Text("Cancel"),
            onTap: ()=> Navigator.pop(context),
          ),
        ],
      ));
    },);
  }
  //report message
  void _reportMessage(BuildContext context , String messageId , String userId){
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text("Report Message"),
      content: Text("Are you sure you want to report this message!"),
      actions: [
        TextButton(
            onPressed: ()=> Navigator.pop(context),
            child: Text("Cancel"),
        ),

        //report button
        TextButton(
          onPressed: (){
            ChatService().reportUser(messageId, userId);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Message Reported")));

          },
          child: Text("Report"),
        ),

      ],
    ),);
  }


  //block user

  void _blocUser(BuildContext context  , String userId){
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text("Block User!"),
      content: Text("Are you sure you want to block this user?"),
      actions: [
        TextButton(
          onPressed: ()=> Navigator.pop(context),
          child: Text("Cancel"),
        ),

        //block button
        TextButton(
          onPressed: (){
            // perform block
            ChatService().blockUser(userId);
            //dismiss dialog
            Navigator.pop(context);
            //dismiss page
            Navigator.pop(context);
            // let user know of result
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("User Blocked")));

          },
          child: Text("Block"),
        ),

      ],
    ),);
  }



  @override
  Widget build(BuildContext context) {
    //light vs dark mode for correct bubble colors
    bool isDarkMode = Provider.of<ThemeProvider>(context,listen: false).isDarkMode;
    return GestureDetector(
      onLongPress: () {
        if(!isCurrentUser){
          // show options
          showOptions(context, messageId, userId);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isCurrentUser ?  (isDarkMode ? Colors.green.shade600 :Colors.green.shade500)
              : (isDarkMode ? Colors.grey.shade800 :Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 2.5,horizontal: 25),
        child: Text(message , style: TextStyle(color: isCurrentUser ? Colors.white :(isDarkMode ? Colors.white: Colors.black)),),
      ),
    );
  }
}
