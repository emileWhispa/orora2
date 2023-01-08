import 'package:date_field/date_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orora2/super_base.dart';

import 'input_dec.dart';
import 'json/farm.dart';
import 'json/trans_category.dart';
import 'json/user.dart';

class TransactionRegistration extends StatefulWidget {
  const TransactionRegistration({super.key});

  @override
  State<TransactionRegistration> createState() =>
      _TransactionRegistrationState();
}

class _TransactionRegistrationState extends Superbase<TransactionRegistration> {
  String? _mainCategory;
  TransCategory? _category;

  List<TransCategory> _categories = [];

  List<Farm> _farms = [];
  Farm? _farm;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadFarms();
    });
    super.initState();
  }

  Future<void> loadFarms() {
    return ajax(
        url: "farms/myFarms",
        method: "POST",
        data: FormData.fromMap({"token": User.user?.token}),
        onValue: (obj, url) {
          setState(() {
            _farms =
                (obj['data'] as Iterable).map((e) => Farm.fromJson(e)).toList();
          });
        });
  }

  Future<void> loadData(String category) {
    return ajax(
        url: "finance/transaction_categories.php?transaction_type=$category",
        method: "POST",
        data: FormData.fromMap({
          "token": User.user?.token,
        }),
        onValue: (obj, url) {
          setState(() {
            _category = null;
            _categories = (obj['data'] as Iterable?)
                    ?.map((e) => TransCategory.fromJson(e))
                    .toList() ??
                [];
          });
        });
  }

  bool _saving = false;
  DateTime? _dateTime;
  final _key = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();

  void saveTransaction()async{
    if(_key.currentState?.validate()??false){
      setState(() {
        _saving = true;
      });
      await ajax(url: "finance/addTransaction",method: "POST",data: FormData.fromMap(
          {
            "token": User.user?.token,
            "farm_id":_farm?.id,
            "category_id":_category?.id,
            "date":_dateTime?.toString(),
          "amount":_amountController.text,
          "name":_nameController.text,
          "notes":_notesController.text,
          }),
        onValue: (obj,url){
        showSnack(obj['message']);
        if(obj['code'] == 200){
          Navigator.pop(context,obj);
        }
        }
      );
      setState(() {
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownButtonFormField<Farm>(
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
                decoration: iDecoration(hint: "Farm"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DateTimeFormField(
                validator: (s)=>s == null ? "Date is required !" : null,
                mode: DateTimeFieldPickerMode.date,
                decoration: iDecoration(hint: "Date"),
                onDateSelected: (date){
                  setState(() {
                    _dateTime = date;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                controller: _nameController,
                validator: (s)=>s?.trim().isNotEmpty == true ? null : "Name is required",
                decoration: iDecoration(hint: "Transaction Name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownButtonFormField<String>(
                validator: (s)=>s?.trim().isNotEmpty == true ? null : "Category is required",
                value: _mainCategory,
                items: ["expenditure", "income"]
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _mainCategory = val;
                    loadData(val!);
                  });
                },
                decoration: iDecoration(hint: "Category"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownButtonFormField<TransCategory>(
                validator: (s)=>s == null ? "Category is required !" : null,
                isExpanded: true,
                value: _category,
                items: _categories
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _category = val;
                  });
                },
                decoration: iDecoration(hint: "Sub Category"),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  validator: (s)=>s?.trim().isNotEmpty == true ? null : "Transaction Amount is required !!!",
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: iDecoration(hint: "Transaction Amount"),
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: _notesController,
                minLines: 4,
                maxLines: 5,
                decoration: const InputDecoration(
                    hintText: "Notes"
                ),
              ),
            ),
            _saving ? const Center(
              child: CircularProgressIndicator(),
            ) : ElevatedButton(onPressed: saveTransaction, child: const Text("Register"))
          ],
        ),
      ),
    );
  }
}
