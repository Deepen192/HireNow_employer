import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/services/store_services.dart';
import 'package:flutter_application_2/views/message_screen/adminchat_screen.dart';
import 'package:flutter_application_2/widgets_common/loading_indicator.dart';
import 'package:intl/intl.dart' as intl;
import 'package:get/get.dart';

class AdminMessagesScreen extends StatelessWidget {
  final String userId;
  const AdminMessagesScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: fontGrey,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () {
            Get.back();
          },
        ),
        title: boldText(text: messagse, size: 16.0, color: whiteColor),
      ),
      body: StreamBuilder(
        stream: StoreServices.getAllMessages(userId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else {
            var data = snapshot.data!.docs;
            if (data.isEmpty) {
              return const Center(
                child: Text('No messages found.', style: TextStyle(color: darkFontGrey, fontSize: 16)),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(data.length, (index) {
                      var t = data[index]['created_on'] == null
                          ? DateTime.now()
                          : data[index]['created_on'].toDate();
                      var time = intl.DateFormat("h:mma").format(t);
                      return ListTile(
                        onTap: () {
                          Get.to(
                            () =>  AdminChatScreen(userId:userId,),
                            arguments: [
                              data[index]['sender_name'],
                              data[index]['fromId']
                            ],
                          );
                        },
                        leading: const CircleAvatar(
                          backgroundColor: purpleColor,
                          child: Icon(
                            Icons.person,
                            color: whiteColor,
                          ),
                        ),
                        title: boldText(text: "${data[index]['sender_name']}", color: fontGrey),
                        subtitle: normalText(text: "${data[index]['last_msg']}", color: darkFontGrey),
                        trailing: normalText(text: time, color: darkFontGrey),
                      );
                    }),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
