import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orora2/forgot_password.dart';
import 'package:orora2/input_dec.dart';
import 'package:orora2/registration.dart';
import 'package:orora2/super_base.dart';

import 'homepage.dart';
import 'json/user.dart';

class Authentication extends StatefulWidget{
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends Superbase<Authentication> {

  var key = GlobalKey<FormState>();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  bool loading = false;

  void login() async {
    if(key.currentState?.validate()??false){

      setState(() {
        loading = true;
      });
      await ajax(url: "account/login",method: "POST",data: FormData.fromMap({
        "user_phone":phoneController.text,
        "user_password":passwordController.text,
      }),onValue: (obj,url){
        if(obj['code'] == 200){
          save(userKey, obj['data']);
          User.user = User.fromJson(obj['data']);
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=>const Homepage()));
        }else {
          showSnack(obj['message'],context: context);
        }
      });

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: key,
        child: ListView(
          padding: const EdgeInsets.all(20).copyWith(top: MediaQuery.of(context).padding.top),
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Image.asset("assets/logo.png"),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                controller: phoneController,
                validator: (s)=>(s?.trim().length??0) >= 10 ? null : 'Telephone has to be at least 10 digits',
                decoration: iDecoration(hint: "Telephone"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: TextFormField(
                controller: passwordController,
                  validator: (s)=>s?.trim().isNotEmpty == true ? null : 'Password is required',
                  decoration: iDecoration(hint: "Password"),obscureText: true),
            ),
            loading ? const Center(child: CircularProgressIndicator()) : ElevatedButton(onPressed: login, child: const Text("Login"),),
            Align(alignment: Alignment.centerRight,child: TextButton(onPressed: (){
              Navigator.push(context, CupertinoPageRoute(builder: (context)=>const ForgotPassword()));
            }, child: const Text("Forgot Password ?")),),
            Center(child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text("OR",style: Theme.of(context).textTheme.titleLarge,),
            ),),
            OutlinedButton(onPressed: (){
              Navigator.push(context, CupertinoPageRoute(builder: (context)=>const Registration()));
            }, child: const Text("Register"))
          ],
        ),
      ),
    );
  }
}