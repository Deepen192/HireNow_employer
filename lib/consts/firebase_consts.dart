import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
User? currentUser = auth.currentUser;

//collections
const vendorsCollection = "vendors";
const usersCollection = "users";
const productsCollection = "jobs";
const cartCollection ='cart';
const chatsCollection ='chats';
const messageCollection ='messages';
const ordersCollection ='orders';