import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/controllers/adminhome_controller.dart';

import 'package:get/get.dart';

class AdminChatsController extends GetxController {
  final String userId;
  late String currentId; // Declare currentId here

  AdminChatsController({required this.userId}) {
    currentId = userId; // Initialize currentId in the constructor
  }

  @override
  void onInit() {
    getChatId();
    super.onInit();
  }

  var chats = FirebaseFirestore.instance.collection(chatsCollection);
  var friendName = Get.arguments[0];
  var friendId = Get.arguments[1];
  var senderName = Get.find<AdminHomeController>().username;
  var msgController = TextEditingController();
  dynamic chatDocId;
  var isLoading = false.obs;

  void getChatId() async {
    isLoading(true);

    await chats
        .where('users', isEqualTo: {currentId: null, friendId: null})
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        chatDocId = snapshot.docs.single.id;
      } else {
        chats
            .add({
              'created_on': null,
              'last_msg': '',
              'users': {friendId: null, currentId: null},
              'toId': '',
              'fromId': '',
              'friend_name': friendName,
              'sender_name': senderName
            })
            .then((value) {
              chatDocId = value.id;
            });
      }
    });

    isLoading(false);
  }

  void sendMsg(String msg) async {
    if (msg.trim().isNotEmpty) {
      chats.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toId': currentId,
        'fromId': friendId,
      });

      chats.doc(chatDocId).collection(messageCollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId,
        'fromId': friendId,
      });
    }
  }
}
