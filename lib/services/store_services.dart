import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/consts/consts.dart';
class StoreServices {
final String userId;
 StoreServices({required this.userId});

  static searchJobs(title){
    return firestore.collection(productsCollection).get();
  }


  static Stream<QuerySnapshot> getProfile(String userId) {
  return FirebaseFirestore.instance
    .collection(vendorsCollection) 
    .where('id', isEqualTo: userId) 
    .snapshots();
}
  // static getProfile(uid){
  //   return firestore.collection(vendorsCollection).where('id',isEqualTo: uid).get();
  // }

  
 static Stream<QuerySnapshot> getChatMessages(String docId, String userId) {
    return FirebaseFirestore.instance
        .collection(chatsCollection)
        .doc(docId)
        .collection(messageCollection)
        // .where('fromId', isEqualTo: userId) // Filter messages where uid equals userId
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  // static getMessages(uid){
  //   return firestore.collection(chatsCollection).where('toId',isEqualTo: uid).snapshots();
  // }

  static Stream<QuerySnapshot> getSalesReport(String userId) {
    return FirebaseFirestore.instance
        .collection(ordersCollection)
          .where('vendor_id', isEqualTo: userId)
          .where('payment_status', isEqualTo: true)
          .snapshots();

  }

   static Stream<QuerySnapshot> getOrders(String userId) {
    return FirebaseFirestore.instance
        .collection('orders') 
        .where('vendor_id', arrayContains: userId) 
        .snapshots();
  }
  // static getOrders(uid){
  //   return firestore.collection(ordersCollection).where('vendors',arrayContains: uid).snapshots();
    
  // }

   static Stream<QuerySnapshot> getProducts(String userId) {
  return FirebaseFirestore.instance
    .collection(productsCollection) // Replace with your collection name
    .where('vendor_id', isEqualTo: userId) // Use userId passed from another screen
    .snapshots();
}

   static Stream<QuerySnapshot> getProductId(String productId) {
  return FirebaseFirestore.instance
    .collection(productsCollection) // Replace with your collection name
    .where('p_id', isEqualTo: productId) // Use userId passed from another screen
    .snapshots();
}
  // 

  // static getProducts(uid){
  //   return firestore.collection(productsCollection).where('vendor_id',isEqualTo: uid).snapshots();
    
  // }

    // Get all orders

  static Stream<QuerySnapshot> getAllOrders(String userId) {
  return FirebaseFirestore.instance
      .collection(ordersCollection)
      .where('vendor_id', isEqualTo: userId) 
      .snapshots();
}


   static Stream<QuerySnapshot> customerDetails(String userId) {
    return FirebaseFirestore.instance
        .collection(ordersCollection) 
        .where('vendor_id', isEqualTo: userId)
        .snapshots();
  }
  static Stream<QuerySnapshot> getAllMessages(String userId) {
  return FirebaseFirestore.instance
    .collection(chatsCollection) // Use your products collection name
    .where('toId', isEqualTo: userId) // Use userId passed from another screen
    .snapshots();
}

//  static Stream<QuerySnapshot> getAllOrders(String userId) {
//     return FirebaseFirestore.instance
//       .collection(ordersCollection)
//       .where('vendor_id', arrayContains: userId) 
//       .snapshots();
//   }
  // static getAllOrders() {
  //   return firestore.collection(ordersCollection).snapshots();
  // } 
 
  }

  
