import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'json/user.dart';
import 'main.dart';
import 'reg_ex_input_formatter.dart';
import 'stateful_builder_2.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.parse(newValue.text);

    final formatter = NumberFormat.simpleCurrency(locale: "pt_Br");

    String newText = formatter.format(value / 100);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}

@optionalTypeArgs
abstract class Superbase<T extends StatefulWidget> extends State<T> {
  String get bigBase => "https://www.orora.rw/api/";

  String token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbkBjcGFpLnRlY2giLCJleHAiOjE2MDEyMTIzODF9.Lw8Acj_ldP4AakcucN3zKM7I1kTEqKTQc70VdfTga827oz1afKP9Gv54veYBVE0a4PEwN7jPt0xqefV_VsIMyg";

  String get server => bigBase;

  String userKey = "user-key-val";


  final formatter = NumberFormat.compact();

  static String? country;
  static String? tokenValue;

  Color appGrey = const Color(0xff2d2d37);

  DateTime get utc => DateTime.now().toUtc();

  String get unique =>
      "${utc.millisecondsSinceEpoch}${const Uuid().v4().replaceAll("-", "")}";

  List<MaterialColor> get colors =>
      Colors.primaries.where((element) => element != Colors.yellow).toList();

  String url(String url) => "$server$url";

  Future<void> save(String key, dynamic val) {
    return saveVal(key, jsonEncode(val));
  }

  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  RegExp emailExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  RegExp disableSpecial = RegExp(r"[^.@a-zA-Z0-9]");
  RegExp phoneExp = RegExp(r'^(?:[+0]9)?[0-9]{10}$');
  final amountValidator = RegExInputFormatter.withRegex(
      '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');

  var platform = const MethodChannel('app.channel.shared.data');

  RegExp reg0 = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

  Future<void> saveVal(String key, String value) async {
    (await prefs).setString(key, value);
    return Future.value();
  }

  String fmtDate(DateTime? date) {
    if (date == null) return "";

    return DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
  }



  void refresh(User? user) {
    setState(() {
      User.user = user;
    });
  }

  bool get loggedOut => User.user == null;

