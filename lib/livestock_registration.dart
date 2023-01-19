import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:orora2/super_base.dart';

import 'input_dec.dart';
import 'json/farm.dart';
import 'json/user.dart';

class LivestockRegistration extends StatefulWidget{
  final Farm farm;
  const LivestockRegistration({super.key, required this.farm});

  @override
  State<LivestockRegistration> createState() => _LivestockRegistrationState();
}

class _LivestockRegistrationState extends Superbase<LivestockRegistration> {

  String? _gender;
  String? _breed;
  var tagController = TextEditingController();
  var notesController = TextEditingController();
  var key = GlobalKey<FormState>();

  bool _loading = false;

  void register()async{
    if(key.currentState?.validate()??false){
      setState(() {
        _loading = true;
      });
      await ajax(url: "farms/addLivestock",method: "POST",data: FormData.fromMap(
          {
            "token":User.user?.token,
            "tag":tagController.text,
            "farm_id":widget.farm.id,
            "breed":_breed,
            "notes":notesController.text,
            "gender":_gender,
          }),onValue: (s,v){
        showSnack(s['message']);
        if(s['code'] == 200) {
          goBack();
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
      appBar: AppBar(
        title: const Text("Livestock Registration"),
      ),
      body: Form(
        key: key,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(validator: (s)=>s?.trim().isNotEmpty == true ? null : "Field is required !!!",controller: tagController,decoration: iDecoration(hint: "Livestock Tag"),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownButtonFormField<String>(validator: (s)=>s?.trim().isNotEmpty == true ? null : "Field is required !!!",value: _gender,items: ["Male","Female"].map((e) => DropdownMenuItem(value: e,child: Text(e),)).toList(), onChanged: (val){
                setState(() {
                  _gender =val;
                });
              },decoration: iDecoration(hint: "Gender"),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownButtonFormField<String>(validator: (s)=>s?.trim().isNotEmpty == true ? null : "Field is required !!!",value: _breed,items: ["Alpine","Boer","Kiko"].map((e) => DropdownMenuItem(value: e,child: Text(e),)).toList(), onChanged: (val){
setState(() {
  _breed = val;
});
              },decoration: iDecoration(hint: "Breed"),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(minLines: 3,maxLines: null,validator: (s)=>s?.trim().isNotEmpty == true ? null : "Field is required !!!",controller: notesController,decoration: iDecoration(hint: "Notes"),),
            ),
            _loading ? const Center(child: CircularProgressIndicator(),) : ElevatedButton(onPressed: register, child: const Text("Register"))
          ],
        ),
      ),
    );
  }
}