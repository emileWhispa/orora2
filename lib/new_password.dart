import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:orora2/homepage.dart';
import 'package:orora2/super_base.dart';

import 'input_dec.dart';
import 'json/user.dart';

class NewPassword extends StatefulWidget{
  final User user;
  const NewPassword({super.key, required this.user});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends Superbase<NewPassword> {

  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _loading = false;

  final _key = GlobalKey<FormState>();

  void register()async{
    if (_key.currentState?.validate() ?? false) {
      setState(() {
        _loading = true;
      });
      await ajax(url: "reset_password/newPassword",
          method: "POST",
          data: FormData.fromMap(
              {
                "user_id": widget.user.id,
                "new_password": _newPassword.text,
              }), onValue: (obj, url) {
            if( obj['code'] == 200 ){
              User.user = widget.user;
              push(const Homepage(),replaceAll: true);
            }else{
              showSnack(obj['message']);
            }
          });
      setState(() {
        _loading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(20)
              .copyWith(top: MediaQuery.of(context).padding.top),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Image.asset("assets/logo.png"),
            ),
            Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    "New Password",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )),
            Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Now you can fill in the new password",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(decoration: iDecoration(hint: "New Password"),controller: _newPassword,
                obscureText: true,
                validator: (s)=>s?.isNotEmpty == true ? null : "Password is required !",),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: TextFormField(decoration: iDecoration(hint: "Confirm Password"),controller: _confirmPassword,
                obscureText: true,
                validator: (s)=>s?.isNotEmpty == true ? s == _newPassword.text ? null : "Password and confirm has to match" : "Confirm Password is required !",),
            ),
            _loading ? const Center(
              child: CircularProgressIndicator(),
            ) : ElevatedButton(
              onPressed: register,
              child: const Text("Update Password"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: OutlinedButton(onPressed: () =>Navigator.pop(context),style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  foregroundColor: Colors.red
              ), child: const Text("Cancel")),
            )
          ],
        ),
      ),
    );
  }
}