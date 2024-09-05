import 'package:flutter/material.dart';

import '../configs/color/color.dart';

class CustomDropdownFormField extends StatefulWidget {
  final List<String> options;
  final String? selectedOption;
  final ValueChanged<String?>? onChanged;
  final String labelText;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;

  const CustomDropdownFormField({
    super.key,
    required this.options,
    this.selectedOption,
    required this.onChanged,
    required this.labelText,
    this.focusNode,
    this.validator,
  });

  @override
  _CustomDropdownFormFieldState createState() =>
      _CustomDropdownFormFieldState();
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      focusNode: widget.focusNode,
      value: widget.options.contains(widget.selectedOption)
          ? widget.selectedOption
          : null,
      onChanged: widget.onChanged,
      items: widget.options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: SizedBox(
            width: 260, // Set a fixed width to prevent overflow
            child: Text(
              value,
              maxLines: 1, // Allow only one line of text
              overflow: TextOverflow.ellipsis, // Use ellipsis for overflow
            ),
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        iconColor: AppColors.primary,
        labelText: widget.labelText,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 1,
            color: AppColors.onBackground,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 2,
            color: AppColors.primary,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 1,
            color: AppColors.outline,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 2,
            color: AppColors.error,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          // Scrollable.ensureVisible(
          //   widget.focusNode!.context! ?? context,
          //   alignment: 0.5, // Adjust alignment as needed
          //   duration: const Duration(milliseconds: 500), // Scroll animation duration
          // );
          return 'Select an option';
        }
        return null;
      },
    );
  }
}
