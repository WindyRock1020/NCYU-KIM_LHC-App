import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingCard extends StatelessWidget {
  final dynamic icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showMod;
  final Color cardColor;
  final Color textColor;

  const SettingCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showMod = true,
    this.cardColor = const Color(0xffd9d9d9),
    this.textColor = const Color(0xff000000),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIcon(),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 20, color: textColor),
                      ),
                      Text(
                        "$subtitle 分",
                        style: TextStyle(fontSize: 20, color: textColor),
                      ),
                    ],
                  ),
                ),
              ),
              if (showMod)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30),
                )
            ],
          ),
        ),
        // child: Center(
        //   child: ListTile(
        //     leading: _buildIcon(),
        //     title: Text(
        //       title,
        //       style: const TextStyle(fontSize: 20, color: Colors.black),
        //     ),
        //     subtitle: Container(
        //       child: Text(
        //         "$subtitle 分",
        //         style: const TextStyle(fontSize: 20, color: Colors.black),
        //       ),
        //     ),
        //     trailing: showMod ? Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30) : null,
        //   ),
        // ),
      ),
    );
  }

  Widget _buildIcon() {
    if (icon is String) {
      // Assuming it's an SVG asset path
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SvgPicture.asset(
          icon,
          width: 50,
          height: 50,
          color: textColor,
        ),
      );
    } else if (icon is IconData) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Icon(
          icon,
          size: 40,
          color: textColor,
        ),
      );
    } else {
      throw Exception('Unsupported icon type');
    }
  }
}


class CheckCard extends StatelessWidget {
  final dynamic icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showMod;
  final Color cardColor;
  final Color textColor;

  const CheckCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showMod = true,
    this.cardColor = const Color(0xffd9d9d9),
    this.textColor = const Color(0xff000000),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildIcon(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 25, color: textColor),
                    ),
                  ],
                ),
              ],
            ),
            // 右侧内容：Subtitle
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                "$subtitle 分",
                style: TextStyle(fontSize: 25, color:textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (icon is String) {
      // Assuming it's an SVG asset path
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SvgPicture.asset(
          icon,
          width: 50,
          height: 50,
          color: textColor,
        ),
      );
    } else if (icon is IconData) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Icon(
          icon,
          size: 50,
          color: textColor  ,
        ),
      );
    } else {
      throw Exception('Unsupported icon type');
    }
  }
}
