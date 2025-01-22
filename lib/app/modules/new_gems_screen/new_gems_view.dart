import 'package:character_ai_delta/app/utills/images.dart';
import 'package:character_ai_delta/app/utills/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class newGemsView extends StatelessWidget {
  const newGemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 10),
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppImages.gems_background),
                fit: BoxFit.fill)),
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  claim_reward("CLAIM YOUR"),
                  claim_reward("REWARD"),
                  verticalSpace(SizeConfig.blockSizeVertical * 4),
                  Container(
                    height: SizeConfig.blockSizeVertical * 65,
                    width: SizeConfig.blockSizeHorizontal * 70,
                    decoration: BoxDecoration(
                        color: Color(0xFF2A333C),
                        border: Border.all(color: Color(0xFFB02DA6), width: 3),
                        borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal * 3)),
                    child: Column(
                      children: [
                        Image.asset(AppImages.new_gems),
                        Text(
                          "X300",
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: SizeConfig.blockSizeHorizontal * 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                        Container(
                          width: SizeConfig.blockSizeHorizontal * 70,
                          padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 3),
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Can be used till\n",
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal * 7,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "date time",
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal * 7,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: SizeConfig.blockSizeVertical * 67.5,
              left: SizeConfig.blockSizeHorizontal * 25,
              child: Container(
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 10),
                height: SizeConfig.blockSizeVertical * 6,
                width: SizeConfig.blockSizeHorizontal * 50,
                decoration: BoxDecoration(
                    gradient: RadialGradient(
                        colors: [Color(0xFFBF34B9), Color(0xFFBF34B9)]),
                    borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 9),
                    border: Border.all(color: Colors.white, width: 2)),
                child: Center(
                  child: Text(
                    "CLAIM NOW",
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 6,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Text claim_reward(String text) {
    return Text(text,
        style: GoogleFonts.inter(
          textStyle: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 9,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                    // bottomLeft
                    offset: Offset(-1.5, -1.5),
                    color: Color(0xFFB02DA6)),
                Shadow(
                    // bottomRight
                    offset: Offset(1.5, -1.5),
                    color: Color(0xFFB02DA6)),
                Shadow(
                    // topRight
                    offset: Offset(1.5, 1.5),
                    color: Color(0xFFB02DA6)),
                Shadow(
                    // topLeft
                    offset: Offset(-1.5, 1.5),
                    color: Color(0xFFB02DA6)),
              ]),
        ));
  }
}
