
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';

class LoginPage extends StatelessWidget {

  // tap to the register page
  final void Function()? onTap;
  LoginPage({Key? key,required this.onTap}) : super(key: key);

  //email and pw text controllers

  final TextEditingController _emailController =TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //login method
  void login(BuildContext context) async{
    // auth service
    final authService = AuthService();

    //try login
    try{
      await authService.signInWithEmailPassword(_emailController.text, _passwordController.text);
    }
    //catch any errors
    catch(e){
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text(e.toString()),
      ),);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(Icons.message,size: 60,color: Theme.of(context).colorScheme.primary,),
            SizedBox(height: 50,),
            // welcome back message
            Text("Welcome back , you've been missed!",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 16),),

            SizedBox(height: 50,),

            // pw textfield
            MyTextField(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
            ),
            SizedBox(height: 10,),
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: _passwordController,
            ),
            SizedBox(height: 30 ,),

            //login button
            MyButton(
              text: "Login",
              onTap: () => login(context),
            ),
            SizedBox(height: 25,),

            //register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Not a member? ",style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                GestureDetector(
                  onTap: onTap,
                    child: Text(
                      "Register now",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),),
              ],
            )
            

          ],
        ),
      ),
    );
  }
}
