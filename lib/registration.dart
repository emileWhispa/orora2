import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orora2/homepage.dart';

import 'input_dec.dart';

class Registration extends StatefulWidget{
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20).copyWith(top: MediaQuery.of(context).padding.top),
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Image.asset("assets/logo.png"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: TextFormField(
              decoration: iDecoration(hint: "First Name"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: TextFormField(
              decoration: iDecoration(hint: "Last Name"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: TextFormField(
              decoration: iDecoration(hint: "Email"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: TextFormField(
              decoration: iDecoration(hint: "Phone number"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: TextFormField(decoration: iDecoration(hint: "Password"),obscureText: true),
          ),
          ElevatedButton(onPressed: (){
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=>const Homepage()));
          }, child: const Text("Register"),),

          Center(child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text("OR",style: Theme.of(context).textTheme.titleLarge,),
          ),),
          OutlinedButton(onPressed: ()=>Navigator.pop(context), child: const Text("Login"))
        ],
      ),
    );
  }
}