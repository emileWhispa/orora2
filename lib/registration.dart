import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orora2/homepage.dart';
import 'package:orora2/super_base.dart';

import 'input_dec.dart';
import 'json/user.dart';

class Registration extends StatefulWidget{
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends Superbase<Registration> {

  var key = GlobalKey<FormState>();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var fNameController = TextEditingController();
  var lNameController = TextEditingController();
  var emailController = TextEditingController();

  bool loading = false;

  void register() async {
    if(key.currentState?.validate()??false){

      setState(() {
        loading = true;
      });
      await ajax(url: "account/register",method: "POST",data: FormData.fromMap({
        "fname":fNameController.text,
        "lname":lNameController.text,
        "user_email":emailController.text,
        "user_phone":phoneController.text,
        "user_password":passwordController.text,
      }),onValue: (obj,url){
        print(obj);
        if(obj['code'] == 200){
          showSnack(obj['message'],context: context);
          goBack();
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
                controller: fNameController,
                validator: (s)=>s?.trim().isNotEmpty == true ? null : 'First name is required',
                decoration: iDecoration(hint: "First Name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                controller: lNameController,
                validator: (s)=>s?.trim().isNotEmpty == true ? null : 'Last Name is required',
                decoration: iDecoration(hint: "Last Name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                controller: emailController,
                validator: validateEmail,
                decoration: iDecoration(hint: "Email"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                controller: phoneController,
                validator: validateMobile,
                decoration: iDecoration(hint: "Phone number"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: TextFormField(controller: passwordController,
                  validator: (s)=>s?.trim().isNotEmpty == true ? null : 'Password is required',decoration: iDecoration(hint: "Password"),obscureText: true),
            ),
            loading ? const Center(child: CircularProgressIndicator(),) : ElevatedButton(onPressed:register, child: const Text("Register"),),

            Center(child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text("OR",style: Theme.of(context).textTheme.titleLarge,),
            ),),
            OutlinedButton(onPressed: ()=>Navigator.pop(context), child: const Text("Login"))
          ],
        ),
      ),
    );
  }
}