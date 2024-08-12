import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/models/category_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
class EditJobsController extends GetxController{
  final String userId;
   EditJobsController({required this.userId});

  
  var discountController = TextEditingController();

  RxDouble discountedPrice = RxDouble(0.0);

  void calculateDiscountedPrice(double originalPrice, double discountPercentage) {
    double discountedPriceValue = originalPrice * (1 - discountPercentage / 100);
    discountedPrice.value = discountedPriceValue;
  }

 
  var isloading =false.obs;
  var pnameController=TextEditingController();
   var pdescController=TextEditingController();
   var ppriceController=TextEditingController();
    var pquanitytController=TextEditingController();

    var categoryList=<String>[].obs;
    var subcategoryList=<String>[].obs;
    List<Category>category=[];
     var categoryvalue=''.obs;
    var subcategoryvalue=''.obs;
    var pImagesLinks =[];
    var pImagesList = RxList<dynamic>.generate(3, (index) => null);
    

   
    var selectedColorIndex=0.obs;
    
    void resetForm() {
    pnameController.clear();
    pdescController.clear();
    ppriceController.clear();
    pquanitytController.clear();
    discountController.clear();
    categoryvalue.value = '';
    subcategoryvalue.value = '';
    discountedPrice.value = 0.0;
    pImagesList.fillRange(0, pImagesList.length, null);
  }

    getCategories() async{
      var data=await rootBundle.loadString("lib/services/category_model.json");
      var cat= categoryModelFromJson(data);
      category=cat.categories;
    }

    populateCategoryList(){
      categoryList.clear();
      for(var item in category){
        categoryList.add(item.name);
      }
    }
    populateSubcategory(cat){
      subcategoryList.clear();
      var data= category.where((element)=>element.name==cat).toList();
      for(var i =0;i<data.first.subcategory.length;i++){
        subcategoryList.add(data.first.subcategory[i]);
      }
    } 
Map<String, dynamic> productData = {}; // Store fetched product data

    // Fetch and load product data based on the provided productId
 Future<void> loadJobData(String productId) async {
    try {
      var store = FirebaseFirestore.instance.collection(productsCollection).doc(productId);
      var document = await store.get();
      if (document.exists) {
        productData = document.data()!;
        pnameController.text = productData['p_name'];
        pdescController.text = productData['p_desc'];
        ppriceController.text = productData['p_price'];
        pquanitytController.text = productData['p_quantity'];
        discountController.text = productData['pd_percentage'].toString();
        List<dynamic> images = productData['p_imgs'] ?? [];
        pImagesList.value = images;

        
      }
    } catch (e) {
      print('Error loading product data: $e');
    }
  }
Future<void> updateJob(BuildContext context, String productId) async {  
  try {
     double originalPrice = double.tryParse(ppriceController.text) ?? 0.0;
    double discountPercentage = double.tryParse(discountController.text) ?? 0.0;
    
    // Calculate the discounted price if a valid discount percentage is provided
    double? discountedPrice = discountPercentage > 0.0 ? originalPrice * (1 - discountPercentage / 100) : null;
    var store = FirebaseFirestore.instance.collection(productsCollection).doc(productId);
      // Convert numeric values to strings (automatic removal of .00 decimals)
    String originalPriceString = originalPrice.toString();
    String discountedPriceString = discountedPrice != null ? discountedPrice.toString() : '';
    String discountPercentageString = discountPercentage.toString();
    // Get the current product data to retrieve the existing image URLs
    var document = await store.get();
    List<dynamic> existingImages = document.data()?['p_imgs'] ?? [];

    // Upload new images and get their download URLs
    await uploadImages();

    // Replace old image URLs with new ones where provided
    for (int i = 0; i < pImagesList.length; i++) {
      if (pImagesList[i] != null) {
        // Delete old image from Firebase Storage if a new image is provided
        if (existingImages.length > i && existingImages[i] != null) {
          try {
            var ref = FirebaseStorage.instance.refFromURL(existingImages[i]);
            await ref.delete();
          } catch (e) {
            print("Error deleting image: $e");
          }
        }
        // Replace the old image URL with the new one
        existingImages[i] = pImagesLinks[i];
      }
    }

    // Update other product details
    await store.update({       
      
      'p_desc': pdescController.text,
      'p_name': pnameController.text,
      'p_price': originalPriceString,
      'p_quantity': pquanitytController.text,
      'pd_price': FieldValue.delete(),
       'pd_percentage': discountPercentageString,
       'p_imgs': FieldValue.arrayRemove(existingImages),
      // ... (other fields you want to update)
    });
    await uploadImages();
       await store.update({
      'pd_price': discountedPriceString, // Add new discountedPrice
      'p_imgs': existingImages,
    });

    isloading(false);
    VxToast.show(context, msg: "Product Updated");
  } catch (e) {
    print('Error updating product: $e');
  }
}
// Function to pick an image from the gallery or the camera
Future<void> pickImage(int index, BuildContext context) async {
  try {
    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Image"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.of(context).pop(await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  ));
                },
                icon: const Icon(Icons.photo_library), // Gallery icon
                label: const Text("Gallery"),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.of(context).pop(await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  ));
                },
                icon: const Icon(Icons.camera_alt), // Camera icon
                label: const Text("Camera"),
              ),
            ],
          ),
        );
      },
    );

    if (pickedFile != null) {
      // Check if the picked image already exists in the list
      if (pImagesList.contains(File(pickedFile.path))) {
        // Show an error message indicating that the image is already selected
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image already selected')),
        );
      } else {
        pImagesList[index] = File(pickedFile.path);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected')),
      );
    }
  } catch (e) {
    VxToast.show(context, msg: e.toString());
  }
}

// Function to upload images from the camera and gallery
uploadImages() async {
  pImagesLinks.clear();
  for (var item in pImagesList) {
    if (item != null) {
      try {
        var filename = basename(item.path);
        var destination = 'images/vendor/${userId}/$filename';
        Reference ref = FirebaseStorage.instance.ref().child(destination);
        TaskSnapshot uploadTask;

        // Check if the image is from the camera or gallery
        if (item is PickedFile) {
          // For images from the camera
          var file = File(item.path);
          uploadTask = await ref.putFile(file);
        } else if (item is File) {
          // For images from the gallery
          uploadTask = await ref.putFile(item);
        } else {
          // Unsupported image type, skip this iteration
          continue;
        }

        var downloadURL = await uploadTask.ref.getDownloadURL();
        pImagesLinks.add(downloadURL);
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
  }
}


 
}


