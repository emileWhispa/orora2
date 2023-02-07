import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_crop/image_crop.dart';
import 'package:orora2/super_base.dart';


class RealCrop extends StatefulWidget {
  final File file;
  final bool square;

  const RealCrop(
      {Key? key, required this.file, this.square= false})
      : super(key: key);

  @override
  State<RealCrop> createState() => _RealCropState();
}

class _RealCropState extends Superbase<RealCrop>  {
  final GlobalKey<CropState> _cropKey = GlobalKey<CropState>();
  bool _cropping = false;
  bool _phone = false;

  File? _file;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      localFile(unique).then((value){
        setState(() {
          _file = widget.file.copySync(value.path);
        });
      });
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(_phone ? Icons.phonelink_erase : Icons.phone_android),
            onPressed: () {
              setState(() {
                _phone = !_phone;
              });
            },
            tooltip: "Crop due to screen size",
          ),
          _cropping
              ? IconButton(
                  icon: loadBox(
                      color:
                          Theme.of(context).primaryTextTheme.titleLarge?.color),
                  onPressed: null)
              : TextButton(
                  // textColor: widget.object.getFont,
                  onPressed: () async {
                    setState(() {
                      _cropping = true;
                    });

                    var crop = _cropKey.currentState!;

                    final sampledFile = await ImageCrop.sampleImage(
                      file: _file!,
                      preferredWidth: (1024 / crop.scale).round(),
                      preferredHeight: (4096 / crop.scale).round(),
                    );

                    final croppedFile = await ImageCrop.cropImage(
                      file: sampledFile,
                      area: crop.area!,
                    );

                    _file?.deleteSync();
if(mounted) {
  Navigator.of(context).pop(croppedFile);
}
                  },
                  child: Text(
                    "Crop",
                    style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.titleLarge?.color),
                  ))
        ],
      ),
      body: FutureBuilder<int>(
          future: Future.delayed(const Duration(seconds: 2), () => 7),
          builder: (context, data) {
            if (data.hasData && _file != null) {
              return Crop(
                key: _cropKey,
                image: FileImage(_file!),
                alwaysShowGrid: true,
                aspectRatio: widget.square
                    ? 4.0 / 4.0
                    : _phone
                        ? size.width / size.height
                        : null,
              );
            }

            return const Center(child: CupertinoActivityIndicator());
          }),
    );
  }
}
