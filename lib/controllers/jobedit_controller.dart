import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/models/category_model.dart';

class EditJobsController extends GetxController{
  final String userId;
   EditJobsController({required this.userId});

  
  var discountController = TextEditingController(); 
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
     var preqController=TextEditingController();
      var prolresController=TextEditingController();
       var pdicstrictController=TextEditingController();
        var pstreetController=TextEditingController();
        var pwardController=TextEditingController();
  
    

   
    var selectedColorIndex=0.obs;
    
    void resetForm() {
    pnameController.clear();
    pdescController.clear();
    ppriceController.clear();
    pquanitytController.clear();
    discountController.clear();
    categoryvalue.value = '';
    subcategoryvalue.value = '';
    preqController.clear();
    pdicstrictController.clear();
    pstreetController.clear();
    pwardController.clear();


   
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
         preqController.text=productData['p_requirement'];
         prolresController.text=productData['p_role&responsible'];
    pdicstrictController.text=productData['p_district'];
    pstreetController.text=productData['p_street'];
    pwardController.text=productData['p_ward'];
       
        
      }
    } catch (e) {
      print('Error loading product data: $e');
    }
  }
Future<void> updateJob(BuildContext context, String productId) async {  
  try {    
    // Calculate the discounted price if a valid discount percentage is provided
    var store = FirebaseFirestore.instance.collection(productsCollection).doc(productId);
      // Convert numeric values to strings (automatic removal of .00 decimals)
    
    // Get the current product data to retrieve the existing image URLs
    // var document = await store.get();



    // Update other product details
    await store.update({       
      
      'p_desc': pdescController.text,
      'p_name': pnameController.text,
      'p_price': ppriceController.text,
      'p_quantity': pquanitytController.text,
    'p_district':pdicstrictController.text,
    'p_ward':pwardController.text,
    'p_street':pstreetController.text,
    'p_requirement':preqController.text,
    'p_role&responsible':prolresController.text,
      // ... (other fields you want to update)
    });

    isloading(false);
    VxToast.show(context, msg: "Product Updated");
  } catch (e) {
    print('Error updating product: $e');
  }
}

 
}


