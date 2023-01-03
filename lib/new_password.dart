import 'package:flutter/material.dart';

import 'input_dec.dart';

class NewPassword extends StatefulWidget{
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
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
            child: TextFormField(decoration: iDecoration(hint: "New Password")),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: TextFormField(decoration: iDecoration(hint: "Confirm Password")),
          ),
          ElevatedButton(
            onPressed: () {},
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
    );
  }
}