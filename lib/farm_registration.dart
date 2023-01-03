import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:orora2/input_dec.dart';
import 'package:orora2/super_base.dart';

import 'json/category.dart';
import 'json/district.dart';
import 'json/province.dart';
import 'json/sector.dart';
import 'json/user.dart';

class FarmRegistration extends StatefulWidget{
  const FarmRegistration({super.key});

  @override
  State<FarmRegistration> createState() => _FarmRegistrationState();
}

class _FarmRegistrationState extends Superbase<FarmRegistration> {

  List<Category> _categories = [];
  List<Province> _provinces = [];
  List<District> _districts = [];
  List<Sector> _sectors = [];
  Category? _category;
  Province? _province;
  District? _district;
  Sector? _sector;

  var key = GlobalKey<FormState>();
  var nameController = TextEditingController();

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
            "farm_name":nameController.text,
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
              child: TextFormField(controller: nameController,validator: (s)=>s?.trim().isNotEmpty == true ? null : 'Name is required',decoration: iDecoration(hint: "Farm name"),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownButtonFormField<Category>(validator: (s)=>s == null ? "Category is required" : null,value: _category,items: _categories.map((e) => DropdownMenuItem(value: e,child: Text(e.name),)).toList(), onChanged: (val){
                setState(() {
                  _category = val;
                });
              },decoration: iDecoration(hint: "Category"),),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text("Address"),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownButtonFormField<Province>(validator: (s)=>s == null ? "Province is required" : null,value: _province,items: _provinces.map((e) => DropdownMenuItem(value: e,child: Text(e.name),)).toList(), onChanged: (val){
                setState(() {
                  _province = val;
                  loadDistrict(val!);
                });
              },decoration: iDecoration(hint: "Province"),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownButtonFormField<District>(validator: (s)=>s == null ? "District is required" : null,value: _district,items: _districts.map((e) => DropdownMenuItem(value: e,child: Text(e.name),)).toList(), onChanged: (val){
                setState(() {
                  _district = val;
                  loadSectors(val!);
                });
              },decoration: iDecoration(hint: "District"),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownButtonFormField<Sector>(validator: (s)=>s == null ? "Sector is required" : null,value: _sector,items: _sectors.map((e) => DropdownMenuItem(value: e,child: Text(e.name),)).toList(), onChanged: (val){
                setState(() {
                  _sector = val;
                });
              },decoration: iDecoration(hint: "Sector"),),
            ),
            _loading ? const Center(child: CircularProgressIndicator(),) : ElevatedButton(onPressed: register, child: const Text("Register"))
          ],
        ),
      ),
    );
  }
}