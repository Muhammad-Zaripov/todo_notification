import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WTextField extends StatelessWidget {
  final Widget? prefix;
  final Widget? suffix;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry contentPadding;
  final bool obscureText;
  final bool enabled;
  final int? maxLength;
  final FocusNode? focusNode;

  const WTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.hintText,
    this.hintStyle,
    this.textStyle,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    this.obscureText = false,
    this.enabled = true,
    this.maxLength,
    this.focusNode,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      maxLength: maxLength,
      focusNode: focusNode,
      style: textStyle ?? const TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
        suffix: suffix,
        prefix: prefix,
        hintText: hintText,
        hintStyle: hintStyle ?? TextStyle(color: Colors.grey.shade500),
        filled: true,
        contentPadding: contentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        counterText: '',
      ),
    );
  }
}
