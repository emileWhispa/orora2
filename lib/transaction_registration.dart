import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'input_dec.dart';

class TransactionRegistration extends StatefulWidget{
  const TransactionRegistration({super.key});

  @override
  State<TransactionRegistration> createState() => _TransactionRegistrationState();
}

class _TransactionRegistrationState extends State<TransactionRegistration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: TextFormField(decoration: iDecoration(hint: "Transaction Name"),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: DropdownButtonFormField<String>(items: ["Category 1","Category 2"].map((e) => DropdownMenuItem(value: e,child: Text(e),)).toList(), onChanged: (val){

            },decoration: iDecoration(hint: "Category"),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: DropdownButtonFormField<String>(items: ["Sub 1","Sub 2"].map((e) => DropdownMenuItem(value: e,child: Text(e),)).toList(), onChanged: (val){

            },decoration: iDecoration(hint: "Sub Category"),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: TextFormField(
              keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: iDecoration(hint: "Transaction Amount"),
            )),
          ElevatedButton(onPressed: (){}, child: const Text("Register"))
        ],
      ),
    );
  }
}