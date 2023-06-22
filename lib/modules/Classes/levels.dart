import 'package:flutter/material.dart';
import 'package:multi_quiz_s_t_tt9/widgets/my_outline_btn.dart';

class Level {
  String levelName;
  String levelDesc;
  String image_path;
  MYOutlineBtn myOutlineBtn;

  Function() function;
  List<Color> colors;
  Level(
      {required this.function,
      required this.levelName,
      required this.levelDesc,
      required this.image_path,
      required this.colors,
      required this.myOutlineBtn});


}
