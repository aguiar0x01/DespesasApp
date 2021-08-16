import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptativeButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;
  final bool bold;

  const AdaptativeButton({
    required this.label,
    required this.onPressed,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            // Botão IOS
            child: Text(label,
                style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                )),
            onPressed: onPressed,
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
          )
        : ElevatedButton(
            // Botão Android
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onPressed: onPressed,
            // estilo do botão
            style: ButtonStyle(
                // .all() resolve todos os estados de MaterialStateProperty
                backgroundColor: MaterialStateProperty.all(
              Theme.of(context).primaryColor,
            )),
          );
  } // build
}
