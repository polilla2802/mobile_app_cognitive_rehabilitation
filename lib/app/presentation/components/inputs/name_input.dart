import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';

class NameInput extends StatelessWidget {
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  const NameInput({super.key, this.onSaved, this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        style: GoogleFonts.poppins(color: ConstValues.blackColor, fontSize: 18),
        cursorColor: ConstValues.pinkColor,
        onSaved: onSaved,
        validator: validator,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            hintText: 'Name', hintStyle: GoogleFonts.poppins(fontSize: 16)),
      ),
    );
  }
}
