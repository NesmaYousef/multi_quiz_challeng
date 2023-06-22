import 'package:flutter/material.dart';
import 'package:multi_quiz_s_t_tt9/constants.dart';
import 'package:multi_quiz_s_t_tt9/modules/Classes/levels.dart';
import 'package:multi_quiz_s_t_tt9/pages/level_describtion.dart';
import 'package:multi_quiz_s_t_tt9/pages/multiple_q_screen.dart';
import 'package:multi_quiz_s_t_tt9/widgets/my_outline_btn.dart';

import '../widgets/my_level_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    List<Level> levels = [
      Level(
          function: () {},
          levelName: "level1",
          levelDesc: "True or False",
          image_path: "assets/images/bags.png",
          colors: [kL1, kL12],
          myOutlineBtn: MYOutlineBtn(
            icon: Icons.check,
            bColor: Colors.white,
            function: () {},
            iconColor: Colors.white,
            shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          )),
      Level(
          function: () {},
          levelName: "level2",
          levelDesc: "MCQ",
          image_path: "assets/images/ballon-s.png",
          colors: [kL2, kL22],
          myOutlineBtn: MYOutlineBtn(
              icon: Icons.play_arrow,
              bColor: Colors.white,
              function: () {},
              iconColor: Colors.white,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              )))
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          MYOutlineBtn(
            icon: Icons.favorite,
            iconColor: kBlueIcon,
            bColor: kGreyFont.withOpacity(0.5),
            function: () {
              print("11111");
            },
          ),
          MYOutlineBtn(
              icon: Icons.person,
              iconColor: kBlueIcon,
              bColor: kGreyFont.withOpacity(0.5),
              function: () {
                print("2222");
              }),
          SizedBox(
            width: 16,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Let\'s Play',
              style: TextStyle(
                fontSize: 32,
                color: kRedFont,
                fontWeight: FontWeight.bold,
                fontFamily: kFontFamily,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Be the First!',
              style: TextStyle(
                fontSize: 18,
                color: kGreyFont,
                fontFamily: kFontFamily,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: levels.length,
                  itemBuilder: (context, index) {
                    return MyLevelWidget(
                        level: levels[index],
                        function: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LevelDescription(
                                        levels[index],
                                      )));
                        });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
