import 'package:flutter/material.dart';
import 'package:orora2/json/livestock.dart';

import 'input_dec.dart';

class LivestockTransfer extends StatefulWidget{
  final Livestock livestock;
  const LivestockTransfer({super.key, required this.livestock});

  @override
  State<LivestockTransfer> createState() => _LivestockTransferState();
}

class _LivestockTransferState extends State<LivestockTransfer> {

  final _receiverController = TextEditingController();
  final _notesController = TextEditingController();

  bool _loading = false;
  final _key = GlobalKey<FormState>();

  void transfer(){
    if(_key.currentState?.validate()??false){
      setState(() {
        _loading = true;
      });
    }
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
                      child: TextFormField(
                        validator: (s)=>s?.trim().isNotEmpty == true ? null : "Field is required !",
                        decoration: iDecoration(hint: "Receiver"),controller: _receiverController,),
                    ),
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