import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_2/consts/consts.dart';
import 'package:get/get.dart';

class AdminAuthController extends GetxController {
  var isloading = false.obs;

  // Create instances of FirebaseAuth and FirebaseFirestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //textcontroller
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var profileImgPath = ''.obs;
  var profileImageLink = '';


  Future<bool> resetPassword({required String email, required BuildContext context}) async {
    try {
      // Check if email exists in Firestore
      final snapshot = await _firestore.collection(vendorsCollection).where('email', isEqualTo: email).get();

      if (snapshot.docs.isNotEmpty) {
        // Email found, proceed with sending password reset email
        await _auth.sendPasswordResetEmail(email: email);
        return true; // Password reset email sent successfully
      } else {
        // Email not found
        return false; // Email not found
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', 'Failed to send reset email: ${e.message ?? "Unknown error"}', colorText: Colors.black);
      return false; // Password reset email failed
    } catch (e) {
      print('Password Reset Error: $e');
      Get.snackbar('Error', 'Failed to reset password. Please try again.', colorText: Colors.black);
      return false; // Password reset email failed
    }
  }
  // Login method
    Future<String?> loginMethod({required String email, required String password, required BuildContext context}) async {
    String? userId;
    try {
      final snapshot = await _firestore.collection(vendorsCollection).where('email', isEqualTo: email).get();
      
      if (snapshot.docs.isNotEmpty) {
        final userData = snapshot.docs.first.data();
        final storedPassword = userData['password'];

        if (password == storedPassword) {
          var userCredential = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          userId = userCredential.user!.uid;
                } else {
          Get.snackbar('Error', 'Incorrect password', colorText: Colors.black);
        }
      } else {
        Get.snackbar('Error', 'User with this email does not exist', colorText: Colors.black);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.black);
      print('Login Error: ${e.toString()}');
    }
    return userId;
  }

  // Update password method
  Future<void> updatePassword(String newPassword) async {
    try {
      await _auth.currentUser!.updatePassword(newPassword);
      print("Password updated successfully in AuthController.");
    } catch (error) {
      print("Password update error in AuthController: $error");
    }
  }

  // Signup method
  Future<UserCredential?> signupMethod({email, password, name, context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Storing user data in Firestore after successful signup
      await storeUserData(
        name: name, // Use the provided username here.
        password: password,
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.black);
      print('Signup Error: ${e.toString()}');
    }
    return userCredential;
  }

  // Storing data method
  storeUserData({name, password, email}) async {
    DocumentReference store =
        _firestore.collection(vendorsCollection).doc(_auth.currentUser!.uid);
    store.set({
      'vendor_name': name, // Use the provided username here.
      'password': password,
      'email': email,
      'imageUrl': '', // Set the user's profile image URL here.
      'id': _auth.currentUser!.uid,
    });
  }

  // Signout method
  Future<void> signoutMethod(BuildContext context) async {
    try {
      await _auth.signOut();
      isloading(false); // Reset isloading after logout
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.black);
    }
  }

   String getUserId() {
    return currentUser!.uid;
  } 

}
