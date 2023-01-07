import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orora2/super_base.dart';
import 'package:orora2/validate_code.dart';

import 'input_dec.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends Superbase<ForgotPassword> {
  final TextEditingController _usernameController = TextEditingController();


  bool _loading = false;

  final _form = GlobalKey<FormState>();

  Future<void> sendCode() async {
    if(_form.currentState?.validate()??false) {
      setState(() {
        _loading = true;
      });
      String phone = _usernameController.text;
      await ajax(url: "reset_password/",
          method: "POST",
          data: FormData.fromMap({
            "user_phone": phone,
          }),
          onValue: (obj, url) {
            if (obj['code'] == 200) {
              push(ValidateCode(phone: phone,));
            } else {
              showSnack(obj['message']);
            }
          },
          error: (s, v) =>print(s));
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
                "Forgot your password?",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )),
            Center(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                "Enter your phone number and we’ll send you  a password reset code to change your password",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: TextFormField(
                validator: (s)=>s?.trim().isNotEmpty == true ? null : "Field is required !",
                decoration: iDecoration(hint: "Telephone"),controller: _usernameController,),
            ),
            _loading ? const Center(
              child: CircularProgressIndicator(),
            ) : ElevatedButton(
              onPressed: sendCode,
              child: const Text("Send Code"),
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
