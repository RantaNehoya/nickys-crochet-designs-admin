import 'package:flutter/material.dart';
import 'package:nickys_crochet_designs/presentation/resources/string_manager.dart';
import 'package:nickys_crochet_designs/utilities/palette.dart';

Center kProgressIndicator = Center(
  child: CircularProgressIndicator(
    color: ColorPalette.colorPalette.shade600,
  ),
);

const Center kErrorMessage = Center(
  child: Text(
    StringManager.errorMessage,
  ),
);

const Center kNoStock = Center(
  child: Text(
    StringManager.noStock,
  ),
);

const SnackBar kSnackBar = SnackBar(
  content: Text(
    StringManager.errorMessage,
  ),
);
