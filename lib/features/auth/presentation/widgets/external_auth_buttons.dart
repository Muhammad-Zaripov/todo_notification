import 'package:flutter/material.dart';

class ExternalAuthButtons extends StatelessWidget {
  final String title;
  final Widget? logo;

  const ExternalAuthButtons({super.key, required this.title, this.logo});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Color(0xFF8875FF)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (logo != null) logo!,
              if (logo != null) const SizedBox(width: 15),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
