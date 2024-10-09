import 'package:flutter/material.dart';

// OptionSelector.dart

class OptionButton extends StatefulWidget {
  final List<String> options;
  final ValueChanged<String> onSelected;
  final double valueFontSize;
  final double valueWidth;
  final double valueHeight;
  final String initOption;
  final double buttonWidth;
  final double intervalWidth;
  final bool showText;

  const OptionButton({
    Key? key,
    required this.options,
    required this.onSelected,
    required this.initOption,
    this.valueFontSize = 25,
    this.valueWidth = 350,
    this.valueHeight = 90,
    this.buttonWidth = 0.3,
    this.intervalWidth = 0.01,
    this.showText = false,
  }) : super(key: key);
  @override
  _OptionButtonState createState() => _OptionButtonState();
}

class _OptionButtonState extends State<OptionButton> {
  late String _selectedOption = widget.initOption;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.showText)
          Container(
            padding: const EdgeInsets.all(10),
            width: widget.valueWidth,
            height: widget.valueHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xff7392ff),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _selectedOption,
              style: TextStyle(
                  fontSize: widget.valueFontSize, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        if (widget.showText)
          SizedBox(height:  MediaQuery.of(context).size.height*0.03,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.options.map((option) {
            bool isSelected = _selectedOption == option;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedOption = option;
                });
                widget.onSelected(option); // Notify the parent widget about the selection.
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 60,
                width: MediaQuery.of(context).size.width*widget.buttonWidth*0.9,
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*widget.intervalWidth*0.9),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xff7392ff) : Color(0xffd9d9d9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}