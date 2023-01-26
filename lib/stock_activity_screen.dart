import 'package:date_field/date_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:orora2/input_dec.dart';
import 'package:orora2/super_base.dart';

import 'feeds_registration.dart';
import 'json/farm.dart';
import 'json/feed.dart';
import 'json/user.dart';

class StockActivityScreen extends StatefulWidget {
  const StockActivityScreen({super.key});

  @override
  State<StockActivityScreen> createState() => _StockActivityScreenState();
}

class _StockActivityScreenState extends Superbase<StockActivityScreen> {
  List<Feed> _feeds = [];
  List<Farm> _farms = [];
  Feed? _feed;
  DateTime? _date;
  String? _activity;
  Farm? _farm;

  var key = GlobalKey<FormState>();
  var quantityController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadFeeds();
      loadFarms();
    });
    super.initState();
  }

  void loadFeeds({bool reload = false}) {
    ajax(
        url: "feeds/feeds",
        method: "POST",
        data: FormData.fromMap({
          "token": User.user?.token,
        }),
        onValue: (s, v) {
          setState(() {
            _feed = null;
            _feeds =
                (s['data'] as Iterable?)?.map((e) => Feed.fromJson(e)).toList() ?? [];
            if(!reload){
              _feeds.add(Feed(null,id: unique));
            }
          });
        });
  }

  void goToAdd() async {
    await push(const FeedsRegistration());
    loadFeeds(reload: false);
  }

  bool _loading = false;

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

  void register() async {
    if (key.currentState?.validate() ?? false) {
      setState(() {
        _loading = true;
      });
      await ajax(
          url: "feeds/addActivity",
          method: "POST",
          data: FormData.fromMap({
            "token": User.user?.token,
            "farm_name": quantityController.text,
            "farm_id": _farm?.id,
            "feed_id": _feed?.id,
            "quantity": quantityController.text,
            "date": _date?.toString(),
            "notes": descriptionController.text,
            "activity": _activity
          }),
          onValue: (s, v) {
            showSnack(s['message']);
            if (s['code'] == 200) {
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
        title: const Text("Stock Activity"),
      ),
      body: Form(
        key: key,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownButtonFormField<String>(
                validator: (s) => s == null ? "Activity is required" : null,
                value: _activity,
                items: ["In", "Out"]
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _activity = val;
                  });
                },
                decoration: iDecoration(hint: "Select Activity"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownButtonFormField<Feed?>(
                validator: (s) => s == null ? "Feed is required" : null,
                value: _feed,
                items: _feeds
                    .map((e) => DropdownMenuItem<Feed?>(
                          value: e,
                          child: e.name == null
                              ? Row(
                                  children: const [
                                    Icon(Icons.add),
                                    Text("Add New")
                                  ],
                                )
                              : Text(e.name ?? ""),
                        ))
                    .toList(),
                onChanged: (val) {

                  setState(() {
                    _feed = val;
                  });
                  if (val != null && val.name == null) {
                    goToAdd();
                  }
                },
                decoration: iDecoration(hint: "Select Feed"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownButtonFormField<Farm?>(
                validator: (s) => s == null ? "Farm is required" : null,
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
                decoration: iDecoration(hint: "Select Farm"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                controller: quantityController,
                validator: (s) =>
                    s?.trim().isNotEmpty == true ? null : 'Name is required',
                decoration: iDecoration(hint: "Quantity kg/L"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DateTimeFormField(
                validator: (s) => s == null ? 'Date is required' : null,
                initialValue: _date,
                decoration: iDecoration(hint: "Date"),
                mode: DateTimeFieldPickerMode.date,
                onDateSelected: (date) {
                  setState(() {
                    _date = date;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                controller: descriptionController,
                minLines: 4,
                maxLines: 6,
                validator: (s) =>
                    s?.trim().isNotEmpty == true ? null : 'Notes is required',
                decoration: iDecoration(hint: "Notes"),
              ),
            ),
            _loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: register, child: const Text("Save Information"))
          ],
        ),
      ),
    );
  }
}
