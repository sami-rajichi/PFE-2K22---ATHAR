import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monumento/components/admin_dashboard/monuments/manage_monuments.dart';
import 'package:monumento/components/admin_dashboard/monuments/monument_page.dart';
import 'package:monumento/components/profile/specific_monument.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/models/monuments.dart';
import 'package:monumento/network/firebaseServices.dart';
import 'package:reactive_dropdown_search/reactive_dropdown_search.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:shimmer/shimmer.dart';

class UpdateMonument extends StatefulWidget {
  final String? name;
  final String? info;
  final String? location;
  final String? image;
  final String? region;
  final String? model;
  final String? url;
  const UpdateMonument(
      {Key? key,
      this.name,
      this.info,
      this.location,
      this.image,
      this.region,
      this.model,
      this.url})
      : super(key: key);

  @override
  State<UpdateMonument> createState() => _UpdateMonumentState();
}

class _UpdateMonumentState extends State<UpdateMonument> {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  FirebaseServices firebaseServices = new FirebaseServices();
  bool loading = false;
  bool isError = false;
  bool isError2 = false;
  bool isError3 = false;
  bool isError5 = false;
  bool isError6 = false;
  bool isError7 = false;
  bool isError8 = false;
  String image = '';
  String model = '';
  String oImage = '';
  String oModel = '';
  String oName = '';
  String region = '';
  bool fromCloud = false;
  bool fromCloud2 = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      nameController.text = widget.name!;
      locationController.text = widget.location!;
      descController.text = widget.info!;
      urlController.text = widget.url!;
      image = widget.image!;
      model = widget.model!;
      region = widget.region!;
      oImage = widget.image!;
      oName = widget.name!;
      oModel = widget.model!;
    });
    nameController.addListener(() {
      setState(() {});
    });
    locationController.addListener(() {
      setState(() {});
    });
    descController.addListener(() {
      setState(() {});
    });
    urlController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    descController.dispose();
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: size.height * 0.83,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
              child: _form(),
            ),
          ),
          Positioned(
            top: -50,
            child: Column(
              children: [
                InkWell(
                    onTap: () {
                      pickImage();
                    },
                    child: fromCloud
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[400]!,
                            highlightColor: Colors.grey[200]!,
                            child: CircleAvatar(
                              radius: 45,
                            ),
                          )
                        : image.isEmpty
                            ? CircleAvatar(
                                backgroundColor: AppColors.mainColor,
                                radius: 45,
                                child: Icon(Icons.add_photo_alternate,
                                    size: 35, color: Colors.white))
                            : CircleAvatar(
                                radius: 45, backgroundImage: getImage())),
                Visibility(
                  visible: isError8,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Transform.translate(
                        offset: Offset(0, 0),
                        child: Text(
                          '*Required',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.red,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _form() {
    final size = MediaQuery.of(context).size;
    return ListView(
      children: [
        SizedBox(
          height: isError8 ? 10 : 0,
        ),
        richText(20),
        SizedBox(
          height: isError8 ? 10 : 20,
        ),
        Column(
          children: [
            TextField(
              controller: nameController,
              onChanged: (String? nv) {
                setState(() {
                  isError = false;
                });
              },
              style: GoogleFonts.inter(
                fontSize: 12.0,
                color: const Color(0xFF151624),
              ),
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  hintText: 'Monument\'s name',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 12.0,
                    color: const Color(0xFF151624).withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: nameController.text.isEmpty
                      ? Colors.grey[200]
                      : Colors.transparent,
                  helperText: '',
                  helperStyle: TextStyle(height: 0.7),
                  errorStyle: TextStyle(height: 0.7),
                  suffixIcon: IconButton(
                      onPressed: () {
                        nameController.clear();
                      },
                      icon: Icon(
                        Icons.close,
                        size: 16,
                      ))),
            ),
            Transform.translate(
              offset: Offset(0, -14),
              child: Visibility(
                visible: isError,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      '*Required',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.withOpacity(.95),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: isError ? 0 : 8,
            ),
            TextField(
              controller: locationController,
              onChanged: (String? nv) {
                setState(() {
                  isError2 = false;
                });
              },
              style: GoogleFonts.inter(
                fontSize: 12.0,
                color: const Color(0xFF151624),
              ),
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  hintText: 'Enter location',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 12.0,
                    color: const Color(0xFF151624).withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: locationController.text.isEmpty
                      ? Colors.grey[200]
                      : Colors.transparent,
                  helperText: '',
                  helperStyle: TextStyle(height: 0.7),
                  errorStyle: TextStyle(height: 0.7),
                  suffixIcon: IconButton(
                      onPressed: () {
                        locationController.clear();
                      },
                      icon: Icon(
                        Icons.close,
                        size: 16,
                      ))),
            ),
            Transform.translate(
              offset: Offset(0, -14),
              child: Visibility(
                visible: isError2,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 4),
                    child: Text(
                      '*Required',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.withOpacity(.95),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: isError2 ? 0 : 8,
            ),
            DropdownSearch<String>(
              items: [
                "north",
                "central",
                "sud",
              ],
              selectedItem: widget.region,
              dropdownSearchDecoration: InputDecoration(
                hintText: "Select a region",
                hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: const Color(0xFF151624).withOpacity(0.5),
                ),
                filled: true,
                fillColor:
                    region.isEmpty ? Colors.grey[200] : Colors.transparent,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              popupProps: const PopupProps.menu(
                fit: FlexFit.loose,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
              onChanged: (String? item) {
                setState(() {
                  region = item!;
                  print(region);
                  isError3 = false;
                });
              },
            ),
            Visibility(
              visible: isError3,
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 4),
                  child: Text(
                    '*Required',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.withOpacity(.95),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: isError3 ? 14 : 22,
            ),
            TextField(
              controller: descController,
              onChanged: (String? nv) {
                setState(() {
                  isError5 = false;
                });
              },
              style: GoogleFonts.inter(
                fontSize: 12.0,
                color: const Color(0xFF151624),
              ),
              maxLines: 4,
              maxLength: 500,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  hintText: 'Enter monument\'s info',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 12.0,
                    color: const Color(0xFF151624).withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: descController.text.isEmpty
                      ? Colors.grey[200]
                      : Colors.transparent,
                  helperText: '',
                  helperStyle: TextStyle(height: 0.7),
                  errorStyle: TextStyle(height: 0.7),
                  suffixIcon: IconButton(
                      onPressed: () {
                        descController.clear();
                      },
                      icon: Icon(
                        Icons.close,
                        size: 16,
                      ))),
            ),
            Transform.translate(
              offset: Offset(0, -14),
              child: Visibility(
                visible: isError5,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 4),
                    child: Text(
                      '*Required',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.withOpacity(.95),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: isError5 ? 0 : 8,
            ),
            fromCloud2
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[400]!,
                    highlightColor: Colors.grey[200]!,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, size.height / 17),
                          // primary: Color(0xFF21899C),
                          primary: AppColors.backgroundColor.withOpacity(.5),
                          elevation: 2),
                      onPressed: () {},
                      child: Text('The Model is loading...',
                          style: GoogleFonts.inter(
                            fontSize: 14.0,
                            color: AppColors.bigTextColor,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          )),
                    ),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, size.height / 17),
                        // primary: Color(0xFF21899C),
                        primary: AppColors.backgroundColor.withOpacity(.5),
                        elevation: 2),
                    onPressed: () {
                      pickModel();
                    },
                    child: Text('Pick Monument\'s 3D Model',
                        style: GoogleFonts.inter(
                          fontSize: 14.0,
                          color: AppColors.bigTextColor,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        )),
                  ),
            Visibility(
              visible: isError6,
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Transform.translate(
                    offset: Offset(0, 5),
                    child: Text(
                      '*Required',
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: model != '',
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Transform.translate(
                    offset: Offset(0, 5),
                    child: Text(
                      'Model is uploaded',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.bigTextColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: isError6 ? 14 : 28,
            ),
            TextField(
              controller: urlController,
              onChanged: (String? nv) {
                setState(() {
                  isError7 = false;
                });
              },
              style: GoogleFonts.inter(
                fontSize: 12.0,
                color: const Color(0xFF151624),
              ),
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  hintText: 'Documentation URL',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 12.0,
                    color: const Color(0xFF151624).withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: urlController.text.isEmpty
                      ? Colors.grey[200]
                      : Colors.transparent,
                  helperText: '',
                  helperStyle: TextStyle(height: 0.7),
                  errorStyle: TextStyle(height: 0.7),
                  suffixIcon: IconButton(
                      onPressed: () {
                        urlController.clear();
                      },
                      icon: Icon(
                        Icons.close,
                        size: 16,
                      ))),
            ),
            Transform.translate(
              offset: Offset(0, -14),
              child: Visibility(
                visible: isError7,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      '*Required',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.withOpacity(.95),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: isError7 ? 0 : 12,
            ),
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black45),
                            padding: EdgeInsets.symmetric(
                                horizontal: 1, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            primary: Colors.grey[600],
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ManageMonuments(region: region))
                            );
                          },
                          child: Text('GO BACK',
                              style: GoogleFonts.inter(
                                fontSize: 15.0,
                                color: AppColors.bigTextColor,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            primary: AppColors.mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            validateForm();
                          },
                          child: Text('UPDATE',
                              style: GoogleFonts.inter(
                                fontSize: 15.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                              )),
                        ),
                      ),
                    ],
                  )
          ],
        )
      ],
    );
  }

  Widget richText(double fontSize) {
    return Center(
      child: Text.rich(
        TextSpan(
          style: GoogleFonts.inter(
            fontSize: fontSize,
            color: const Color(0xFF21899C),
            letterSpacing: 2.000000061035156,
          ),
          children: [
            TextSpan(
              text: 'UPDATE',
              style: TextStyle(
                  fontWeight: FontWeight.w500, color: AppColors.mainColor),
            ),
            const TextSpan(
              text: 'MONUMENT',
              style: TextStyle(
                color: Color(0xFFFE9879),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future pickModel() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowCompression: true);

      if (result != null) {
        Uint8List? fileBytes = result.files.first.bytes;
        String fileName = result.files.first.name;
        String? filePath = result.files.first.path;

        setState(() {
          fromCloud2 = true;
        });

        await FirebaseStorage.instance
            .ref('Models/$fileName')
            .putFile(File(filePath!));
        final path = 'Models/$fileName';
        final ref = FirebaseStorage.instance.ref().child(path);
        final urlDownload = await ref.getDownloadURL();

        setState(() {
          model = urlDownload;
          fromCloud2 = false;
          isError6 = false;
        });
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  validateForm() async {
    if (image.isEmpty) {
      setState(() {
        isError8 = true;
      });
    }
    if (nameController.text.isEmpty) {
      setState(() {
        isError = true;
      });
    }
    if (locationController.text.isEmpty) {
      setState(() {
        isError2 = true;
      });
    }
    if (region.isEmpty) {
      setState(() {
        isError3 = true;
      });
    }
    if (descController.text.isEmpty) {
      setState(() {
        isError5 = true;
      });
    }
    if (model.isEmpty) {
      setState(() {
        isError6 = true;
      });
    }
    if (urlController.text.isEmpty) {
      setState(() {
        isError7 = true;
      });
    }
    if (image != '' &&
        nameController.text != '' &&
        locationController.text != '' &&
        region != '' &&
        descController.text != '' &&
        model != '' &&
        urlController.text != '') {
      setState(() {
        loading = true;
      });
      await FirebaseFirestore.instance
          .collection(widget.region!.trim() + '_monuments')
          .doc(widget.name!.trim().replaceAll(' ', ''))
          .delete();
      await FirebaseFirestore.instance
          .collection(region.trim() + '_monuments')
          .doc(nameController.text.trim().replaceAll(' ', ''))
          .set({
        'image': image,
        'info': descController.text,
        'location': locationController.text,
        'name': nameController.text,
        'region': region,
        'url': urlController.text
      });
      var oData = [
        {
          'image': widget.image,
          'models': widget.model,
          'name': widget.name,
        }
      ];
      var newData = [
        {
          'image': image,
          'models': model,
          'name': nameController.text,
        }
      ];
      await FirebaseFirestore.instance
          .collection('ar_models')
          .doc('ar_models')
          .update({'ar_models': FieldValue.arrayRemove(oData)});
      await FirebaseFirestore.instance
          .collection('ar_models')
          .doc('ar_models')
          .update({'ar_models': FieldValue.arrayUnion(newData)});
      final doc = await FirebaseFirestore.instance
          .collection('ar_models')
          .doc('ar_models')
          .get();
      List models = doc['ar_models'];
      setState(() {
        loading = false;
      });
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => MonumentPage(
                location: locationController.text,
                image: image,
                name: nameController.text,
                info: descController.text,
                url: urlController.text,
              )));
    }
  }

  ImageProvider getImage() {
    if (image == null) {
      return AssetImage('assets/img/avatar.png');
    } else if (image.startsWith('assets/')) {
      return AssetImage(image);
    } else if (image.startsWith('http')) {
      return NetworkImage(image);
    } else {
      return FileImage(File(image));
    }
  }

  Future uploadFile(String name, String filePath) async {
    final path = 'archeological-sites/$name';
    final file = File(filePath);

    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadedTask = ref.putFile(file);

    final snapshot = await uploadedTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    return urlDownload;
  }

  Future pickImage() async {
    try {
      const source = ImageSource.gallery;
      final pickedImage =
          await ImagePicker().pickImage(source: source, imageQuality: 25);
      if (pickedImage == null) return image;

      setState(() {
        fromCloud = true;
      });
      String urlDownload = await uploadFile(pickedImage.name, pickedImage.path);

      setState(() {
        image = urlDownload;
        fromCloud = false;
        isError8 = false;
      });
    } on PlatformException catch (e) {
      final snackBar = SnackBar(
        content: RichText(
            text: TextSpan(children: [
          const TextSpan(
              text: 'Failed to pick image\n\n',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          TextSpan(
              text: 'Try again',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.white)),
        ])),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
        // shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
