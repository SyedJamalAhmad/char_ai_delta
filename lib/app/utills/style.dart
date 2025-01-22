import 'package:character_ai_delta/app/utills/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:heart_rate/app/utilities/colors.dart';
//import 'package:junk_cleaner/app/utilities/size_config.dart';

class StyleSheet {
  static const home_text = TextStyle(
      fontSize: 25, fontWeight: FontWeight.bold, color: AppColors.white_color);
  static const home_sub_text = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.white_color);

  static const view_heading =
      TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
  static const title_heading =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  // static const sub_heading = TextStyle(
  //     color: AppColors.white_color, fontSize: 12, fontStyle: FontStyle.normal);
  static const sub_heading = TextStyle(
      color: AppColors.white_color, fontSize: 12, fontStyle: FontStyle.normal);
  static const noteHeading = TextStyle(
      color: AppColors.white_color, fontSize: 12, fontStyle: FontStyle.normal);
  static const sub_heading12 =
      TextStyle(fontSize: 15, fontStyle: FontStyle.italic);
  static const sub_heading2 =
      TextStyle(fontSize: 18, fontStyle: FontStyle.italic);
  static const Intro_heading = TextStyle(
      color: AppColors.white_color, fontSize: 25, fontStyle: FontStyle.italic);
  static const Subscription_heading = TextStyle(
      color: AppColors.white_color, fontSize: 25, fontWeight: FontWeight.bold);
  static const Intro_Sub_heading = TextStyle(
      color: AppColors.white_color, fontSize: 15, fontStyle: FontStyle.normal);
  static const chipStyle = TextStyle(
      color: AppColors.white_color, fontSize: 13, fontStyle: FontStyle.italic);
  static const Intro_Sub_heading_black = TextStyle(
      color: AppColors.black_color, fontSize: 15, fontStyle: FontStyle.italic);
  static const Card_heading_black = TextStyle(
      color: AppColors.black_color, fontSize: 20, fontStyle: FontStyle.italic);
  static const Intro_Sub_heading5 = TextStyle(
      color: AppColors.white_color, fontSize: 25, fontStyle: FontStyle.italic);
  static const Intro_Sub_heading2 =
      TextStyle(color: AppColors.white_color, fontSize: 15);
  static const Intro_Sub_heading3 = TextStyle(
    color: AppColors.white_color,
    fontSize: 15,
    decoration: TextDecoration.underline,
  );

  // static MarkdownStyleSheet darkMarkdownStyleSheet = MarkdownStyleSheet(
  //     a: TextStyle(
  //       fontSize: SizeConfig.blockSizeHorizontal * 0.2,
  //       color: Colors.blue, // Link text color
  //       decoration: TextDecoration.underline, // Underline links
  //     ),
  //     p: TextStyle(
  //       fontSize: SizeConfig.blockSizeHorizontal * 0.2,

  //       color: Colors.white, // Paragraph text color
  //     ),
  //     h1: TextStyle(
  //       color: Colors.white, // Header 1 text color
  //       fontSize: 24.0, // Header 1 font size
  //       fontWeight: FontWeight.bold, // Header 1 font weight
  //     ),
  //     h2: TextStyle(
  //       color: Colors.white, // Header 2 text color
  //       fontSize: 20.0, // Header 2 font size
  //       fontWeight: FontWeight.bold, // Header 2 font weight
  //     ),
  //     h3: TextStyle(
  //       color: Colors.white, // Header 3 text color
  //       fontSize: 18.0, // Header 3 font size
  //       fontWeight: FontWeight.bold, // Header 3 font weight
  //     ),
  //     code: TextStyle(
  //       color: Colors.yellow, // Code block text color
  //       backgroundColor: Colors.black, // Code block background color
  //     ),
  //     blockquote: TextStyle(
  //       fontSize: SizeConfig.blockSizeHorizontal * 0.2,

  //       color: Colors.grey, // Blockquote text color
  //       fontStyle: FontStyle.italic, // Italicize blockquote text
  //       decoration: TextDecoration.underline, // Underline blockquote text
  //     ),
  //     tableHead: TextStyle(
  //       fontSize: SizeConfig.blockSizeHorizontal * 0.2,

  //       color: Colors.white, // Table header text color
  //       fontWeight: FontWeight.bold, // Table header font weight
  //     ),
  //     tableBody: TextStyle(
  //       fontSize: SizeConfig.blockSizeHorizontal * 0.2,

  //       color: Colors.white, // Table body text color
  //     ),
  //     listBullet: TextStyle(
  //       fontSize: SizeConfig.blockSizeHorizontal * 0.2,

  //       color: Colors.white, // Table body text color
  //     ));
}
