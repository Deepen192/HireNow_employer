import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/consts/firebase_consts.dart';

class FirestoreServices{
  //get vendor data
  static getUser(uid){
    return firestore.collection(vendorsCollection).where('id', isEqualTo: uid).snapshots();

  }
  //get products according to category
  static getProducts(category){
  return firestore.collection(productsCollection).where('p_category',isEqualTo:category).snapshots();

  }

  static getSubCategoryProducts(title){
     return firestore.collection(productsCollection).where('p_subcategory',isEqualTo: title).snapshots();

  }


  //add product in cart collection of firebase database with the given parameters and returns a future object which
  static getCart(uid){
    return firestore
    .collection(cartCollection)
    .where('added_by', isEqualTo: uid)
    .snapshots();
  }

  //delet cart document
  static deleteDocument(docId){
    return firestore.collection(cartCollection).doc(docId).delete();

  }
  // get all chat message
   static Stream<QuerySnapshot> getChatMessages(String docId, String userId) {
    return FirebaseFirestore.instance
        .collection(chatsCollection)
        .doc(docId)
        .collection(messageCollection)
        // .where('toId', isEqualTo: userId) // Filter messages where uid equals userId
        .orderBy('created_on', descending: false)
        .snapshots();
  }
  // Get all orders
  static getAllOrders() {
    return firestore.collection(ordersCollection).snapshots();
  }
  static getWishlists(){
    return firestore.collection(productsCollection).where('p_wishlist',arrayContains: currentUser!.uid).snapshots();
  }

  static getAllMessages(){
     return firestore.collection(chatsCollection).where('fromId', isEqualTo: currentUser!.uid).snapshots();
  }

  static getCounts()async{
    var res =await Future.wait([
      firestore.collection(cartCollection).where('added_by', isEqualTo: currentUser!.uid).get().then((value) {
       return value.docs.length;
      }),

      firestore.collection(productsCollection).where('p_wishlist',arrayContains: currentUser!.uid).get().then((value) {
       return value.docs.length;
      }),

       firestore.collection(ordersCollection).where('order_by',isEqualTo: currentUser!.uid).get().then((value) {
       return value.docs.length;
      })
    ]);
    return res;
  }

  static allproducts(){
    return firestore.collection(productsCollection).snapshots();
  }

  // get featured products method
  static getFeaturedProducts(){
    return firestore.collection(productsCollection).where('is_featured',isEqualTo: true).get();
  }
  static searchProducts(title){
    return firestore.collection(productsCollection).get();
  }

 static Future<QuerySnapshot> getDuplicateProducts(String userId, String pname, String pdesc, String category, String subcategory, List<String> selectedColors, String originalPriceString) {
    return FirebaseFirestore.instance
        .collection(productsCollection)
        .where('p_name', isEqualTo: pname)
        .where('p_desc', isEqualTo: pdesc)
        .where('vendor_id', isEqualTo: userId)
        .where('p_category', isEqualTo: category)
        .where('p_subcategory', isEqualTo: subcategory)
        .where('p_colors', arrayContainsAny: selectedColors)
        .where('p_price', isEqualTo: originalPriceString)
        .get();
  }
  
}

