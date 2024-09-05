import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recce/configs/color/color.dart';

class LoadingWidget extends StatefulWidget {
  final double? size;
  const LoadingWidget({
    super.key,
    this.size,
  });

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        
        Center(
          child: Platform.isAndroid
              ? Center(
                child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeCap: StrokeCap.round,
                    strokeWidth: widget.size ?? 50,
                  ),
              )
              : const CupertinoActivityIndicator(
                  color: Colors.blue,
                ),
        ),
      ],
    );
  }
}
