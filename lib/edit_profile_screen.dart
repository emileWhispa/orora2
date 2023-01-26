import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orora2/super_base.dart';

import 'json/user.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends Superbase<EditProfileScreen> {

  final _key = GlobalKey<FormState>();
  final _firstController = TextEditingController();
  final _lastController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firstController.text = User.user?.fName ?? "";
    _lastController.text = User.user?.lName ?? "";
    _emailController.text = User.user?.email ?? "";
    _phoneController.text = User.user?.phone ?? "";
  }

  bool _saving = false;


  void updateProfile() async {
    if(_key.currentState?.validate()??false){
      setState(() {
        _saving = true;
      });
      await ajax(url: "profile/updateProfile",method: "POST",data: FormData.fromMap(
          {
            "token":User.user?.token,
            "user_fname":_firstController.text,
            "user_lname":_lastController.text,
            "user_email":_emailController.text,
            "user_phone":_phoneController.text,
          }),onValue: (s,v){

        showSnack(s['message']);
        if(s['code'] == 200) {
          User.user?.phone = _phoneController.text;
          User.user?.email = _emailController.text;
          User.user?.fName = _firstController.text;
          User.user?.lName = _lastController.text;
          goBack();
        }
      });
      setState(() {
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Your Profile"),
          actions: [TextButton(onPressed: _saving ? null : updateProfile,style: TextButton.styleFrom(
            foregroundColor: Colors.white
          ), child: _saving ? const CupertinoActivityIndicator() : const Text("SAVE"),)],
        ),
        extendBodyBehindAppBar: true,
        body: DefaultTextStyle.merge(
            style: const TextStyle(color: Colors.white),
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      const Color(0xff617c0e),
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor,
                      Colors.white,
                      Colors.white,
                      Colors.white,
                    ])),
                child: Form(
                  key: _key,
                  child: Theme(
                    data: ThemeData(),
                    child: ListView(
                      children: [
                         Center(
                          child: CircleAvatar(
                            radius: 40,
                            child: Text(User.user?.initials??""),
                          ),
                        ),
                         Center(
                            child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            User.user?.display??"",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        )),
                        Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                TextFormField(
                                  enabled: !_saving,
                                  controller: _firstController,
                                  validator: (s)=>s?.trim().isEmpty == true ? "First Name is required !!" : null,
                                  decoration:
                                      const InputDecoration(labelText: "First Name"),
                                ),
                                TextFormField(
                                  enabled: !_saving,
                                  controller: _lastController,
                                  validator: (s)=>s?.trim().isEmpty == true ? "Last Name is required !!" : null,
                                  decoration:
                                      const InputDecoration(labelText: "Last Name"),
                                ),
                                TextFormField(
                                  enabled: !_saving,
                                  controller: _emailController,
                                  validator: validateEmail,
                                  decoration:
                                      const InputDecoration(labelText: "Email"),
                                ),
                                TextFormField(
                                  enabled: !_saving,
                                  controller: _phoneController,
                                  validator: validateMobile,
                                  decoration:
                                      const InputDecoration(labelText: "Phone Number"),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ))));
  }
}
