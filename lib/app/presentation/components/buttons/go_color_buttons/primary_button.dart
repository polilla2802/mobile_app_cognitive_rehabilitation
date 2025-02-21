import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class PrimaryGoColorButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  const PrimaryGoColorButton({super.key, this.text = "Text", this.onPressed});

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        style: OutlinedButton.styleFrom(
            elevation: 5,
            shadowColor: Colors.black,
            foregroundColor: Colors.white, // <- this changes the splash color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: onPressed == null
                ? ConstValues.myPinkColor[600]
                : ConstValues.goColor),
        onPressed: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: onPressed == null ? Colors.white70 : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
