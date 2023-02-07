import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orora2/real_crop.dart';
import 'package:orora2/super_base.dart';

import 'json/farm.dart';

class EditProfilePicture extends StatefulWidget{
  final Farm farm;
  const EditProfilePicture({super.key, required this.farm});

  @override
  State<EditProfilePicture> createState() => _EditProfilePictureState();
}

class _EditProfilePictureState extends Superbase<EditProfilePicture> {

  File? _filePro;


  void uploadImagePro() {
    ajax(
        url: "farms/updateProfilePicture",
        data: FormData.fromMap({
          "farm_id": widget.farm.id,
          "profile_picture": MultipartFile.fromFileSync(_filePro!.path)
        }),
        server: true,
        method: "POST",
        onValue: (source, v) async {
          widget.farm.picture = source['farm_profile_picture'];
        },
        error: (s, v) {},
        onEnd: () {
          Navigator.maybePop(context);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Stack(
              children: [
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      image: DecorationImage(
                          image: (_filePro != null
                              ? FileImage(_filePro!)
                              : CachedNetworkImageProvider(
                              widget.farm.picture ??
                                  "")) as ImageProvider,
                          fit: BoxFit.cover),
                      shape: BoxShape.circle),
                ),
                Positioned(
                    right: 0,
                    bottom: 0,
                    child: SizedBox(
                      height: 35,
                      width: 35,
                      child: FloatingActionButton(
                        onPressed: () async {
                          var x = await showDialog<int>(context: context, builder: (context){
                            return AlertDialog(
                              shape: const RoundedRectangleBorder(),
                              title: const Text("Select Image Source"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // ListTile(
                                  //   leading: Icon(Icons.camera_alt),
                                  //   onTap: (){
                                  //     Navigator.pop(context,0);
                                  //   },
                                  //   title: Text("Camera"),
                                  // ),
                                  ListTile(
                                    leading: const Icon(Icons.photo),
                                    onTap: (){
                                      Navigator.pop(context,1);
                                    },
                                    title: const Text("Gallery"),
                                  ),
                                ],
                              ),
                            );
                          });

                          if(x == null) return;

                          final file = await ImagePicker().pickImage(source: x == 1 ? ImageSource.gallery : ImageSource.camera);


                          if (file != null && mounted) {
                            _filePro = File(file.path);
                            _filePro = await Navigator.push<File>(
                                context,
                                CupertinoPageRoute(
                                    builder: (ctx) =>
                                        RealCrop(
                                            square: true,
                                            file: _filePro!),
                                    fullscreenDialog: true));
                            setState(() {});
                            if( _filePro != null && mounted) {
                              uploadImagePro();
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) =>
                                      AlertDialog(
                                        content: Column(
                                          mainAxisSize:
                                          MainAxisSize.min,
                                          children: const [
                                            Padding(
                                              padding:
                                              EdgeInsets
                                                  .all(3.0),
                                              child:
                                              CircularProgressIndicator(),
                                            ),
                                          ],
                                        ),
                                      ));
                            }
                          } else {
                            return;
                          }
                        },
                        elevation: 1.5,
                        heroTag: "hero-edit-profile",
                        child: const Icon(
                          Icons.camera_alt,
                          size: 17,
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}