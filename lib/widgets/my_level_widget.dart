import 'package:flutter/material.dart';
import 'package:multi_quiz_s_t_tt9/constants.dart';
import 'package:multi_quiz_s_t_tt9/modules/Classes/levels.dart';
import 'package:multi_quiz_s_t_tt9/widgets/my_outline_btn.dart';

class MyLevelWidget extends StatelessWidget {
  final Function() function;
  final Level level;

  const MyLevelWidget({
    required this.level,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 54, bottom: 24),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: level.colors,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 44,
                  width: 44,
                  child: level.myOutlineBtn,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  level.levelName,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white60,
                    fontFamily: kFontFamily,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  level.levelDesc,
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: kFontFamily,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 28.0),
            child: Image.asset(level.image_path),
          ),
        ],
      ),
    );
  }
}
