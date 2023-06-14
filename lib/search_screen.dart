
import 'package:dio/dio.dart';

import 'json/farm.dart';
import 'json/user.dart';
import 'livestock_list.dart';
import 'super_base.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final String query;

  const SearchScreen({Key? key, required this.query}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends Superbase<SearchScreen> {
  @override
  void didUpdateWidget(covariant SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query && widget.query.isNotEmpty) {
      search();
    }
  }

  bool searching = false;

  List<Farm> _list = [];

  Future<void> search() async {
    setState(() {
      searching = true;
    });
    await ajax(
        url: "farms/search",
        method: "POST",
        data: FormData.fromMap({"query":widget.query,"token":User.user?.token}),
        onValue: (object, url) {
          setState(() {
            searching = false;
            _list = (object['data'] as Iterable?)
                ?.map((e) => Farm.fromJson(e))
                .toList() ?? [];
          });
        });

    setState(() {
      searching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: searching
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: _list.length,
              itemBuilder: (context, index) {
                var farm = _list[index];
                return Card(clipBehavior: Clip.antiAliasWithSaveLayer,color: const Color(0xffD5EAE3),shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),child: InkWell(
                  onTap:(){
                    push(LivestockList(farm: farm));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(farm.name,style: const TextStyle(
                            fontSize: 14
                        ),textAlign: TextAlign.center,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(fmtNbr(farm.livestocks),style: const TextStyle(
                              fontSize: 29,
                              fontWeight: FontWeight.w700
                          ),),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  children: [
                                    const WidgetSpan(child: Icon(Icons.location_on_outlined,size: 15,)),
                                    TextSpan(text: farm.sector)
                                  ]
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),);
              }),
    );
  }
}
