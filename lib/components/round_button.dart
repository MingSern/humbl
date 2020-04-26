import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  RoundButton({
    this.icon = Icons.arrow_back,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: RawMaterialButton(
        elevation: 0,
        highlightElevation: 0,
        constraints: BoxConstraints.tightFor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        fillColor: Colors.transparent,
        splashColor: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            this.icon,
            color: this.onPressed != null ? Colors.black87 : Colors.grey,
          ),
        ),
        onPressed: this.onPressed,
      ),
    );
  }
}
