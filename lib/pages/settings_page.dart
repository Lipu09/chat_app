import 'package:chat_app/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'blocked_users_pages.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 58.0),
          child: Text("S E T T I N G S"),
        ),

        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          //dark mode
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.only(left: 25,right: 25,top: 10),
            padding: EdgeInsets.only(left: 25,right: 25,top: 20,bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //dark mode
                Text("Dark Mode"),

                // switch toggle
                CupertinoSwitch(
                    value: Provider.of<ThemeProvider>(context,listen: false).isDarkMode,
                    onChanged: (value)=>Provider.of<ThemeProvider>(context,listen: false).toggleTheme(),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.only(left: 25,right: 25,top: 10),
            padding: EdgeInsets.only(left: 25,right: 25,top: 20,bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //dark mode
                Text("Blocked Users" , style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.inversePrimary),),

                //button to go to blocked user page
                IconButton(
                    onPressed: ()=>Navigator.push(context,
                        MaterialPageRoute(
                  builder: (context) => BlockedUserPage(),)),
                    icon: Icon(Icons.arrow_forward_rounded , color: Theme.of(context).colorScheme.primary,)
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
