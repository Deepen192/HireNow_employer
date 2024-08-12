import 'package:flutter/material.dart';
// Import for LengthLimitingTextInputFormatter
import 'package:flutter_application_2/consts/consts.dart';

class CustomTextField extends StatefulWidget {
  final String? title;
  final String? hint;
  final TextEditingController? controller;
  final bool isPass;

  const CustomTextField({
    Key? key,
    this.title,
    this.hint,
    this.controller,
    required this.isPass,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isPass;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) // Check if title is not null
          Text(
            widget.title!,
            style: TextStyle(
              color: Colors.orange,
              fontFamily: semibold,
              fontSize: 16,
            ),
          ),
        const SizedBox(height: 5),
        TextFormField(
          obscureText: _isObscure,
          controller: widget.controller,
          decoration: InputDecoration(
            hintStyle: const TextStyle(
              fontFamily: semibold,
              color: textfieldGrey,
            ),
            hintText: widget.hint,
            isDense: true,
            fillColor: lightGrey,
            filled: true,
            border: InputBorder.none,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: redColor),
            ),
            suffixIcon: widget.isPass
                ? IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                      color: textfieldGrey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  )
                : null,
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}

// Function to call the CustomTextField widget
Widget customTextField({
  required String? title,
  required String? hint,
  TextEditingController? controller,
  required bool isPass,
}) {
  return CustomTextField(
    title: title,
    hint: hint,
    controller: controller,
    isPass: isPass,
  );
}
