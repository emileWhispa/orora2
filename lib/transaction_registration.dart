import 'package:date_field/date_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orora2/super_base.dart';

import 'input_dec.dart';
import 'json/farm.dart';
import 'json/trans_category.dart';
import 'json/transaction.dart';
import 'json/user.dart';

class TransactionRegistration extends StatefulWidget {
  final Transaction? transaction;

  const TransactionRegistration({super.key, this.transaction});

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

  var mains = ["expenditure", "income"];

  @override
  void initState() {
    if (widget.transaction != null) {
      _amountController.text = widget.transaction!.amount?.toString() ?? "";
      _nameController.text = widget.transaction!.name ?? "";
      _notesController.text = widget.transaction!.notes ?? "";
      _dateTime = DateTime.tryParse(widget.transaction!.date);
      if(mains.contains(widget.transaction!.type)){
        _mainCategory = widget.transaction!.type!;
        loadData(_mainCategory!,initState: true);
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadFarms(initState: true);
    });
    super.initState();
  }

  Future<void> loadFarms({bool initState = false}) {
    return ajax(
        url: "farms/myFarms",
        method: "POST",
        data: FormData.fromMap({"token": User.user?.token}),
        onValue: (obj, url) {
          setState(() {
            _farms =
                (obj['data'] as Iterable).map((e) => Farm.fromJson(e)).toList();
            if(initState && widget.transaction != null){
              var iterable = _farms.where((element) => element.id == widget.transaction!.farmId);
              if(iterable.isNotEmpty){
                _farm = iterable.first;
              }
            }
          });
        });
  }

  Future<void> loadData(String category,{bool initState = false}) {
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
            if(initState && widget.transaction != null){
              var iterable = _categories.where((element) => element.id == widget.transaction!.categoryId);
              if(iterable.isNotEmpty){
                _category = iterable.first;
              }
            }
          });
        });
  }

  bool _saving = false;
  DateTime? _dateTime;
  final _key = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();

  void saveTransaction() async {
    if (_key.currentState?.validate() ?? false) {
      setState(() {
        _saving = true;
      });
      await ajax(
          url: widget.transaction != null ? "finance/editTransaction" : "finance/addTransaction",
          method: "POST",
          data: FormData.fromMap({
            "token": User.user?.token,
            "farm_id": _farm?.id,
            "category_id": _category?.id,
            "transaction_id":widget.transaction?.id,
            "date": _dateTime?.toString(),
            "amount": _amountController.text,
            "name": _nameController.text,
            "notes": _notesController.text,
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
        title: Text(widget.transaction != null
            ? "Edit Transaction"
            : "Add Transaction"),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownButtonFormField<Farm>(
                validator: (s) => s == null ? "Farm is required !" : null,
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
                validator: (s) => s == null ? "Date is required !" : null,
                mode: DateTimeFieldPickerMode.date,
                initialValue: _dateTime,
                decoration: iDecoration(hint: "Date"),
                onDateSelected: (date) {
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
                validator: (s) =>
                    s?.trim().isNotEmpty == true ? null : "Name is required",
                decoration: iDecoration(hint: "Transaction Name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownButtonFormField<String>(
                validator: (s) => s?.trim().isNotEmpty == true
                    ? null
                    : "Category is required",
                value: _mainCategory,
                items: mains
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
                validator: (s) => s == null ? "Category is required !" : null,
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
                  validator: (s) => s?.trim().isNotEmpty == true
                      ? null
                      : "Transaction Amount is required !!!",
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: iDecoration(hint: "Transaction Amount"),
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: _notesController,
                minLines: 4,
                maxLines: 5,
                decoration: const InputDecoration(hintText: "Notes"),
              ),
            ),
            _saving
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: saveTransaction,
                    child: Text(
                        widget.transaction != null ? "Update" : "Register"))
          ],
        ),
      ),
    );
  }
}
