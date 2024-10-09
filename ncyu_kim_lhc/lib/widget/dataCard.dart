
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum IconType { material, cupertino, svg }

class CustomIcon {
  IconData? materialIcon;
  IconData? cupertinoIcon;
  String? svgPath;
  IconType type;

  CustomIcon.material(this.materialIcon) : type = IconType.material, cupertinoIcon = null, svgPath = null;
  CustomIcon.cupertino(this.cupertinoIcon) : type = IconType.cupertino, materialIcon = null, svgPath = null;
  CustomIcon.svg(this.svgPath) : type = IconType.svg, materialIcon = null, cupertinoIcon = null;

  Widget getIcon({required Color color, required double size}) {
    switch (type) {
      case IconType.material:
        return Icon(materialIcon, color: color, size: size);
      case IconType.cupertino:
        return Icon(cupertinoIcon, color: color, size: size);
      case IconType.svg:
        return SvgPicture.asset(
          svgPath!,
          color: color,
          width: size,
          height: size,
          colorBlendMode: BlendMode.srcIn,
        );
      default:
        return Container();
    }
  }
}

class CustomDataCard extends StatelessWidget {
  final CustomIcon customIconData;
  final double iconSize;
  final String titleText;
  final FontWeight titleWeight;
  final String ratingText;
  final FontWeight textWeight;
  final double titleTextSize;
  final double ratingTextSize;
  final Color textColor;
  final Color backgroundColor;
  final double? cardWidth;
  final double cardHeight;
  final int marginBetween;
  final TextAlign ratingAlign;
  final Alignment ratingAlignment;

  const CustomDataCard({
    Key? key,
    required this.customIconData,
    this.iconSize = 35,
    required this.titleText,
    this.titleWeight = FontWeight.bold,
    required this.ratingText,
    this.textWeight = FontWeight.bold,
    required this.titleTextSize,
    required this.ratingTextSize,
    this.textColor = Colors.black,
    this.backgroundColor = const Color(0xffd9d9d9),
    this.cardWidth,
    this.cardHeight = 150,
    this.marginBetween = 10,
    this.ratingAlign = TextAlign.start,
    this.ratingAlignment = Alignment.bottomRight,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double effectiveCardWidth = cardWidth ?? MediaQuery.of(context).size.width * 0.9;
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color(0xffd9d9d9),
            blurRadius: 4,
            offset: Offset(4, 8), // Shadow position
          ),
        ],
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(20),
        color: backgroundColor,
      ),
      width: effectiveCardWidth,
      height: cardHeight,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              customIconData.getIcon(color: textColor, size: iconSize),
              const SizedBox(width: 10),
              Text(titleText, style: TextStyle(fontSize: titleTextSize, fontWeight: titleWeight, color: textColor)),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.width*0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                alignment: ratingAlignment,
                width: 300,
                margin: EdgeInsets.only(top: marginBetween.toDouble(),right: 20),
                child:
                Text(
                  ratingText,
                  softWrap:true,
                  style: TextStyle(
                      fontWeight: textWeight,
                      fontSize: ratingTextSize,
                      color: textColor),
                  textAlign: ratingAlign,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
