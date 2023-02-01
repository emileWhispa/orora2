import 'package:date_field/date_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orora2/json/farm.dart';
import 'package:orora2/super_base.dart';

import 'input_dec.dart';
import 'json/livestock.dart';
import 'json/user.dart';

class CreateFarmProduction extends StatefulWidget {
  final Farm farm;

  const CreateFarmProduction({super.key, required this.farm});

  @override
  State<CreateFarmProduction> createState() => _CreateFarmProductionState();
}

class _CreateFarmProductionState extends Superbase<CreateFarmProduction> {
  final _key = GlobalKey<FormState>();

  bool _saving = false;
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _dateTime = DateTime.now();
  Livestock? _livestock;
  List<Livestock> _livestocks = [];
  String? _category;

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
    super.initState();
  }

  Future<void> loadData() {
    return ajax(
        url: "farms/myLivestocks",
        method: "POST",
        data: FormData.fromMap({
          "token": User.user?.token,
          "farm_id": widget.farm.id,
        }),
        onValue: (obj, url) {
          setState(() {
            _livestocks = (obj['data'] as Iterable?)
                    ?.map((e) => Livestock.fromJson(e))
                    .toList() ??
                [];
          });
        });
  }

  void saveForm() async {
    if (_key.currentState?.validate() ?? false) {
      setState(() {
        _saving = true;
      });
      await ajax(
          url: "production/addProduction",
          method: "POST",
          data: FormData.fromMap({
            "token": User.user?.token,
            "livestock_id": _livestock?.id,
            "date": _dateTime?.toString(),
            "quantity": _quantityController.text,
            "notes": _notesController.text,
            "category":_category
          }),
          onValue: (obj, url) {
            showSnack(obj['message']);
            if (obj['code'] == 200) {
              Navigator.pop(context, obj);
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
        title: Text(widget.farm.name),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: DropdownButtonFormField<Livestock>(
                validator: (s) => s == null ? "Livestock is required !" : null,
                isExpanded: true,
                value: _livestock,
                items: _livestocks
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.tag ?? ""),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _livestock = val;
                  });
                },
                decoration: const InputDecoration(hintText: "Livestock"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownButtonFormField<String>(
                validator: (s) => s?.trim().isNotEmpty == true
                    ? null
                    : "Field is required !!!",
                value: _category,
                items: ["Milk", "Meat","Reproduction"]
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _category = val;
                  });
                },
                decoration: iDecoration(hint: "Category"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                validator: (s) =>
                    s?.trim().isNotEmpty == true ? null : "Weight is required",
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(hintText: "Quantity Kg/L"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: DateTimeFormField(
                mode: DateTimeFieldPickerMode.date,
                initialValue: _dateTime,
                validator: (s) => s == null ? "Date is required !" : null,
                onDateSelected: (s) {
                  setState(() {
                    _dateTime = s;
                  });
                },
                decoration: const InputDecoration(hintText: "Date"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                minLines: 4,
                maxLines: 5,
                controller: _notesController,
                decoration: const InputDecoration(hintText: "Notes"),
              ),
            ),
            _saving
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: saveForm, child: const Text("Record Production"))
          ],
        ),
      ),
    );
  }
}
