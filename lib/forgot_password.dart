import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orora2/validate_code.dart';

import 'input_dec.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
            child: TextFormField(decoration: iDecoration(hint: "Telephone")),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context)=>const ValidateCode()));
            },
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
    );
  }
}
