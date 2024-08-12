import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_2/consts/consts.dart';

class AdminHomeController extends GetxController{ 
  var hasLowStockProducts = false.obs;

  @override
 void onInit() {
   getUsername();
   super.onInit();
     fetchLowStockProducts();
}
var searchController = TextEditingController();
Future<void> fetchLowStockProducts() async {
  try {
    var store = FirebaseFirestore.instance.collection('products');
    var querySnapshot = await store.where('vendor_id', isEqualTo: userId).get();
    var allProducts = querySnapshot.docs;
    var lowStockProducts = allProducts.where((doc) {
      var quantityString = doc['p_quantity'] as String;
      var quantity = int.tryParse(quantityString) ?? 0;
      return quantity <= 0;
    }).toList();
    
    // Update hasLowStockProducts based on lowStockProducts list
    hasLowStockProducts.value = lowStockProducts.isNotEmpty;
  } catch (e) {
    print('Error fetching low stock products: $e');
  }
}


  var navIndex=0.obs;
  var username='';
  var userId = FirebaseAuth.instance.currentUser!.uid;
  getUsername() async {
   var n = await firestore.collection(vendorsCollection).where('id', isEqualTo:currentUser!.uid).get().then((value){
      if (value.docs.isNotEmpty){
        return value.docs.single['vendor_name'];
      }
    });
   username =n;
   
   
  }
   getUserid() async {
   var n = await firestore.collection(vendorsCollection).where('id', isEqualTo:currentUser!.uid).get().then((value){
      if (value.docs.isNotEmpty){
        return value.docs.single['id'];
      }
    });
   userId =n;  
   
  }
}