  String? validateMobile(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{8,14}$)';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return "Phone number can not be empty";
    } else if (!regExp.hasMatch(value)) {
      return "Please input a valid phone number";
    } else {
      return null;
    }
  }

  void logOut()async{
    (await prefs).clear();
    User.user = null;
    push(const MyHomePage(title: "title"),replaceAll: true);
  }

  String? validateEmail(String? value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    if (value == null || value.isEmpty) {
      return "Email can not be empty";
    } else {
      if (!regex.hasMatch(value)) {
        return "Enter a valid email.";
      }
      {
        final bool isValid = EmailValidator.validate(value);
        if (isValid) {
          return null;
        } else {
          return "Enter a valid email.";
        }
      }
    }
  }

  String fmtDate2(DateTime? date) {
    if (date == null) return "";

    return DateFormat("yyyy-MM-dd").format(date);
  }

  String googleAPIKey = "AIzaSyAgU_8Z_hG2iWAL6K9QDdqdmes_YjFSK3s";

  String fmt(String test) {
    return test.replaceAllMapped(reg, (Match match) => '${match[1]},');
  }

  String fmtNbr(num? test) {

    if(test == null){
      return "";
    }

    return fmt(test.toInt().toString());
  }

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  Future<String> get localPath async =>
      (await getApplicationDocumentsDirectory()).path;

  Future<File> localFile(String name) async {
    final path = await localPath;
    return File('$path/$name');
  }


  Future<bool> confirmDialog(BuildContext context,
      {String title = "Confirm", String body = "Are you sure ?"}) async {
    bool? b = await showDialog<bool?>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text("CANCEL")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text("OK")),
            ],
          );
        });

    return b == true;
  }

  Widget loadBox(
      {Color? color,
      Color? bColor,
      double size = 20,
      double? value,
      double width = 3}) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        backgroundColor: bColor,
        strokeWidth: width,
        value: value,
        valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).primaryColor),
      ),
    );
  }

  bool canDecode(String jsonString) {
    var decodeSucceeded = false;
    try {
      json.decode(jsonString);
      decodeSucceeded = true;
    } on FormatException catch (_) {}
    return decodeSucceeded;
  }

  Future<void> ajax(
      {required String url,
      String method = "GET",
      FormData? data,
      Map<String, dynamic>? map,
      bool server = true,
      bool auth = true,
      bool local = false,
      bool base2 = false,
      String? authKey,
      bool json = true,
      void Function(CancelToken token)? onCancelToken,
      bool absolutePath = false,
      ResponseType responseType = ResponseType.json,
      bool localSave = false,
      String? jsonData,
      void Function(dynamic response, String url)? onValue,
      void Function()? onEnd,
      void Function(dynamic response, String url)? error}) async {
    url = absolutePath ? url : this.url(url);

    Map<String, String> headers = <String, String>{};
    headers['country'] = country ?? "";
    headers["Accept"] = "application/json";

    var prf = await prefs;
    var tkn = prf.getString("token");
    if (auth && (authKey != null || tkn != null || tokenValue != null)) {
      headers['Authorization'] = 'Bearer ${authKey ?? tokenValue ?? tkn}';
    }

    Options opt = Options(
        responseType: responseType,
        headers: headers,
        contentType: ContentType.json.value,
        receiveDataWhenStatusError: true,
        sendTimeout: 30000,
        receiveTimeout: 30000);

    if (!server) {
      String? val = prf.getString(url);
      bool t = onValue != null && val != null;
      local = local && t;
      localSave = localSave && t;
      var c = (t && json && canDecode(val)) || !json;
      t = t && c;
      if (t) onValue(json ? jsonDecode(val) : val, url);
    }

    if (local) {
      if (onEnd != null) onEnd();
      return Future.value();
    }

    CancelToken token = CancelToken();

    if (onCancelToken != null) {
      onCancelToken(token);
    }

    Future<Response> future = method.toUpperCase() == "POST"
        ? Dio().post(url,
            data: jsonData ?? map ?? data, options: opt, cancelToken: token)
        : method.toUpperCase() == "PUT"
            ? Dio().put(url,
                data: jsonData ?? map ?? data, options: opt, cancelToken: token)
            : method.toUpperCase() == "DELETE"
                ? Dio().delete(url,
                    data: jsonData ?? map ?? data,
                    options: opt,
                    cancelToken: token)
                : Dio().get(url, options: opt, cancelToken: token);

    try {
      Response response = await future;
      dynamic data = response.data;


      if (response.statusCode == 401) {
        if (onEnd != null) onEnd();
        showSnack("Login First");
        return Future.value();
      } else if (response.statusCode == 200) {
        //var cond = (data is String && json && canDecode(data)) || !json;
        if (!server && ((data is String && canDecode(data)) || data is Map)) {
          saveVal(url, jsonEncode(data));
        }

        if (onValue != null && !localSave) {
          onValue(data, url);
        } else if (error != null) {
          error(data, url);
        }
      } else if (error != null) {
        error(data, url);
      }
    } on DioError catch (e) {
      //if (e.response != null) {
      var resp = e.response != null ? e.response!.data : e.message;
      if (error != null) error(resp, url);

      if (e.response?.statusCode == 401 && User.user != null) {
        if (onEnd != null) onEnd();
        showSnack("Login First");
        return Future.value();
      }
      //}
    }

    if (onEnd != null) onEnd();
    return Future.value();
  }

  Widget frameBuilder(
      BuildContext context, Widget child, int? frame, bool was) {
    return frame == null
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(),
            ),
          )
        : child;
  }


  final _key = GlobalKey<StatefulBuilderState2>();

  void closeMd() {
    _key.currentState?.pop();
  }

  Future<void> showMd({BuildContext? context}) async {
    //Timer(Duration(seconds: 8), ()=>this.canPop());
    await showGeneralDialog(
        transitionDuration: const Duration(seconds: 1),
        barrierDismissible: false,
        context: context ?? this.context,
        barrierColor: Colors.black12,
        pageBuilder: (context, _, __) {
          return StatefulBuilder2(
              key: _key,
              builder: (context, StateSetter setState) {
                return AlertDialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  content: Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(7)),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Loading...",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        });

    return Future.value();
  }

  Future<G?> push<G>(Widget widget,
      {BuildContext? context,bool replace = false,
      bool replaceAll = false,
      bool replaceAllExceptOne = false}) async {
    var pageRoute = CupertinoPageRoute<G>(builder: (context) => widget);

    context = context ?? this.context;
    var navigatorState = Navigator.of(context);

    if (replace) {
      return await navigatorState.pushReplacement(pageRoute);
    } else {
      if (replaceAll) {
        navigatorState.popUntil((route) => route.isFirst);
        return await navigatorState.pushReplacement(pageRoute);
      }

      if (replaceAllExceptOne) {
        // navigatorState.popUntil((route) => route.isFirst);
        return await navigatorState.pushAndRemoveUntil(pageRoute,(route)=>route.isFirst);
      }

      return await navigatorState.push<G>(pageRoute);
    }
  }

  void goBack() {
    Navigator.pop(context);
  }

  void showSnack(String text,{BuildContext? context}) {
    ScaffoldMessenger.of(context ?? this.context).showSnackBar(SnackBar(content: Text(text)));
  }

  String get defAddress => "default-address-key";

}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
