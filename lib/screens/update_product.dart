import 'package:flutter/material.dart';

// class UpdateproductScreen extends StatefulWidget {
//   final String image;
//   final String name;
//   final String breed;
//   final String desc;
//   final String price;
//   UpdateproductScreen({
//     required this.breed,
//     required this.desc,
//     required this.image,
//     required this.name,
//     required this.price
//   });

//   @override
//   State<UpdateproductScreen> createState() => _UpdateproductScreenState();
// }

// class _UpdateproductScreenState extends State<UpdateproductScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Update Product Information'
//         ),

//       ),
//       body: ,
//     );
//   }
// }

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/services.dart';
import 'package:veta/screens/petbreed.dart';
import 'package:veta/screens/size_config.dart';
import 'package:image_picker/image_picker.dart';

import '../utils.dart';

class UpdateProduct extends StatefulWidget {
  final String image;
  final String name;
  final String breed;
  final String desc;
  final String price;
  final String taskId;
  UpdateProduct(
      {required this.breed,
      required this.desc,
      required this.image,
      required this.name,
      required this.taskId,
      required this.price});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final user = FirebaseAuth.instance.currentUser!;
  final _regKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String selectedImagePath = '';
  String selectedImageName = '';
  String? imageUrl;
  File? _image = null;

  Future<void> getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image != null) {
        setState(() {
          _image = File(image.path);
          selectedImagePath = image.path;
          selectedImageName = image.path.split('/').last;
        });
        Navigator.pop(context);
        uploadFile();
      } else {
        Navigator.pop(context);
        warningSnackBar(context: context, message: 'No Image picked');
      }
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  UploadTask? uploadTask;

  Future uploadFile() async {
    final _path = 'productImages/${selectedImageName}';
    final _file = File(selectedImagePath);

    final imageRef = FirebaseStorage.instance.ref().child(_path);
    setState(() {
      uploadTask = imageRef.putFile(_file);
    });

    print(imageUrl);

    final snapshot = await uploadTask!.whenComplete(() {});
    final imageLink = await snapshot.ref.getDownloadURL();
    imageUrl = imageLink;

    setState(() {
      uploadTask = null;
    });
  }

  Widget buildProgess() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          return SizedBox(
            height: getProportionateScreenHeight(30.0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                  child: Text('${(100 * progress).roundToDouble()}% uploaded'),
                )
              ],
            ),
          );
        } else {
          return SizedBox();
        }
      });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Product'),
      ),
      body: Form(
        key: _regKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(25.0),
              vertical: getProportionateScreenHeight(20.0)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                selectedImageName.isEmpty
                    ? Container(
                        child: DottedBorder(
                            color: Colors.blue, //color of dotted/dash line
                            strokeWidth: 2, //thickness of dash/dots
                            dashPattern: [4, 3],
                            borderType: BorderType.RRect,
                            radius: Radius.circular(16),
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    isDismissible: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(50))),
                                    context: context,
                                    builder: (context) => productImagePicker());
                              },
                              child: Container(
                                  //inner container
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Color(0xffECF3FC),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child:
                                      Image(image: NetworkImage(widget.image))),
                            )),
                      )
                    : Container(
                        child: DottedBorder(
                            color: Colors.blue, //color of dotted/dash line
                            strokeWidth: 2, //thickness of dash/dots
                            dashPattern: [6, 6],
                            borderType: BorderType.RRect,
                            radius: Radius.circular(16),
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    isDismissible: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(50))),
                                    context: context,
                                    builder: (context) => productImagePicker());
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.fill,
                                  alignment: Alignment.center,
                                ),
                              ),
                            )),
                      ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                buildProgess(),
                SizedBox(
                  height: 20,
                ),
                inputField(inputController: _nameController, text: widget.name),
                inputField(
                    inputController: _priceController, text: widget.price),
                inputField(
                    inputController: _modelController, text: widget.breed),
                inputField(
                    inputController: _descriptionController, text: widget.desc),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        updateProduct();
                      },
                      child: Text('Update')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget productImagePicker() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: Text('Add Image')),
          SizedBox(height: 15),
          buildImagePickerButton(
            onPressed: () async {
              await getImage(ImageSource.camera);
            },
            buttonText: 'Camera',
            pixIcon: Icons.camera,
          ),
          SizedBox(
            height: 20,
          ),
          buildImagePickerButton(
            buttonText: 'Gallery',
            pixIcon: Icons.image,
            onPressed: () async {
              await getImage(ImageSource.gallery);
            },
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget buildImagePickerButton(
      {required VoidCallback onPressed,
      required String buttonText,
      required IconData pixIcon}) {
    return SizedBox(
      height: 60,
      width: 366,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20.58),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    pixIcon,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 18,
                  ),
                  Text(
                    buttonText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 15,
              ),
            ],
          ),
        ),
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            )),
      ),
    );
  }

  Column inputField(
      {required String text, required TextEditingController inputController}) {
    return Column(
      children: [
        TextFormField(
          controller: inputController,
          decoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            hintText: text,
            fillColor: Color.fromARGB(255, 243, 241, 241),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'field cannot be empty';
            } else {
              return null;
            }
          },
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Future updateProduct() async {
    final isValid = _regKey.currentState!.validate();
    if (!isValid) return;
    if (imageUrl == null) {
      failureSnackBar(context: context, message: 'Upload product image');
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
                child: CircularProgressIndicator(),
              ));

      PetBreed breed = PetBreed(
          petImage: imageUrl,
          petPrice: _priceController.text,
          petBreed: _modelController.text,
          petDescription: _descriptionController.text,
          petName: _nameController.text);

      try {
        await FirebaseFirestore.instance
            .collection(user.uid)
            .doc(widget.taskId)
            .update(breed.toJson());

        Navigator.pop(context);
        successSnackBar(
            context: context, message: 'product updated successfully');
        Navigator.pop(context);
      } on FirebaseException catch (e) {
        Navigator.pop(context);

        failureSnackBar(context: context, message: e.message.toString());
      }
    }
  }
}
