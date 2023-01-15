import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orora2/input_dec.dart';
import 'package:orora2/super_base.dart';

import 'json/user.dart';

class FeedsRegistration extends StatefulWidget{
  const FeedsRegistration({super.key});

  @override
  State<FeedsRegistration> createState() => _FeedsRegistrationState();
}

class _FeedsRegistrationState extends Superbase<FeedsRegistration> {


  var key = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var quantityController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }



  bool _loading = false;

  void register()async{
    if(key.currentState?.validate()??false){
      setState(() {
        _loading = true;
      });
      await ajax(url: "feeds/addFeed",method: "POST",data: FormData.fromMap(
          {
            "token":User.user?.token,
            "feed_name":nameController.text,
            "min_quantity":quantityController.text,
            "notes":descriptionController.text,
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
        title: const Text("Feeds Registration"),
      ),
      body: Form(
        key: key,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(controller: nameController,validator: (s)=>s?.trim().isNotEmpty == true ? null : 'Name is required',decoration: iDecoration(hint: "Feed name"),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(controller: quantityController,inputFormatters: [FilteringTextInputFormatter.digitsOnly],keyboardType: TextInputType.number,validator: (s)=>s?.trim().isNotEmpty == true ? null : 'Min quantity is required',decoration: iDecoration(hint: "Min Quantity"),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(controller: descriptionController,minLines: 4,maxLines: 6,validator: (s)=>s?.trim().isNotEmpty == true ? null : 'Notes is required',decoration: iDecoration(hint: "Notes"),),
            ),
            _loading ? const Center(child: CircularProgressIndicator(),) : ElevatedButton(onPressed: register, child: const Text("Add Feed"))
          ],
        ),
      ),
    );
  }
}