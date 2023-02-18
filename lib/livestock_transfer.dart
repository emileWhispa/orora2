import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orora2/json/livestock.dart';
import 'package:orora2/super_base.dart';

import 'input_dec.dart';
import 'json/farm.dart';
import 'json/user.dart';

class LivestockTransfer extends StatefulWidget{
  final Livestock livestock;
  const LivestockTransfer({super.key, required this.livestock});

  @override
  State<LivestockTransfer> createState() => _LivestockTransferState();
}

class _LivestockTransferState extends Superbase<LivestockTransfer> {

  final _receiverController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  String? _type;

  bool _loading = false;
  final _key = GlobalKey<FormState>();

  @override
  void initState(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>loadFarms());
    super.initState();
  }

  List<Farm> _farms = [];
  Farm? _farm;

  void transfer()async{
    if(_key.currentState?.validate()??false){
      setState(() {
        _loading = true;
      });
      await ajax(url: "farms/livestockTransfer/transferLivestock",method: "POST",data: FormData.fromMap(
          {
            "token":User.user?.token,
            "farm_id":widget.livestock.farmId,
            "livestock_id":widget.livestock.id,
            "notes":_notesController.text,
            "amount":_amountController.text,
            "receiver":_receiverController.text,
            "type":_type,
          }),onValue: (s,v){
        showSnack(s['message']);
        if(s['code'] == 200) {
          goBack();
        }
      },error: (s,v)=>print(s));
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> loadFarms() {
    return ajax(
        url: "farms/livestockTransfer/transferFarms",
        method: "POST",
        data: FormData.fromMap({"token": User.user?.token,"farm_id":widget.livestock.farmId}),
        onValue: (obj, url) {
          setState(() {
            _farms = (obj['data'] as Iterable?)?.map((e) => Farm.fromJson(e)).toList() ?? [];
            if(_farm == null && _farms.isNotEmpty){
              // loadData();
            }
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Livestock Transfer"),
      ),
      body: Form(
        key: _key,
        child: ListView(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              margin: const EdgeInsets.all(15),
              shadowColor: Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.livestock.tag??"",style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                    Text(widget.livestock.description??"",style: const TextStyle(
                      fontSize: 14,
                    ),),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: DropdownButtonFormField<String>(
                        items: [
                          "My Farms",
                          "Gift",
                          "Pledge",
                          "Sale",
                        ].map((e) => DropdownMenuItem(value: e,child: Text(e),)).toList(),
                        onChanged: (s){
                          setState(() {
                            _type = s;
                          });
                        },
                          value: _type,
                        validator: (s)=>s?.trim().isNotEmpty == true ? null : "Field is required !",
                        decoration: iDecoration(hint: "Receiver")
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: _type == 'My Farms' ? DropdownButtonFormField<Farm>(
                        validator: (s)=>s == null ? "Farm is required !" : null,
                        isExpanded: true,
                        value: _farm,
                        items: _farms
                            .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name),
                        ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _farm = val;
                          });
                        },
                        decoration: const InputDecoration(hintText: "Farm"),
                      ) : TextFormField(
                        validator: validateMobile,
                        controller: _receiverController,
                        decoration: iDecoration(hint: "Receiver")
                      ),
                    ),
                    _type == 'Sale' ? Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: TextFormField(
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          keyboardType: TextInputType.number,
                          validator: (s)=>s?.trim().isNotEmpty == true ? null : "Field is required !",
                          controller: _amountController,
                          decoration: iDecoration(hint: "Amount")
                      ),
                    ) : const SizedBox.shrink(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: TextFormField(minLines: 3,maxLines: null,validator: (s)=>s?.trim().isNotEmpty == true ? null : "Field is required !!!",controller: _notesController,decoration: iDecoration(hint: "Notes"),),
                    ),
                    _loading ? const Center(child: CircularProgressIndicator(),) : ElevatedButton(onPressed: transfer, child: const Text("Send"))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}