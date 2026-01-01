import 'package:flutter/material.dart';

class TextItem extends StatelessWidget {
  const TextItem({Key? key, required this.labelText}) : super(key: key);
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: MediaQuery.of(context).size.width - 70,
      child: TextFormField(
        // style: te,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.redAccent[100],
            fontSize: 17,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}