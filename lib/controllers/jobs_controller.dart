import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/controllers/adminhome_controller.dart';
import 'package:flutter_application_2/models/category_model.dart';

class JobsController extends GetxController{
  final String userId;
   JobsController({required this.userId});  

  var isloading =false.obs;
  var pnameController=TextEditingController();
   var pdescController=TextEditingController();
   var ppriceController=TextEditingController();
    var pquanitytController=TextEditingController();
     var preqController=TextEditingController();
      var prolresController=TextEditingController();
       var paddressController=TextEditingController();
        var pjobtypeController=TextEditingController();
        var pgenderController=TextEditingController();
        var pjobtimeController=TextEditingController();
        var pkeywordsController = TextEditingController();

    var categoryList=<String>[].obs;
    var subcategoryList=<String>[].obs;
    List<Category>category=[];
     var categoryvalue=''.obs;
    var subcategoryvalue=''.obs;    
    

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
void resetForm() {
    pnameController.clear();
    pdescController.clear();
    ppriceController.clear();
    pquanitytController.clear();
    categoryvalue.value = '';
    subcategoryvalue.value = '';
    preqController.clear();
      prolresController.clear();
        paddressController.clear();
         pjobtypeController.clear();
         pgenderController.clear();
         pjobtimeController.clear();
         pkeywordsController.clear(); 
  }

uploadJob(context) async {
   var store = firestore.collection(productsCollection).doc();
     String productId = store.id;
    List<Map<String, String>> initialRatings = [];
     // Split keywords by comma and trim whitespace
    List<String> keywords = pkeywordsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty) // Filter out empty strings
        .toList();
  await store.set({
    'p_id': productId,
    'is_featured': false,
    'p_category': categoryvalue.value,
    'p_subcategory': subcategoryvalue.value,
    'p_wishlist': FieldValue.arrayUnion([]),
    'p_desc': pdescController.text,
    'p_name': pnameController.text,   
    'p_quantity': pquanitytController.text,
    'p_seller': Get.find<AdminHomeController>().username,
     'p_ratings': initialRatings,
    'vendor_id': userId,
    'featured_id': '',
    'p_price': ppriceController.text,
    'p_jobaddress':paddressController.text,
    'p_gender':pgenderController.text,
    'p_jobtime':pjobtimeController.text,
    'p_jobtype':pjobtypeController.text,
    'p_requirement':preqController.text,
    'p_role&responsible':prolresController.text,
   'flashsales': false, 
   'keywords': keywords,
  });
  isloading(false);
  VxToast.show(context, msg: "Product Uploaded");
}

addFeatured(docId) async{
  await firestore.collection(productsCollection).doc(docId).set({
    'featured_id':userId,
    'is_featured':true,
  },SetOptions(merge: true));
}

removeFeatured(docId) async{
  await firestore.collection(productsCollection).doc(docId).set({
    'featured_id':'',
    'is_featured':false,
  },SetOptions(merge: true));
}
 
 removeProduct(docId)async{
  await firestore.collection(productsCollection).doc(docId).delete();
 }
 
}


