// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'consts.dart';

ScaffoldFeatureController scaffoldMessenger(BuildContext context, text) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      text,
      textAlign: TextAlign.center,
    ),
    backgroundColor: primaryColor,
  ));
}
