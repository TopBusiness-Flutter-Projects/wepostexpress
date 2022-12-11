
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyFormField extends FormField<Widget> {
  MyFormField({
    @required BuildContext context,
    @required Widget child,
    @required bool hasError,
    @required EdgeInsetsGeometry padding,
    @required String error,
  }) : super(
    validator: (value) {
      if (hasError) {
        return error;
      }
      return null;
    },
    builder: (state) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        if (state.hasError)
          SizedBox(height: 10,),
        if (state.hasError)
          Padding(
            padding: padding,
            child: Text(
              state.errorText,
              style: TextStyle(color: Colors.red.shade900,fontSize: 12),
            ),
          ),
      ],
    ),
  );
}
