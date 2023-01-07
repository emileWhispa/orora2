import 'package:flutter/material.dart';

import 'json/livestock.dart';

class CreateFarmProduction extends StatefulWidget{
  final Livestock livestock;
  const CreateFarmProduction({super.key, required this.livestock});

  @override
  State<CreateFarmProduction> createState() => _CreateFarmProductionState();
}

class _CreateFarmProductionState extends State<CreateFarmProduction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("#${widget.livestock.tag??""}"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: "Weight Kg"
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: "Date"
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: TextFormField(
              minLines: 4,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Notes"
              ),
            ),
          ),
          ElevatedButton(onPressed: (){}, child: const Text("Record Production"))
        ],
      ),
    );
  }
}