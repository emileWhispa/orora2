import 'package:date_field/date_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:orora2/input_dec.dart';
import 'package:orora2/super_base.dart';

import 'json/category.dart';
import 'json/district.dart';
import 'json/province.dart';
import 'json/sector.dart';
import 'json/user.dart';

class StockActivityScreen extends StatefulWidget{
  const StockActivityScreen({super.key});

  @override
  State<StockActivityScreen> createState() => _StockActivityScreenState();
}

class _StockActivityScreenState extends Superbase<StockActivityScreen> {

  List<Category> _categories = [];
  List<Province> _provinces = [];
  List<District> _districts = [];
  List<Sector> _sectors = [];
  Category? _category;
  Province? _province;
  District? _district;
  Sector? _sector;

  var key = GlobalKey<FormState>();
  var quantityController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadCategories();
      loadProvinces();
    });
    super.initState();
  }

  void loadCategories(){
    ajax(url: "farms/farmCategories",onValue: (s,v){
      setState(() {
        _categories = (s['data'] as Iterable).map((e) => Category.fromJson(e)).toList();
      });
    });
  }

  void loadProvinces(){
    ajax(url: "address/provinces",onValue: (s,v){
      setState(() {
        _province = null;
        _district = null;
        _districts.clear();
        _sector = null;
        _sectors.clear();
        _provinces = (s['data'] as Iterable).map((e) => Province.fromJson(e)).toList();
      });
    });
  }

  void loadDistrict(Province province){
    ajax(url: "address/districts?province_id=${province.id}",onValue: (s,v){
      setState(() {
        _district = null;
        _sector = null;
        _sectors.clear();
        _districts = (s['data'] as Iterable).map((e) => District.fromJson(e)).toList();
      });
    });
  }

  void loadSectors(District district){
    ajax(url: "address/sectors?district_id=${district.id}",onValue: (s,v){
      setState(() {
        _sector = null;
        _sectors = (s['data'] as Iterable).map((e) => Sector.fromJson(e)).toList();
      });
    });
  }

  bool _loading = false;

  void register()async{
    if(key.currentState?.validate()??false){
      setState(() {
        _loading = true;
      });
      await ajax(url: "farms/addFarm",method: "POST",data: FormData.fromMap(
          {
            "token":User.user?.token,
            "farm_name":quantityController.text,
            "category_id":_category?.id,
            "province_id":_province?.id,
            "district_id":_district?.id,
            "sector_id":_sector?.id,
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
        title: const Text("Farm Registration"),
      ),
      body: Form(
        key: key,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownButtonFormField<Category>(validator: (s)=>s == null ? "Feed is required" : null,value: _category,items: _categories.map((e) => DropdownMenuItem(value: e,child: Text(e.name),)).toList(), onChanged: (val){
                setState(() {
                  _category = val;
                });
              },decoration: iDecoration(hint: "Select Feed"),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(controller: quantityController,validator: (s)=>s?.trim().isNotEmpty == true ? null : 'Name is required',decoration: iDecoration(hint: "Quantity kg/L"),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DateTimeFormField(validator: (s)=>s == null ? null : 'Date is required',decoration: iDecoration(hint: "Date"),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(controller: descriptionController,minLines: 4,maxLines: 6,validator: (s)=>s?.trim().isNotEmpty == true ? null : 'Notes is required',decoration: iDecoration(hint: "Notes"),),
            ),
            _loading ? const Center(child: CircularProgressIndicator(),) : ElevatedButton(onPressed: register, child: const Text("Save Information"))
          ],
        ),
      ),
    );
  }
}