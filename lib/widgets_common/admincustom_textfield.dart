import 'package:flutter/material.dart';
import 'package:flutter_application_2/consts/consts.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isDesc;
  final bool isPassword;
  final int? maxLength;
   final TextInputType keyboardType;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isDesc = false,
    this.isPassword = false, required this.keyboardType, this.maxLength,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style:  const TextStyle(color: Colors.white),
      controller: widget.controller,
      maxLines: widget.isDesc ? 4 : 1,
      obscureText: widget.isPassword ? _isObscured : false,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        isDense: true,
        label: normalText(text: widget.label),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        hintText: widget.hint,
        hintStyle: const TextStyle(color: Colors.white),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,
            
      ),
       
    );
  }
}

// Function to call the CustomTextField widget
Widget customTextField({required String label, required String hint, required TextEditingController controller,TextInputType keyboardType = TextInputType.text, bool isDesc = false, bool isPassword = false, int? maxLength, }) {
  return CustomTextField(
    label: label,
    hint: hint,
    controller: controller,
    isDesc: isDesc,
    isPassword: isPassword, 
   keyboardType: keyboardType, 
   maxLength: maxLength,
  );
}
