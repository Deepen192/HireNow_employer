import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/consts/consts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class SettingProfController extends GetxController {
  final String userId;
   SettingProfController({required this.userId});
  late QueryDocumentSnapshot snapshotData;
  var profileImgPath = ''.obs;
  var profileImageLink = '';
  var isloading = false.obs;

  // Text fields
  var nameController = TextEditingController();
  var oldpasswordController = TextEditingController();
  var newpasswordController = TextEditingController();

  //office controller
  var  officeNameController = TextEditingController();
  var  officeAddressController = TextEditingController();
  var  officeMobileController = TextEditingController();
  var  officeWebsiteController = TextEditingController();
  var  officenDescController = TextEditingController();
  var officeEmailAddressController =TextEditingController();

  void resetForm() {
    officeNameController.clear();
    officeAddressController.clear();
    officeEmailAddressController.clear();
    officeMobileController.clear();
    officeWebsiteController.clear();
    officenDescController.clear();
  }

  changeImage(context) async {
  try {
    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Image Source"),
        actions: [
          IconButton(
            alignment: Alignment.bottomLeft,
            icon: const Icon(Icons.camera),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          IconButton(
            alignment: Alignment.bottomRight,
            icon: const Icon(Icons.image),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (imageSource == null) return;

    final img = await ImagePicker().pickImage(
      source: imageSource,
      imageQuality: 70,
    );

    if (img == null) return;

    profileImgPath.value = img.path;
  } on PlatformException catch (e) {
    VxToast.show(context, msg: e.toString());
  }
}
  uploadProfileImage() async {
    var filename = basename(profileImgPath.value);
    var destination = 'images/${userId}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImageLink = await ref.getDownloadURL();
  }

  updateProfile({String? name, String? password, String? imgUrl}) async {
    var store = firestore.collection(vendorsCollection).doc(userId);
    var dataToUpdate = <String, dynamic>{};

    if (name != null) {
      dataToUpdate['vendor_name'] = name;
    }

    if (password != null) {
      dataToUpdate['password'] = password;
    }

    if (imgUrl != null) {
      dataToUpdate['imageUrl'] = imgUrl;
    }

    await store.set(dataToUpdate, SetOptions(merge: true));
    isloading(false);
  }

  changeAuthPassword({String? email, String? password, String? newpassword}) async {
    final cred = EmailAuthProvider.credential(email: email!, password: password!);

    await currentUser!
        .reauthenticateWithCredential(cred)
        .then((value) {
          currentUser!.updatePassword(newpassword!);
        })
        .catchError((error) {
          print(error.toString());
        });
  }

  Future<void> loadOfficeData(String userId) async {
    try {
      var doc = await FirebaseFirestore.instance.collection(vendorsCollection).doc(userId).get();
      if (doc.exists) {
        var data = doc.data()!;
        officeNameController.text = data['office_name'] ?? '';
        officeAddressController.text = data['office_address'] ?? '';
        officeEmailAddressController.text = data['office_email_address'] ?? '';
        officeMobileController.text = data['office_mobile'] ?? '';
        officeWebsiteController.text = data['office_website'] ?? '';
        officenDescController.text = data['office_desc'] ?? '';
      }
    } catch (e) {
      print('Error loading office data: $e');
    }
  }


  updateOffice({String? officename, String? officeaddress, String? officemobile,String? officewebsite, String? officedesc,String? officeemailaddress}) async{
     var store = firestore.collection(vendorsCollection).doc(userId);
      var dataToUpdate = <String, dynamic>{};

    if (officename != null) {
      dataToUpdate['office_name'] = officename;
    }

    if (officeaddress != null) {
      dataToUpdate['office_address'] = officeaddress;
    }

    if (officeemailaddress != null) {
      dataToUpdate['office_email_address'] = officeemailaddress;
    }

    if (officemobile != null) {
      dataToUpdate['office_mobile'] = officemobile;
    }

    if (officewebsite != null) {
      dataToUpdate['office_website'] = officewebsite;
    }

     if (officedesc != null) {
      dataToUpdate['office_desc'] = officedesc;
    }


    await store.set(dataToUpdate, SetOptions(merge: true));
    isloading(false);

  }
  
}