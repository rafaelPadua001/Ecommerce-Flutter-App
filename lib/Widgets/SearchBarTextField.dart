import 'package:flutter/material.dart';

class SearchBarTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical:  16),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a name product'
            ),
          ),
        ),
      ],
    );
  }
}