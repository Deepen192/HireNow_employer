import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/consts/consts.dart';

class UserOrdersController extends GetxController {
  // final String userId;
  //  UserOrdersController({required this.userId});
  var orders=[];
  var confirmed =false.obs;
  var ondelivery = false.obs;
  var delivered = false.obs;
  var paymentstatus =false.obs;
 
 getOrders(data) {
  orders.clear();
  for (var item in data['orders']) {
    orders.add(item);
  }
}


  changeStatus({title,status,docID}) async {
    var store =firestore.collection(ordersCollection).doc(docID);
    await store.set({title:status},SetOptions(merge:true));
  }
}