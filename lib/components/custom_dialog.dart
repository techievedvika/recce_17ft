import 'package:flutter/material.dart';
import 'component.dart';

class Confirmation extends StatefulWidget {
  final String? desc;
  final String? title;
  final bool? settle;
  final Function? onPressed;
  final String? yes;
  final String? no;
  final IconData? iconname;

  const Confirmation({
    super.key,
    required this.desc,
    required this.title,
    this.settle,
    required this.onPressed,
    required this.yes,
    this.no,
    required this.iconname,
  });

  @override
  ConfirmationState createState() => ConfirmationState();
}

class ConfirmationState extends State<Confirmation> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: 160,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Wrap(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: AppColors.primary,
                child: Column(
                  children: <Widget>[
                    Container(height: 10),
                    Icon(
                      widget.iconname,
                      color: Colors.white,
                      size: 40,
                    ),
                    Container(height: 10),
                    Text(
                      widget.title.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Container(height: 10),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Container(height: 10),
                    Text(
                      widget.desc ?? "",
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(0),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: widget.no != null
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  children: <Widget>[
                    CustomButton(
                     onPressedButton: () {
                        widget.onPressed!();
                        Navigator.of(context).pop();
                      },
                      title: widget.yes
                      ),
                     
                    
                    if (widget.no != null)
                      CustomButton(
                        title: widget.no,
                        onPressedButton: () {
                          Navigator.of(context).pop();
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
