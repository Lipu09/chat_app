
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/auth/auth_service.dart';
class RegisterPage extends StatelessWidget {

  // tap to go the login page
   final void Function()? onTap;
   RegisterPage({Key? key,required this.onTap}) : super(key: key);

  final TextEditingController _emailController =TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cnfpasswordController = TextEditingController();

  //register method
  void register(BuildContext context){
    // get auth service
    final _auth =AuthService();
    // if the password match -> create the user
    if(_passwordController.text == _cnfpasswordController.text){
      try{
        _auth.signUpWithEmailPassword(_emailController.text, _passwordController.text);
      }
      catch(e){
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(e.toString()),
            ),
        );
      }
    }
    // password dont match ->show error to user
    else{
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Password don't match!"),
        ),
      );
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
              Text("Let's create new account for you",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 16),),
      
              SizedBox(height: 50,),
      
              // email textfield
              MyTextField(
                hintText: "Email",
                obscureText: false,
                controller: _emailController,
              ),
              SizedBox(height: 10,),
              // pw textfield
              MyTextField(
                hintText: "Password",
                obscureText: true,
                controller: _passwordController,
              ),
              SizedBox(height: 10 ,),
              //confirm password
              MyTextField(
                hintText: "Confirm Password",
                obscureText: true,
                controller: _cnfpasswordController,
              ),
              SizedBox(height: 20,),
      
              //login button
              MyButton(
                text: "Register",
                onTap: () => register(context),
              ),
              SizedBox(height: 25,),
      
              //register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ",style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "Login now",
                      style: TextStyle(fontWeight: FontWeight.bold,),
                    ),),
                ],
              ),
      
      
            ],
          ),
        ),
      );

  }
}
