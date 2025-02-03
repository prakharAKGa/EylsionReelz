import 'package:flutter/material.dart';

Widget buildErrorWidget(String error) {
  return Center(
    child: 
      Text(
        error,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.bold
        ),
      ),
    
  );
}
