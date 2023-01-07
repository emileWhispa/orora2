import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orora2/new_password.dart';
import 'package:orora2/super_base.dart';

import 'input_dec.dart';
import 'json/user.dart';

class ValidateCode extends StatefulWidget{
  final String phone;
  const ValidateCode({super.key, required this.phone});

  @override
  State<ValidateCode> createState() => _ValidateCodeState();
}

class _ValidateCodeState extends Superbase<ValidateCode> {

  final TextEditingController _usernameController = TextEditingController();


  bool _loading = false;

  final _form = GlobalKey<FormState>();

  Future<void> sendCode() async {
    if(_form.currentState?.validate()??false) {
      setState(() {
        _loading = true;
      });
      await ajax(url: "reset_password/verify",
          method: "POST",
          data: FormData.fromMap({
            "user_phone": widget.phone,
            "code": _usernameController.text,
          }),
          onValue: (obj, url) {
            if (obj['code'] == 200) {
              var user = User.fromJson(obj['data']);
              push(NewPassword(user: user));
            } else {
              showSnack(obj['message']);
            }
          },
          error: (s, v) => showSnack("$s"));
      setState(() {
        _loading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _form,
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
                    "Password reset code",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )),
            Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Kindly fill the password reset code we have sent To your phone number",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: TextFormField(decoration: iDecoration(hint: "Your Code"),controller: _usernameController,
                validator: (s)=>s?.trim().isNotEmpty == true ? null : "Field is required !",),
            ),
            _loading ? const Center(
              child: CircularProgressIndicator(),
            ) : ElevatedButton(
              onPressed: sendCode,
              child: const Text("Validate Code"),
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